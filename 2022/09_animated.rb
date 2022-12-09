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

# input = File.read("09.txt")

start_x = 11
start_y = 5
grid_end_x = 25
grid_end_y = 20
rope = Rope.new(x: start_x, y: start_y, length: 9)

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
    print (grid_end_y + 2).times.map { "\e[2K\e[1G\e[1A" }.join
    print "\e[2K\e[1G"

    # Print grid
    print line
    grid_end_y.downto(0) do |j|
      0.upto(grid_end_x) do |i|
        mark = rope.tails.find { _1.x == i && _1.y == j }&.mark
        if mark && mark == 0
          print "H"
        elsif mark
          print mark
        elsif start_x == i && start_y == j
          print "s"
        else
          print "."
        end
      end
      puts
    end

    sleep 0.1
  end
end

p rope.tails.last.positions.uniq.count
