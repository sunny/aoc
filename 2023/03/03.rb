# input = "467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598.."

# Part 1

input = File.read("03.txt")

numbers = []
parts = []

lines = input.split
lines.each_with_index do |line, y|
  number = nil

  line.chars.each_with_index do |char, x|
    if char =~ /\d/
      if number
        number[0] += char
      else
        number = [char, x, y]
      end
    else
      parts << [char, x, y] if char != "."

      if number
        numbers << number
        number = nil
      end
    end
  end

  numbers << number if number
end

part_numbers = numbers.select do |number, x, y|
  parts.any? do |_, px, py|
    ((x - 1)..(x + number.length)).cover?(px) && ((y - 1)..(y + 1)).cover?(py)
  end
end

p part_numbers.map(&:first).sum(&:to_i)

# Part 2

input = File.read("03.txt")

numbers = []
gears = []

lines = input.split
lines.each_with_index do |line, y|
  number = nil

  line.chars.each_with_index do |char, x|
    if char =~ /\d/
      if number
        number[0] += char
      else
        number = [char, x, y]
      end
    else
      gears << [[], x, y] if char == "*"

      if number
        numbers << number
        number = nil
      end
    end
  end

  numbers << number if number
end

numbers.each do |number, x, y|
  gear = gears.find do |_, gx, gy|
    ((x - 1)..(x + number.length)).cover?(gx) && ((y - 1)..(y + 1)).cover?(gy)
  end
  gear.first << number.to_i if gear
end

p gears.map(&:first).select { _1.size > 1 }.sum { _1.inject(:*) }
