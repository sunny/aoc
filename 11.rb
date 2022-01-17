input = "5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526"

# input = File.read("11.txt")

class Squad
  attr_reader :grid

  def initialize(lines)
    @grid ||= lines.each_with_index.each_with_object({}) do |(line, y), grid|
      line.chars.map(&:to_i).each_with_index.map do |value, x|
        grid[[x,y]] = Octopus.new(x, y, value, self)
      end
    end
  end

  def around(x, y)
    [0, 1, -1]
      .product([0, 1, -1])
      .filter_map { |dx, dy| grid[[x + dx, y + dy]] }
  end

  def ticked_octopuses
    grid.values.each(&:step).each(&:reset)
  end
end

class Octopus < Struct.new(:x, :y, :value, :squad, :flashes)
  def step
    self.value += 1

    if value == 10
      self.flashes = flashes.to_i + 1

      squad.around(x, y).each(&:step)
    end
  end

  def reset
    self.value = 0 if value >= 10
  end
end

squad = Squad.new(input.split("\n"))

puts (1..).find { squad.ticked_octopuses.map(&:value).uniq.size == 1 }
