require "pastel"

input = "        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5"


class Cell
  attr_accessor :x, :y, :value, :map

  def initialize(x, y, value, map)
    @x = x
    @y = y
    @value = value
    @map = map
  end

  def blocked? = value == "#"
  def coords = [x, y]

  def face
    map.face_ranges.find do |_, (x_range, y_range)|
      x_range.include?(x) && y_range.include?(y)
    end.first
  end
end

class Map
  SIZES_BY_PATTERN = [4, 50]

  FACES = [
    {
      1 => [2, 0],
      2 => [0, 1],
      3 => [1, 1],
      4 => [2, 1],
      5 => [2, 2],
      6 => [3, 2],
    },
    {
      1 => [1, 0],
      2 => [2, 0],
      3 => [1, 1],
      4 => [1, 2],
      5 => [0, 2],
      6 => [0, 3],
    },
  ]

  FOLDS_BY_PATTERN = [
    {
      1 => { r: [6, :right] },
      2 => { d: [5, :bottom] },
      3 => { u: [1, :left] },
      4 => { r: [6, :top] },
      5 => { d: [2, :bottom], l: [3, :bottom] },
      6 => { d: [2, :left] },
    },
    {
      1 => { u: [6, :left, :r], l: [5, :left] },
      2 => { u: [6, :bottom], r: [4, :right], d: [3, :right] },
      3 => { r: [2, :bottom], l: [5, :top] },
      4 => { r: [2, :right],  d: [6, :right] },
      5 => { u: [3, :left], l: [1, :left] },
      6 => { r: [4, :bottom], d: [2, :top], l: [1, :top] },
    }
  ]

  FOLD_DIRECTIONS = { top: :d, right: :l, bottom: :u, left: :r }
  DRAWN_DIRECTIONS = { r: ">", l: "<", u: "^", d: "v" }
  NEW_DIRECTION_TURNING_LEFT = { r: :u, l: :d, u: :l, d: :r }
  NEW_DIRECTION_TURNING_RIGHT = { r: :d, l: :u, u: :r, d: :l }

  DIRECTION_CODE = { r: 0, d: 1, l: 2, u: 3, }

  attr_reader :pattern, :cells, :instructions, :x, :y, :dir, :max_x, :max_y

  def initialize(input, pattern:)
    @pattern = pattern
    @cells = Hash.new { |h, k| h[k] = {} }
    @max_x = 0
    @max_y = 0

    map, path = input.split("\n\n")
    map.lines.each_with_index do |line, new_y|
      line.chomp.chars.each_with_index do |char, new_x|
        @y = new_y if !@y && char == "."
        @x = new_x if !@x && char == "."
        @max_x = new_x if new_x > @max_x
        @max_y = new_y if new_y > @max_y
        cells[new_y][new_x] = Cell.new(new_x, new_y, char, self)
      end
    end

    @dir = :r
    @instructions = "_#{path}".scan(/([_LR])(\d+)/).map { [_1, _2.to_i] }
  end

  def password = 1_000 * (y + 1) + 4 * (x + 1) + DIRECTION_CODE.fetch(dir)
  def size = SIZES_BY_PATTERN[pattern]
  def folds = FOLDS_BY_PATTERN[pattern]
  def faces = FACES[pattern]
  def face = cell.face
  def cell = at(x, y)
  def at(x, y) = cells[y][x]
  def face_x = x - face_start(face).first
  def face_y = y - face_start(face).last
  def face_start(f) = [face_ranges[f].first.begin, face_ranges[f].last.begin]

  def face_ranges
    @face_ranges ||= faces.to_h do |face, (face_x, face_y)|
      [
        face,
        [
          (size * face_x)..(size * (face_x + 1) - 1),
          (size * face_y)..(size * (face_y + 1) - 1),
        ],
      ]
    end
  end

  def move
    draw_direction
    instructions.each do |rotation, moves|
      rotate(rotation)
      moves.times { move_forward }
    end
  end

  def rotate(rotation)
    case rotation
    when "L" then turn_left
    when "R" then turn_right
    end
  end

  def turn_left = @dir = NEW_DIRECTION_TURNING_LEFT.fetch(dir)
  def turn_right = @dir = NEW_DIRECTION_TURNING_RIGHT.fetch(dir)

  def move_forward = (@x, @y = next_available_cell.coords)

  def next_available_cell
    new_cell = next_cell

    if new_cell.nil? || new_cell.value == " "
      new_dir, new_cell = next_wrapped_cell
      @dir = new_dir unless new_cell.blocked?
    end

    new_cell.blocked? ? cell : new_cell
  end

  def next_cell
    case dir
    when :r then cells[y][x + 1]
    when :l then cells[y][x - 1]
    when :u then cells[y - 1][x]
    when :d then cells[y + 1][x]
    end
  end

  def next_wrapped_cell
    to_face, fold_dir = folds.fetch(face).fetch(dir)
    x_diff, y_diff = diff_for_for_dir_and_fold(dir, fold_dir)
    start_x, start_y = face_start(to_face)
    new_cell = at(start_x + x_diff, start_y + y_diff)
    new_direction = FOLD_DIRECTIONS.fetch(fold_dir)
    [FOLD_DIRECTIONS.fetch(fold_dir), new_cell]
  end

  def diff_for_for_dir_and_fold(dir, fold)
    case [dir, fold]
    when [:r, :top]    then [face_end_y, 0]
    when [:r, :right]  then [face_count, face_end_y]
    when [:r, :bottom] then [face_y,     face_count]
    when [:r, :left]   then [face_count, face_y]
    when [:l, :top]    then [face_y,     0]
    when [:l, :left]   then [0,          face_end_y]
    when [:l, :bottom] then [face_end_y, face_count]
    when [:u, :left]   then [0,          face_x]
    when [:u, :bottom] then [face_x,     face_count]
    when [:d, :right]  then [face_count, face_x]
    when [:d, :top]    then [face_x,     0]
    when [:d, :bottom] then [face_end_x, face_count]
    when [:d, :left]   then [0,          face_end_x]
    end
  end

  def face_end_y = face_count - face_y
  def face_end_x = face_count - face_x
  def face_count = size - 1

  def draw
    cells.each_value do |row|
      row.each_value do |cell|
        print cell.value
      end
      puts
    end
    nil
  end

  def draw_direction = cell.value = DRAWN_DIRECTIONS.fetch(dir)
end

map = Map.new(input, pattern: 0)
map.move
p map.password
pattern = 0

# input = File.read("22.txt")
# pattern = 1
# map = Map.new(input, pattern: 1)
# map.move
# p map.password
