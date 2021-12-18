# input = "target area: x=20..30, y=-10..-5"
input = "target area: x=135..155, y=-102..-78"

class Probe
  attr_reader :x, :y, :max_y, :x_velocity, :y_velocity, :x_range, :y_range,
              :start_x_velocity, :start_y_velocity

  def initialize(x_velocity, y_velocity, x_range, y_range)
    @x_velocity = @start_x_velocity = x_velocity
    @y_velocity = @start_y_velocity = y_velocity
    @x_range = x_range
    @y_range = y_range
    @x = 0
    @y = 0
    @max_y = 0
  end

  def find
    step until overshot? || found?
    found?
  end

  def step
    @x += x_velocity
    @y += y_velocity
    @max_y = y if y < max_y
    @x_velocity -= 1 if x_velocity > 0
    @y_velocity -= 1
  end

  def found?
    x_range.include?(x) && y_range.include?(y)
  end

  def overshot?
    x > x_range.max || y < y_range.min
  end

  def inspect
    "<Probe v#{start_x_velocity},#{start_y_velocity} max#{max_y} #{state}>"
  end

  def state
    found? ? :found : (overshot? ? :overshot : :moving)
  end
end

x_min, x_max, y_min, y_max = input.scan(/-?\d+/).map(&:to_i)

probes = (1..x_max).flat_map do |x_velocity|
  (y_min..100).filter_map do |y_velocity|
    probe = Probe.new(x_velocity, y_velocity, x_min..x_max, y_min..y_max)
    probe if probe.find
  end
end

p probes.max_by(&:max_y)
p probes.count
