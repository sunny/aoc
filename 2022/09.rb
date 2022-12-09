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
  attr_reader :x, :y, :tail, :positions

  def initialize(length:)
    @x = 0
    @y = 0
    @positions = [[0, 0]]
    @tail = Rope.new(length: length - 1) if length >= 1
  end

  def tails = [tail, *tail&.tails].compact

  def move_by(x_distance, y_distance)
    @x += x_distance
    @y += y_distance
    positions << [x, y]
    return if !tail

    if x > tail.x + 1 || x < tail.x - 1 || y > tail.y + 1 || y < tail.y - 1
      tail.move_by(x <=> tail.x, y <=> tail.y)
    end
  end
end

r = Rope.new(length: 9)

input.lines.each_with_index do |line, index|
  action, direction = line.split
  direction.to_i.times do
    case action
    when "R" then r.move_by(1, 0)
    when "L" then r.move_by(-1, 0)
    when "U" then r.move_by(0, 1)
    when "D" then r.move_by(0, -1)
    end
  end
end

p r.tails.last.positions.uniq.count
