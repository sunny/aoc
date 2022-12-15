input = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
"

class Scan
  attr_reader :grid, :min_x, :max_x, :min_y, :max_y, :sensors

  def initialize(input, min_x: 0, max_x: nil, min_y: 0, max_y: nil)
    @grid = Hash.new { |h, x| h[x] = Hash.new { |l, y| l[y] = nil } }
    @min_x = min_x
    @max_x = max_x
    @min_y = min_y
    @max_y = max_y
    @sensors = input.each_line.map do |line|
      Sensor.new(*line.scan(/([-\d]+)/).flatten.map(&:to_i))
    end
  end

  def x_ranges_for_y(y)
    ranges = sensors.map { _1.x_range_for_y(y, min_x, max_y) }
    ranges.compact!
    ranges.sort_by!(&:begin)
  end

  def coverage_for(y)
    x_ranges_for_y(y).reduce([]) do |ranges, range|
      if ranges.empty?
        ranges.push range
        next ranges
      end
      last_range = ranges.pop
      new_range = merge_range(last_range, range) || range
      ranges.push new_range
      ranges
    end.first
  end

  def merge_range(range, other)
    if range.cover?(other.begin) && range.cover?(other.end)
      range
    elsif range.cover?(other.begin)
      range.begin..other.end
    elsif range.cover?(other.end)
      other.begin..range.end
    else
      nil
    end
  end

  def result
    (min_y..max_y).each do |y|
      cov = coverage_for(y)
      return (cov.begin - 1) * 4_000_000 + y if cov.begin != min_x
    end
  end
end

class Sensor < Struct.new(:x, :y, :beacon_x, :beacon_y)
  def dx = (beacon_x - x).abs
  def dy = (beacon_y - y).abs
  def min_x = x - dx - dy
  def max_x = x + dx + dy
  def min_y = y - dx - dy
  def max_y = y + dx + dy

  def x_range_for_y(target_y, from_x, to_x)
    return if target_y > max_y || target_y < min_y
    target_y_diff = (y - target_y).abs

    [min_x + target_y_diff, from_x].max..[max_x - target_y_diff, to_x].min
  end
end

scan = Scan.new(input, max_x: 20, max_y: 20)
p scan.result
