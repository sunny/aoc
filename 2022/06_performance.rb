require "benchmark"

# input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"

input = File.read("06.txt")

to_a_index = -> size do
  size + input.chars.each_cons(size).find_index { _1.uniq.size == size }
end

lazy_index = -> n do
  input.each_char.lazy.each_cons(n).each_with_index do
    return _2 + n if _1.uniq.size == n
  end
end

p to_a_index.call(14)
p lazy_index.call(14)

times = 1_000
Benchmark.bm do |x|
  x.report("to_a_index") { times.times { to_a_index.call(14) } }
  x.report("lazy_index") { times.times { lazy_index.call(14) } }
end
