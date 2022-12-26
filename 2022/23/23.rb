input = "....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#.."

# input = ".....
# ..##.
# ..#..
# .....
# ..##.
# ....."

# input = File.read("23.txt")

class Elf
  attr_accessor :x, :y, :map, :proposition

  def initialize(x, y, map)
    @x = x
    @y = y
    @map = map
  end

  def check(step) = @proposition = preferred_direction(step)
  def adjacents = [n, ne, nw, s, se, sw, w, e].compact
  def move_target = (target if proposition && can_move?)
  def can_move? = other_elves.none? { _1.target == target }
  def other_elves = map.elves.reject { _1 == self }
  def n = map.at(x, y - 1)
  def ne = map.at(x + 1, y - 1)
  def nw = map.at(x - 1, y - 1)
  def s = map.at(x, y + 1)
  def se = map.at(x + 1, y + 1)
  def sw = map.at(x - 1, y + 1)
  def w = map.at(x - 1, y)
  def e = map.at(x + 1, y)
  def to_s = proposition ? (can_move? ? proposition.upcase : proposition) : "#"
  def inspect = "<Elf #{x},#{y} #{can_move? ? to_s.upcase : to_s}>"

  def preferred_direction(step)
    return if adjacents.none?

    checks.rotate(step).each do |direction, check|
      return direction if check.call
    end

    nil
  end

  def target
    case proposition
    when :n then [x, y - 1]
    when :s then [x, y + 1]
    when :w then [x - 1, y]
    when :e then [x + 1, y]
    end
  end

  def checks
    [
      [:n, -> { !n && !ne && !nw }],
      [:s, -> { !s && !se && !sw }],
      [:w, -> { !w && !nw && !sw }],
      [:e, -> { !e && !ne && !se }],
    ]
  end
end

class Map
  attr_reader :grid, :step

  def initialize(input)
    @step = 0
    @grid = Hash.new { |h, k| h[k] = {} }
    input.lines.each_with_index do |line, y|
      line.chomp.chars.each_with_index do |char, x|
        if char == "#"
          @grid[y][x] = Elf.new(x, y, self)
        end
      end
    end
  end

  def elves = grid.values.flat_map(&:values).compact
  def min_x = elves.map(&:x).min
  def max_x = elves.map(&:x).max
  def min_y = elves.map(&:y).min
  def max_y = elves.map(&:y).max
  def at(x, y) = grid[y][x]

  def draw
    puts "Round #{@step}:"
    (min_y - 1).upto(max_y + 1).each do |y|
      (min_x - 2).upto(max_x + 1).each do |x|
        print at(x, y)&.to_s || "."
      end
      puts
    end
  end

  def empty_tiles_count
    (min_y).upto(max_y).flat_map do |y|
      (min_x).upto(max_x).map do |x|
        [x, y] unless at(x, y)
      end
    end.compact.count
  end

  def organize
    loop do
      elves.each do |elf|
        elf.check(step)
      end
      draw
      break if elves.all? { _1.proposition.nil? }

      elves.each do |elf|
        if (target = elf.move_target)
          grid[elf.y][elf.x] = nil
          grid[target[1]][target[0]] = elf
          elf.x, elf.y = target
          elf.proposition = nil
        end
      end

      @step += 1
    end
  end
end

map = Map.new(input)
map.organize
p map.step + 1
