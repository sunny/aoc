require "./rock"

class Chamber
  attr_accessor :moves,
                :rock,
                :ticks,
                :rocks_count,
                :grid,
                :max_height,
                :max_placed_y,
                :height_changes

  def initialize(moves)
    @moves = moves
    @grid = {}
    @ticks = 0
    @rocks_count = 0
    @max_height = 0
    @max_placed_y = nil
    @height_changes = []
  end

  def run_until(max_rocks)
    return calculate_height(max_rocks) if pattern while tick(max_rocks)

    rock&.min_y
  end

  def tick(max_rocks)
    add_rock unless rock
    return if max_rocks <= rocks_count

    move
    fall
    @ticks += 1
  end

  def add_rock
    self.rock = Rock.new_for_round(rocks_count, placing_x, next_rock_y)
    @rocks_count += 1
    @max_height = [max_height, rock.max_y].max
  end

  def move
    x_diff = gas_direction == ">" ? 1 : -1
    return if rock.max_x == width - 1 && x_diff == 1
    return if rock.min_x == 0 && x_diff == -1
    return if rock_blocking_move?(x_diff, 0)

    rock.x += x_diff
  end

  def rock_blocking_move?(x_diff, y_diff)
    rock.coords.any? { |x, y| grid.dig(y + y_diff, x + x_diff) == 1 }
  end

  def fall
    if rock_blocking_move?(0, -1) || rock.y == 0
      turn_rock_still
    else
      rock.y -= 1
    end
  end

  def turn_rock_still
    rock.coords.each do |x, y|
      grid[y] ||= [0, 0, 0, 0, 0, 0, 0]
      grid[y][x] = 1
    end

    previous_max_placed_y = max_placed_y
    @max_placed_y = [max_placed_y, rock.max_y].compact.max
    height_changes << max_placed_y - previous_max_placed_y.to_i

    self.rock = nil
  end

  def width = 7
  def placing_x = 2
  def placing_y_distance = 3
  def height = [rock&.max_y, max_placed_y].compact.max
  def next_rock_y = (grid.empty? ? 0 : max_placed_y + 1) + placing_y_distance
  def gas_direction = moves[ticks % moves.size]

  def pattern = pattern_size && height_changes[-pattern_size..]

  def pattern_size
    @pattern_size ||= begin
      return if height_changes.size < 10

      chars = height_changes.join
      10.upto(chars.size / 2).find do |i|
        chars[-i..] == chars[-i * 2..-i - 1]
      end
    end
  end

  def calculate_height(max_rocks)
    return rock&.min_y&.to_i unless pattern

    before_size = height_changes.size - 2 * pattern_size
    middle_size = (max_rocks - before_size) / pattern_size
    after_size = (max_rocks - before_size) % pattern_size

    height_before = height_changes[...before_size].sum
    height_after = pattern[...after_size].sum
    height_middle = middle_size * pattern.sum

    height_before + height_middle + height_after + 1
  end

  # Draw the grid

  def draw(title = rocks_count)
    puts title.to_s.center(width + 2)
    draw_lines.each do |line|
      puts "|#{line}|"
    end
    puts "+#{'-' * width}+"
  end

  def draw_lines
    max_height.downto(0).map do |y|
      width.times.map do |x|
        draw_at(x, y)
      end.join
    end
  end

  def draw_at(x, y)
    return "#" if grid[y] && grid[y][x] == 1
    return "@" if rock&.at(x, y)

    "."
  end
end
