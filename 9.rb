input = "2199943210
3987894921
9856789892
8767896789
9899965678"

# input = File.read("9.txt")

class Point
  def initialize(value, x, y, map)
    @value = value
    @x = x
    @y = y
    @map = map
  end

  attr_reader :value, :x, :y, :map

  def adjacent_points
    [
      map.point_at(x, y - 1),
      map.point_at(x + 1, y),
      map.point_at(x, y + 1),
      map.point_at(x - 1, y),
    ].compact
  end

  def basin?
    value < 9
  end

  def risk
    value + 1
  end

  def low?
    adjacent_points.all? { value < _1.value }
  end

  def basin_points(exclude: [])
    next_points = adjacent_points.select(&:basin?) - exclude
    next_points.reduce([self]) do |basins, point|
      basins + point.basin_points(exclude: basins + exclude)
    end.uniq
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def inspect
    "<Point value=#{value} x=#{x} y=#{y}>"
  end
end

class Map
  attr_reader :lines, :max_x, :max_y

  def initialize(input)
    @lines = input.lines.map { |line| line.chomp.chars.map(&:to_i) }
    @max_x = lines.first.size
    @max_y = lines.size
  end

  def points
    @points ||= lines.each_with_index.map do |line, y|
      line.each_with_index.map do |value, x|
        Point.new(value, x, y, self)
      end
    end
  end

  def point_at(x, y)
    return if x < 0 || y < 0 || x >= max_x || y >= max_y

    points[y][x]
  end
end

basins = Map.new(input).points.flatten.select(&:low?).map(&:basin_points)

p basins.map(&:size).sort.reverse[0...3].inject(:*)
