require "benchmark"

input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"

# input = File.read("06.txt")

n = 14

to_a_index = -> do
  n + input.chars.each_cons(n).to_a.index { _1.uniq.size == n }
end

lazy_index = -> do
  input.each_char.lazy.each_cons(n).each_with_index do
    return _2 + n if _1.uniq.size == n
  end
end

p to_a_index.call
p lazy_index.call

times = 2_000
Benchmark.bm do |x|
  x.report("to_a_index") { times.times { to_a_index.call } }
  x.report("lazy_index") { times.times { lazy_index.call } }
end
