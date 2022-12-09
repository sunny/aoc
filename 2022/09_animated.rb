require "tty-cursor"

class Rope
  attr_reader :x, :y, :positions, :tail, :mark

  def initialize(x: 0, y: 0, length: 1, mark: 0)
    @x = x
    @y = y
    @positions = [[x, y]]
    @mark = mark
    return if length < 1

    @tail = Rope.new(x: x, y: y, length: length - 1, mark: mark + 1)
  end

  def move(to_x, to_y)
    @x += to_x
    @y += to_y
    positions << [x, y]

    if tail && ((x - tail.x).abs > 1 || (y - tail.y).abs > 1)
      tail.move(x <=> tail.x, y <=> tail.y)
    end
  end

  def tails = [self, *tail&.tails].compact
end

input = "R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"

start_x = 11
start_y = 5
grid_end_x = 25
grid_end_y = 20

# input = File.read("09.txt")
# start_x = 126
# start_y = 75
# grid_end_x = 167
# grid_end_y = 540

rope = Rope.new(x: start_x, y: start_y, length: 9)
cursor = TTY::Cursor

cursor.invisible do
  input.each_line do |line|
    direction, steps = line.split
    steps.to_i.times do
      case direction
      when "R" then rope.move(1, 0)
      when "L" then rope.move(-1, 0)
      when "U" then rope.move(0, 1)
      when "D" then rope.move(0, -1)
      end

      # Clear screen
      print cursor.clear_lines(grid_end_y + 3)
      print line
      lines = grid_end_y.downto(0).map do |j|
        0.upto(grid_end_x).map do |i|
          mark = rope.tails.find { _1.x == i && _1.y == j }&.mark
          if mark && mark == 0
            "H"
          elsif mark
            mark
          elsif start_x == i && start_y == j
            "s"
          else
            "."
          end
        end
      end
      puts lines.map { _1.join }.join("\n")
      sleep 0.1
    end
  end
end

p rope.tails.last.positions.uniq.count
