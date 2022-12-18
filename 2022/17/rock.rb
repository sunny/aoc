class Rock
  SHAPES = [
    [[1, 1, 1, 1]],
    [[0, 1, 0], [1, 1, 1], [0, 1, 0]],
    [[0, 0, 1], [0, 0, 1], [1, 1, 1]],
    [[1], [1], [1], [1]],
    [[1, 1], [1, 1]],
  ].freeze

  def self.new_for_round(turn, x = 0, y = 0)
    from_shape(SHAPES[turn % SHAPES.size], x, y)
  end

  def self.from_shape(shape, x = 0, y = 0)
    new(x, y, shape)
  end

  def initialize(x, y, shape)
    @x = x
    @y = y
    @shape = shape
  end

  attr_accessor :x, :y, :shape

  def width = shape.map(&:size).max
  def height = shape.size
  def max_x = x + width - 1
  def min_x = x
  def max_y = y + height - 1
  def min_y = y
  def at(test_x, test_y) = coords.include?([test_x, test_y])

  def coords
    shape.flat_map.with_index do |line, shape_y|
      line.select.map.with_index do |char, shape_x|
        [x + shape_x, max_y - shape_y] if char == 1
      end
    end.compact
  end
end
