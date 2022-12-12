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

  def trails = starts.flat_map { Trail.starting_from(_1) }
  def starts = grid.flatten.select(&:start?)

  def edges(x, y)
    [[x + 1, y], [x, y + 1], [x - 1, y], [x, y - 1]].map do |x, y|
      grid[y][x] if y >= 0 && x >= 0 && y < grid.size && x < grid[0].size
    end
  end
end

class Tile < Struct.new(:map, :x, :y, :value)
  def start? = value == "S" || value == "a"
  def end? = value == "E"
  def edges = map.edges(x, y).compact.select { _1.elevation <= elevation + 1 }
  def elevation = { "S" => "a", "E" => "z" }.fetch(value, value).ord
end

class Trail < Struct.new(:tiles)
  def length = tiles.size - 1
  def tile = tiles.last
  def +(tile) = Trail.new([*tiles, tile])

  def self.starting_from(start)
    visited = Set.new
    trails = []
    queue = [Trail.new([start])]
    until queue.empty?
      trail = queue.shift
      tile = trail.tile
      next if visited.include?(tile)

      visited << tile
      next trails << trail if tile.end?

      tile.edges.each { queue << trail + _1 }
    end
    trails
  end
end

p Map.new(input).trails.map(&:length).min
