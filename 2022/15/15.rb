require "multi_range"

Scanner = Struct.new(:sensors) do
  def y_max = 4_000_000

  def tuning_frequency
    0.upto(y_max) do |y|
      ranges = sensors.filter_map { _1.range(y) }
      merged = MultiRange.new(ranges).merge_overlaps.ranges
      return merged.first.end * y_max + y if merged.size != 1
    end
  end
end

Sensor = Struct.new(:x, :y, :beacon_x, :beacon_y) do
  def range(scanned_y)
    y_dist = (y - scanned_y).abs
    (x - distance + y_dist)..(x + distance - y_dist) if distance > y_dist
  end

  def distance = @distance ||= (x - beacon_x).abs + (y - beacon_y).abs
end

input = File.readlines("15.txt")
sensors = input.map { Sensor.new(*_1.scan(/[-\d]+/).flat_map(&:to_i)) }
p Scanner.new(sensors).tuning_frequency
