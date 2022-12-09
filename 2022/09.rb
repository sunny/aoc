input = "R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20"

# input = File.read("09.txt")

class Rope
  attr_reader :x, :y, :positions, :tail

  def initialize(length)
    @x = 0
    @y = 0
    @positions = [[0, 0]]
    @tail = Rope.new(length - 1) if length >= 1
  end

  def move(to_x, to_y)
    @x += to_x
    @y += to_y
    positions << [x, y]

    if tail && ((x - tail.x).abs > 1 || (y - tail.y).abs > 1)
      tail.move(x <=> tail.x, y <=> tail.y)
    end
  end

  def tail_end = tail&.tail_end || self
end

rope = Rope.new(9)

input.each_line do |line|
  direction, steps = line.split
  steps.to_i.times do
    case direction
    when "R" then rope.move(1, 0)
    when "L" then rope.move(-1, 0)
    when "U" then rope.move(0, 1)
    when "D" then rope.move(0, -1)
    end
  end
end

p rope.tail_end.positions.uniq.count
