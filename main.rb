require 'snappy'
require 'zstandard'
require 'benchmark'
require 'securerandom'
require 'zlib'
require 'extlz4'

# data = File.read('payload.tar')
data = File.read('bigpayload')
# data = SecureRandom.bytes(1024 * ARGV[0].to_i)

def manytimes(&b)
  tt = Integer(ENV.fetch('ITIMES'))
  res = []
  tt.times do
    res << Benchmark.measure(&b) # { 10.times(&b) }
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
  puts "#{name}: #{t * 1000}ms (#{bytekb(compressed.length)})"

  t, _ =  manytimes { fun.call(false, compressed) }
  puts "#{name} inflate: #{t * 1000}ms"
end

testlib("LZ4", data) do |c, d|
  c ? LZ4.encode(d) : LZ4.decode(d)
end

testlib("Snappy", data) do |c, d|
  c ? Snappy.deflate(d) : Snappy.inflate(d)
end

testlib("Zstandard", data) do |c, d|
  c ? Zstandard.deflate(d) : Zstandard.inflate(d)
end

testlib("Zlib", data) do |c, d|
  c ? Zlib::Deflate.deflate(d) : Zlib::Inflate.inflate(d)
end

