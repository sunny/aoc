input = "00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"

# input = File.read("3.txt")

def sorted_bits(lines, n)
  lines.map { _1[n] }.tally.map(&:reverse).sort.map(&:last)
end

def lines_matching_big_at_position(lines, bit, position)
  lines.select { |line| line[position] == bit }
end

def rating(position, lines)
  lines.first.chars.each_with_index do |_, n|
    bit = sorted_bits(lines, n).send(position)
    lines = lines_matching_big_at_position(lines, bit, n)
    return lines.first.to_i(2) if lines.count == 1
  end
end

lines = input.split("\n")

p rating(:last, lines) * rating(:first, lines)
