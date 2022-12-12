require "pry"
require "set"

input = "Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi"

# input = File.read("12.txt")

class Map
  attr_reader :grid

  def initialize(input)
    @grid = input.lines.each_with_index.map do |line, y|
      line.chomp.chars.each_with_index.map do |char, x|
        Tile.new(self, x, y, char)
      end
    end
  end

  def adjacent(x, y)
    [self[x + 1, y], self[x, y + 1], self[x - 1, y], self[x, y - 1]].compact
  end

  def [](x, y)
    return nil if y < 0 || y >= grid.size
    return nil if x < 0 || x >= grid[y].size

    grid[y][x]
  end

  def paths = starts.flat_map { paths_starting_from(_1) }
  def starts = grid.flatten.select(&:start?)

  # Dijkstra’s algorithm
  def paths_starting_from(start)
    visited = Set.new
    paths = []
    queue = [[start]]
    until queue.empty?
      path = queue.shift
      tile = path.last
      next if visited.include?(tile)

      visited.add(tile)
      next paths << path if tile.end?

      tile.neighbors.each { queue << [*path, _1] }
    end
    paths
  end
end

class Tile < Struct.new(:map, :x, :y, :value)
  def start? = value == "S" || value == "a"
  def end? = value == "E"
  def neighbors = map.adjacent(x, y).select { _1.elevation <= elevation + 1 }
  def elevation = { "S" => "a", "E" => "z" }.fetch(value, value).ord
  def inspect = "<#{x}*#{y} #{value} #{elevation}>"
end

p Map.new(input).paths.map(&:size).min - 1
