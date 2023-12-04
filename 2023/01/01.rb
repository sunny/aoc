# Part 1

# input = "1abc2
# pqr3stu8vwx
# a1b2c3d4e5f
# treb7uchet"

input = File.read("01.txt")

result = input.lines.sum do |line|
  digits = line.scan(/\d/)
  (digits.first + digits.last).to_i
end

p result

# Part 2

# input = "two1nine
# eightwothree
# abcone2threexyz
# xtwone3four
# 4nineeightseven2
# zoneight234
# 7pqrstsixteen"

input = File.read("01.txt")

WORDS = %w[zero one two three four five six seven eight nine]

def to_digit(string) = WORDS.index(string) || string

result = input.lines.sum do |line|
  first = line.match(/(\d|#{WORDS.join("|")})/)[1]
  last = line.match(/.*(\d|#{WORDS.join("|")})/)[1]
  [to_digit(first), to_digit(last)].join.to_i
end

p result
