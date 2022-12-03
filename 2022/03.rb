require "active_support/core_ext/array/grouping"

input = "vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw"

# input = File.read("03.txt")

positions = [nil, *"a".."z", *"A".."Z"]

sum = input.split("\n").sum do |line|
  positions.index(line.chars.in_groups(2).reduce(:&).first)
end
p sum

sum = input.lines.each_slice(3).sum do |group|
  positions.index(group.map(&:chars).reduce(:&).first)
end
p sum
