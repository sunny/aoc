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
  attr_reader :x, :y, :tail, :name, :positions

  def initialize(x: 0, y: 0, length: 1, name: 0)
    @x = x
    @y = y
    @positions = [[x, y]]
    @name = name

    return unless length >= 1
    @tail = Rope.new(
      x: x,
      y: y,
      length: length - 1,
      name: name + 1
    )
  end

  def tails = [tail, *tail&.tails].compact

  def move_by(x_increment, y_increment)
    self.x += x_increment
    self.y += y_increment
    self.positions << [x, y]
    move_tail if tail
  end

  attr_writer :x, :y

  def move_tail
    if @x == @tail.x && @y != @tail.y
      if @y > @tail.y + 1
        @tail.move_by(0, 1)
      elsif @y < @tail.y - 1
        @tail.move_by(0, -1)
      end
    elsif @x != @tail.x && @y == @tail.y
      if @x > @tail.x + 1
        @tail.move_by(1, 0)
      elsif @x < @tail.x - 1
        @tail.move_by(-1, 0)
      end
    elsif @x > @tail.x + 1
      @tail.move_by(1, @y > @tail.y ? 1 : -1)
    elsif @x < @tail.x - 1
      @tail.move_by(-1, @y > @tail.y ? 1 : -1)
    elsif @y > @tail.y + 1
      @tail.move_by(@x > @tail.x ? 1 : -1, 1)
    elsif @y < @tail.y - 1
      @tail.move_by(@x > @tail.x ? 1 : -1, -1)
    end
  end

  def inspect
    "<#{@x},#{@y}>"
  end

  def position
    [@x, @y]
  end

  def chart
    max_y.downto(0) do |y|
      0.upto(max_x) do |x|
        rope = [self, *tails].find { |t| t.position == [x, y] }
        if rope
          print rope.name
        else
          print "."
        end
      end
      puts
    end
  end

  def chart_past
    max_y.downto(0) do |y|
      0.upto(max_x) do |x|
        if positions.uniq.include?([x, y])
          print "#"
        else
          print "."
        end
      end
      puts
    end
  end

  def max_x = 27
  def max_y = 20
end

r = Rope.new(x: 11, y: 5, length: 9)

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

# 1 is lower than 9177
# p r.tail.positions.uniq.count

# r.chart

# p r.positions.uniq
puts "---"
# r.tails.last.chart_past
p r.tails.last.positions.uniq.count
