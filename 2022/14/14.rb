input = "498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9"

# input = File.read("14.txt")

class Cave
  attr_reader :grid

  def initialize
    @grid = Hash.new { |h, x| h[x] = Hash.new { |l, y| l[y] = nil } }
  end

  def fill = drop_sand(500, 0) until @full

  def []=(x, y, value)
    grid[x][y] = value
  end

  def units_of_sand = grid.values.flat_map(&:values).count { _1 == "o" }

  private

  def drop_sand(x, y)
    return @full = true if self[x, y]

    while y += 1
      next unless self[x, y]

      break drop_sand(x - 1, y) unless self[x - 1, y]
      break drop_sand(x + 1, y) unless self[x + 1, y]

      break self[x, y - 1] = "o"
    end
  end

  def max_y = @max_y ||= grid.values.flat_map(&:keys).max + 2

  def [](x, y) = y >= max_y ? "#" : grid[x][y]
end

cave = Cave.new

input.each_line do |line|
  pairs = line.scan(/(\d+),(\d+)/).map { _1.map(&:to_i) }
  pairs.each_cons(2) do |(x1, y1), (x2, y2)|
    Range.new(*[x1, x2].sort).each do |x|
      Range.new(*[y1, y2].sort).each do |y|
        cave[x, y] = "#"
      end
    end
  end
end

cave.fill
p cave.units_of_sand
