input = "30373
25512
65332
33549
35390"

# input = File.read("08.txt")

class Tree < Struct.new(:height, :x, :y, :grid)
  def visible?
    directions.any? { |trees| trees.all? { _1.height < height } }
  end

  def score
    directions.map { direction_score(_1) }.reduce(:*)
  end

  private

  def directions = [left, right, top, bottom]
  def left = (x - 1).downto(0).map { grid[y][_1] }
  def right = (x + 1).upto(grid.size - 1).map { grid[y][_1] }
  def top = (y - 1).downto(0).map { grid[_1][x] }
  def bottom = (y + 1).upto(grid.size - 1).map { grid[_1][x] }

  def direction_score(trees)
    score = 0
    trees.each do
      score += 1
      break if _1.height >= height
    end
    score
  end
end

grid = []
input.lines.each_with_index do |line, y|
  grid[y] = line.strip.each_char.with_index.map do |char, x|
    Tree.new(char.to_i, x, y, grid)
  end
end

p grid.flatten.count(&:visible?) # => 21
p grid.flatten.map(&:score).max # => 8
