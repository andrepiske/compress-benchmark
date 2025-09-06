require 'snappy'
require 'zstd-ruby'
require 'benchmark'
require 'securerandom'
require 'zlib'
require 'extlz4'
require 'brotli'

puts "Reading file #{ARGV[0]}"
data = File.read(ARGV[0])

def manytimes(&b)
  tt = Integer(ENV.fetch('ITIMES'))
  res = []
  tt.times do
    res << Benchmark.measure(&b)
  end
  v = b.call

  [res.map(&:real).sum / tt.to_f, v]
end

def bytekb(v)
  v < 1024 ? v : (v < 1048576 ? ("%.2fkb" % [v/1024.0]) : ("%.2fmb" % [v/1048576.0]))
end

puts "Data len: #{bytekb(data.length)}"

def testlib(name, data, &fun)
  t, compressed =  manytimes { fun.call(true, data) }
  puts "#{name}: #{'%.3f' % (t * 1000)}ms (#{bytekb(compressed.length)})"

  t, _ = manytimes { fun.call(false, compressed) }
  puts "#{name} inflate: #{'%.3f' % (t * 1000)}ms"
end

testlib("LZ4", data) do |c, d|
  c ? LZ4.encode(d) : LZ4.decode(d)
end

testlib("Snappy", data) do |c, d|
  c ? Snappy.deflate(d) : Snappy.inflate(d)
end

testlib("Zstd-1", data) do |c, d|
  c ? Zstd.compress(d, level: 1) : Zstd.decompress(d)
end

testlib("Zstd-4", data) do |c, d|
  c ? Zstd.compress(d, level: 4) : Zstd.decompress(d)
end

testlib("Brotli", data) do |c, d|
  c ? Brotli.deflate(d, quality: 2) : Brotli.inflate(d)
end

testlib("Zlib", data) do |c, d|
  c ? Zlib::Deflate.deflate(d) : Zlib::Inflate.inflate(d)
end
