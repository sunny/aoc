require "./compare_packets"
require "json"

input = "[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]"

# input = File.read("13.txt")

# Part 1

results = input.split("\n\n").map do |lines|
  compare_packets(*lines.lines.map { JSON.parse(_1) })
end

p results.each.with_index(1).select { |v, _| v == -1 }.sum { _2 }

# Part 2

dividers = [[[2]], [[6]]]
packets = input.split(/\n+/).map { JSON.parse(_1) }
packets.concat(dividers).sort! { compare_packets(_1, _2) }

p dividers.map { packets.index(_1) +1 }.reduce(:*)
