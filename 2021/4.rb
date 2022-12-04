input = "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7"

# input = File.read("4.txt")

class Board
  def initialize(input)
    @input = input
    @marked = []
  end

  attr_reader :input, :marked

  def mark(number)
    marked << number if lines.flatten.include?(number)
  end

  def complete?
    [lines, rows].any? do |blocks|
      blocks.any? { (_1 & marked).size == 5 }
    end
  end

  def lines
    input.lines.map(&:split).map { _1.map(&:to_i) }
  end

  def rows
    lines.transpose
  end

  def score
    (lines.flatten - marked).sum
  end
end

numbers = input.lines.first.split(",").map(&:to_i)
boards = input.split("\n\n")[1...].map { |b| Board.new(b) }

winner = nil
numbers.each_with_index do |number, _n|
  boards.each_with_index do |b, index|
    next if b.complete?

    b.mark(number)
    if b.complete?
      winner = b
      puts "board #{index} won with #{winner.score * number}"
    end
  end
end
