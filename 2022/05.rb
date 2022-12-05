input = "    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2"

# input = File.read("05.txt")

start, instructions = input.split(/\n 1.*\n\n/)

crates = Hash.new { |h, k| h[k] = [] }
start.lines.reverse.each do |line|
  chars = line.chars.each_slice(4).map { _1[1] }
  chars.each.with_index(1) do |char, index|
    crates[index] << char if char != " "
  end
end

instructions.lines.each do |line|
  count, from, to = line.scan(/\d+/).map(&:to_i)
  crates[to] += crates[from].pop(count)
end

puts crates.values.map(&:last).join
