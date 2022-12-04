input = "6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5"

# input = File.read("13.txt")

def fold(paper, direction, value)
  if direction == "x"
    press(
      paper.transpose[0...value].transpose,
      paper.transpose[value + 1..].transpose.map(&:reverse)
    )
  else
    press(
      paper[0..value - 1],
      paper[value + 1..].reverse
    )
  end
end

def press(side_a, side_b)
  side_a.zip(side_b).map { |a, b| a.zip(b).map(&:sort).map(&:last) }
end

dots, instructions = input.split("\n\n")
dots = dots.lines.map { |line| line.split(",").map(&:to_i) }

paper = Array.new(dots.map(&:last).max + 1) do
  Array.new(dots.map(&:first).max + 1, " ")
end

dots.each { |x, y| paper[y][x] = "█" }

instructions.lines.each do |line|
  direction, value = line.split.last.split("=")
  paper = fold(paper, direction, value.to_i)
end

puts paper.map(&:join)
