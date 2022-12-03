input = "vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw"

# input = File.read("03.txt")

positions = [nil, *"a".."z", *"A".."Z"]

sum = input.split("\n").sum do |line|
  chars = line.chars.each_slice(line.size / 2)
  positions.index(chars.inject(:&).first)
end
p sum

sum = input.lines.each_slice(3).sum do |group|
  positions.index(group.map(&:chars).inject(:&).first)
end
p sum
