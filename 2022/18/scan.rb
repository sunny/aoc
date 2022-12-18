require "set"

class Scan
  attr_accessor :grid

  def initialize(input)
    @grid = {}

    input.each_line do |line|
      x, y, z = line.split(",").map(&:to_i)
      grid[x] ||= {}
      grid[x][y] ||= {}
      grid[x][y][z] = Dot.new(x, y, z, self)
    end
  end

  def at(x, y, z)
    return unless within?(x, y, z)

    grid[x] ||= {}
    grid[x][y] ||= {}
    grid[x][y][z] ||= Space.new(x, y, z, false, self)
  end

  def root = at(0, 0, 0)
  def dots = values.select { _1.is_a?(Dot) }
  def values = grid.values.flat_map(&:values).flat_map(&:values)
  def min_x = 0
  def min_y = 0
  def min_z = 0
  def max_x = 20#@max_x ||= all_x.max + 1
  def max_y = 20#@max_y ||= all_y.max + 1
  def max_z = 20#@max_z ||= all_z.max + 1
  def all_x = grid.keys
  def all_y = grid.values.flat_map(&:keys).uniq
  def all_z = grid.values.flat_map(&:values).flat_map(&:keys).uniq

  def within?(x, y, z)
    min_x <= x &&
      min_y <= y &&
      min_z <= z &&
      x <= max_x &&
      y <= max_y &&
      z <= max_z
  end

  def exposed_sides = dots.sum(&:exposed_sides)
  def touched_sides = dots.select(&:touched?).sum(&:exposed_sides)
  def exterior_surface = dots.select(&:touched?).sum(&:steamed_sides)

  def fill
    node = root
    visited = Set.new
    to_visit = node.adjacents.dup

    while node = to_visit.pop
      next if visited.include?(node)
      visited << node

      if node.is_a?(Dot)
        node.touch
      else
        to_visit += node.adjacents
        node.steam = true if !node.steam?
      end
    end

    nil
  end

  def adjacents(x, y, z)
    [
      at(x-1, y, z),
      at(x+1, y, z),
      at(x, y-1, z),
      at(x, y+1, z),
      at(x, y, z-1),
      at(x, y, z+1),
    ].compact
  end

  def inspect = "<Scan #{min_x},#{min_y},#{min_z} - #{max_x},#{max_y},#{max_z}>"
  def to_s
    (min_z..max_z).map do |z|
      (min_y..max_y).map do |y|
        (min_x..max_x).map do |x|
          at(x, y, z)&.to_s || " "
        end.join
      end.join("\n")
    end.join("\n\n")
  end

  def show
    (min_z..max_z).each do |z|
      system "clear"
      puts((min_y..max_y).map do |y|
        (min_x..max_x).map do |x|
          at(x, y, z)&.to_s || " "
        end.join
      end.join("\n"))
      sleep 0.1
    end
  end
end

class Dot
  attr_accessor :x, :y, :z, :scan, :touched

  def initialize(x, y, z, scan)
    @x = x
    @y = y
    @z = z
    @scan = scan
  end

  def to_s = touched? ? steamed_sides : "#"
  def inspect = "<Dot #{x},#{y},#{z}>"
  def adjacents = scan.adjacents(x, y, z)
  def exposed_sides = 6 - adjacents.grep(Dot).count
  def steamed_sides = adjacents.grep(Space).count(&:steam?)
  def touched? = !!touched
  def touch = @touched = true
end

class Space
  attr_accessor :x, :y, :z, :steam, :scan

  def initialize(x, y, z, steam, scan)
    @x = x
    @y = y
    @z = z
    @steam = steam
    @scan = scan
  end

  def to_s = steam? ? "~" : "."
  def steam? = !!steam
  def inspect = "<Space #{x},#{y},#{z}>"
  def adjacents = scan.adjacents(x, y, z)
end
