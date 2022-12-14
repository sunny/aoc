require "tty-cursor"
require "pastel"

input = "498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9"

# input = File.read("14.txt")

class Cave
  attr_reader :grid, :units_of_sand, :filled

  def initialize
    @grid = Hash.new { |h, x| h[x] = Hash.new { |l, y| l[y] = nil } }
    @units_of_sand = 0
    @filled = false
  end

  def min_y = 0
  def max_y = @max_y ||= grid.values.flat_map(&:keys).max + 2
  def min_x = @min_x ||= grid.keys.min - 150
  def max_x = @max_x ||= grid.keys.max + 150

  def [](x, y) = y >= max_y ? "#" : grid[x][y]

  def []=(x, y, value)
    grid[x][y] = value
  end

  def fill
    until filled
      drop_sand(500, 0)
      @units_of_sand += 1
      show if units_of_sand % 10 == 0
    end
  end

  def drop_sand(x, y)
    return @filled = true if self[x, y]

    while y += 1
      next unless self[x, y]

      break drop_sand(x - 1, y) unless self[x - 1, y]
      break drop_sand(x + 1, y) unless self[x + 1, y]

      break self[x, y - 1] = "o"
    end
  end

  def show
    TTY::Cursor.invisible do
      lines = min_y.upto(max_y).map do |y|
        min_x.upto(max_x).map do |x|
          case self[x, y]
          when "#" then Pastel.new.red("#")
          when "o" then Pastel.new.yellow("o")
          else " "
          end
        end.join
      end

      system "clear"
      puts lines.join("\n") + "\n"*5
    end
  end
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
