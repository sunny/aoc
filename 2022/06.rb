input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"

# input = File.read("06.txt")

size = 14
p size + input.chars.each_cons(size).find_index { _1.uniq.size == size }
