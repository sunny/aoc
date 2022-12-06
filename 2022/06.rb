input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"

# input = File.read("06.txt")

n = 14
p n + input.chars.each_cons(n).to_a.index { _1.uniq.size == n }
