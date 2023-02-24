require 'snappy'
require 'zstandard'
require 'benchmark'
require 'securerandom'

# data = File.read('payload.tar')
data = SecureRandom.bytes(1024 * ARGV[0].to_i)

def manytimes(&b)
  res = []
  4.times do
    res << Benchmark.measure { 500.times(&b) }
  end
  v = b.call

  [res.map(&:real).sum / 5.0, v]
end

def bytekb(v)
  v < 1024 ? v : (v < 1048576 ? ("%.2fkb" % [v/1024.0]) : ("%.2fmb" % [v/1048576.0]))
end

puts "Data len: #{bytekb(data.length)}"

t, compressed =  manytimes { Snappy.deflate(data) }
puts "Snappy: #{bytekb(compressed.length)} (#{t * 1000})"

t, _ =  manytimes { Snappy.inflate(compressed) }
puts "Snappy inflate: (#{t * 1000})"

t, compressed = manytimes { Zstandard.deflate(data) }
puts "zstd: #{bytekb(compressed.length)} (#{t * 1000})"

t, _ =  manytimes { Zstandard.inflate(compressed) }
puts "zstd inflate: (#{t * 1000})"
