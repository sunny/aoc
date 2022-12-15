require "multi_range"

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

require "multi_range"

class Scan < Struct.new(:sensors, :x_range, :y_range)
  def tuning_frequency
    x, y = distress_beacon_coordinates
    x * 4_000_000 + y
  end

  def distress_beacon_coordinates
    y_range.each do |y|
      ranges = MultiRange.new(sensors.map { _1.y_range(y) }).merge_overlaps
      splits = (ranges &= x_range).ranges
      return [splits.first.end + 1, y] if splits.size != 1
    end
  end
end

class Sensor < Struct.new(:x, :y, :beacon_x, :beacon_y)
  def y_range(scanned_y)
    y_distance = (y - scanned_y).abs
    (min_x + y_distance)..(max_x - y_distance)
  end

  def x_difference = (beacon_x - x).abs
  def y_difference = (beacon_y - y).abs
  def min_x = x - x_difference - y_difference
  def max_x = x + x_difference + y_difference
  def min_y = y - x_difference - y_difference
  def max_y = y + x_difference + y_difference
end

sensors = input.lines.map { Sensor.new(*_1.scan(/[-\d]+/).flat_map(&:to_i)) }
p Scan.new(sensors, 0..20, 0..20).tuning_frequency
