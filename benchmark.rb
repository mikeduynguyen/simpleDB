require 'benchmark'

hash = {}
count_hash = {}

for i in 1..1000000 do
  hash[rand] = i
  count_hash[i] =+ 1
end

Benchmark.bm do |x|
  x.report { hash.values.count(1) }
  x.report { count_hash[1] }
end

puts hash.values.count(1)
puts count_hash[1]
