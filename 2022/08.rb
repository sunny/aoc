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
    @height = height.to_i
    @x = x
    @y = y
    @grid = grid
  end

  def visible?
    sightlines.any? { |trees| trees.all? { _1.height < height } }
  end

  def scenic_score
    sightlines.map { seight_score(_1) }.reduce(:*)
  end

  private

  def sightlines
    [left, right, top, bottom]
  end

  def left = (0..x-1).to_a.reverse.map { grid[y][_1] }
  def right = (x+1..grid.size-1).map { grid[y][_1] }
  def top = (0..y-1).to_a.reverse.map { grid[_1][x] }
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
lines.each_with_index do |line, i|
  line.chars.each_with_index do |char, j|
    grid[i][j] = Tree.new(char, j, i, grid)
  end
end

p grid.flatten.count(&:visible?)
p grid.flatten.map { _1.scenic_score }.max
