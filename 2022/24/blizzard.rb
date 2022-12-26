require "pastel"
require "memo_wise"

class Blizzard
  prepend MemoWise
  attr_reader :x, :y, :dir, :map

  MOVES = {
    "<" => [-1, 0],
    ">" => [1, 0],
    "^" => [0, -1],
    "v" => [0, 1],
  }

  def initialize(x, y, dir, map)
    @x = x
    @y = y
    @dir = dir
    @map = map
  end

  def to_s = dir
  def inpsect = "<Blizzard #{x},#{y} #{dir}>"
  def min_x = map.blizzard_min_x
  def size_x = map.blizzard_size_x
  def min_y = map.blizzard_min_y
  def size_y = map.blizzard_size_y
  def vertical? = dir == "^" || dir == "v"
  def horizontal? = dir == "<" || dir == ">"

  def pos(minute)
    dx, dy = MOVES.fetch(dir)
    new_x = (dx * minute + x - 1) % size_x + 1
    new_y = (dy * minute + y - 1) % size_y + 1

    if new_x > size_x || new_x < min_x || new_y > size_y || new_y < min_y
      raise "#{new_x},#{new_y} x pos at #{minute} min on #{dir} out of bounds"
    end

    [new_x, new_y]
  end
  memo_wise :pos
end

class Map
  prepend MemoWise

  attr_reader :grid
  attr_reader :blizzards

  def initialize(input)
    @grid = Hash.new { |h, k| h[k] = {} }
    @blizzards = []
    input.split("\n").each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        if char != "." && char != "#"
          blizzards << Blizzard.new(x, y, char, self)
          @grid[y][x] = "."
        else
          @grid[y][x] = char
        end
      end
    end
  end

  def inspect = "<Map #{blizzard_min_x},#{blizzard_size_x}/#{blizzard_min_y},#{blizzard_size_y}>"
  def start = [1, 0]
  def [](x, y) = grid[y][x]
  def blizzard_min_x = 1
  def blizzard_size_x = grid[0].size - 2
  def blizzard_min_y = 1
  def blizzard_size_y = grid.size - 2
  def max_turns = @max_turns ||= [blizzard_size_x, blizzard_size_y].max

  def possible_blizzards_on_pos(pos)
    x, y = pos
    blizzards.select do |b|
      (b.horizontal? && b.y == y) || (b.vertical? && b.x == x)
    end
  end
  memo_wise :possible_blizzards_on_pos

  def adjacent_pos(pos)
    x, y = pos
    [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].select do |x, y|
      x >= blizzard_min_x &&
        x <= blizzard_size_x &&
        y >= blizzard_min_y &&
        y <= blizzard_size_y &&
        self[x, y] != "#"
    end
  end
  memo_wise :adjacent_pos

  def adjacent_pos_with_cost(minute, pos)
    memo_adjacent_pos_with_diff(minute % pattern_size, pos)
      .map { |new_pos, cost| [new_pos, minute + cost] }
  end

  def memo_adjacent_pos_with_diff(minute, pos)
    adjacent_pos(pos).filter_map do |new_pos|
      cost = minutes_until_clear(minute, new_pos)
      [new_pos, cost + 1] if cost
    end
  end
  memo_wise :memo_adjacent_pos_with_diff

  def minutes_until_clear(minute, pos)
    pattern_size.times.find do |step|
      blizzards_by_pos(minute + step + 1)[pos].nil?
    end
  end
  memo_wise :minutes_until_clear

  def blizzards_by_pos(min) = memo_blizzards_by_pos(min % pattern_size)
  memo_wise def memo_blizzards_by_pos(min) = blizzards.group_by { _1.pos(min) }
  memo_wise def pattern_size = blizzard_size_x.lcm(blizzard_size_y)

  def draw(minute = 0, pos = nil)
    grid.map do |y, row|
      row.map do |x, char|
        on_pos = blizzards_by_pos(minute)[[x, y]]
        new_char =
          case on_pos&.size
          when nil then char
          when 1 then on_pos.first.to_s
          when ..9 then on_pos.size
          else "+"
          end
        pos == [x, y] ? Pastel.new.red(new_char) : new_char
      end.join
    end.join("\n")
  end
  memo_wise :draw
end

class Path
  prepend MemoWise

  attr_reader :map, :fastest_paths, :queue, :minute

  def initialize(map)
    @map = map
    @queue = [[enter_pos, 0, []]]
    @minute = 0
    @fastest_paths = {}
  end

  def enter_pos = [1, 0]
  def start_pos = [1, 1]
  memo_wise def end_pos = [map.blizzard_size_x, map.blizzard_size_y]
  memo_wise def exit_pos = [map.blizzard_size_x, map.blizzard_size_y + 1]

  def solve(debug: false)
    while queue.any?
      pos, minute, path = queue.pop
      if fastest_paths[pos].nil? || fastest_paths[pos] > minute
        fastest_paths[pos] = minute
        fastest_path = path if pos == end_pos
        puts "#{fastest_paths.size-1}/#{map.blizzard_size_x * map.blizzard_size_y} (q: #{queue.size})" if debug
      end
      map.adjacent_pos_with_cost(minute, pos).each do |new_pos, new_minute|
        next if fastest_paths[new_pos] && fastest_paths[new_pos] <= new_minute
        queue << [new_pos, new_minute, path + [new_minute, new_pos]]
      end
    end
    fastest_paths[end_pos] + 2
  end
end
