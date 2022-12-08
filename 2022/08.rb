input = "30373
25512
65332
33549
35390"

# 374400
# input = File.read("08.txt")

class Tree
  attr_reader :x, :y, :height, :grid

  def initialize(height, x, y, grid)
    @height = height
    @x = x
    @y = y
    @grid = grid
  end

  def visible?
    directions.any? { |trees| trees.all? { _1.height < height } }
  end

  def scenic_score
    directions.map { seight_score(_1) }.reduce(:*)
  end

  private

  def directions = [left, right, top, bottom]
  def left = (0..x-1).map { grid[y][_1] }.reverse
  def right = (x+1..grid.size-1).map { grid[y][_1] }
  def top = (0..y-1).map { grid[_1][x] }.reverse
  def bottom = (y+1..grid.size-1).map { grid[_1][x] }

  def seight_score(trees)
    score = 0
    trees.each do |tree|
      score += 1
      break if tree.height >= height
    end
    score
  end
end

lines = input.split("\n")
grid = Array.new(lines.size) { Array.new(lines.size) }
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    grid[y][x] = Tree.new(char.to_i, y, x, grid)
  end
end

p grid.flatten.count(&:visible?)
p grid.flatten.map(&:scenic_score).max
