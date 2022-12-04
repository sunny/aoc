require "active_support/core_ext/range/overlaps"

input = "2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8"

input = File.read("04.txt")

total = input.lines.count do |line|
  line
    .split(",")
    .map { Range.new(*_1.split("-").map(&:to_i)) }
    .reduce(:overlaps?)
end

puts total
