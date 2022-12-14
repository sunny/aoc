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

Squad = Struct.new(:lines) do
  def grid
    @grid ||= lines.each_with_index.with_object({}) do |(line, y), grid|
      line.chars.map(&:to_i).each_with_index.map do |value, x|
        grid[[x, y]] = Octopus.new(x, y, value, self)
      end
    end
  end

  def around(x, y)
    [0, 1, -1]
      .product([0, 1, -1])
      .filter_map { |dx, dy| grid[[x + dx, y + dy]] }
  end

  def ticked_members
    grid.values.each(&:step).each(&:reset)
  end
end

Octopus = Struct.new(:x, :y, :value, :squad, :flashes) do
  def step
    self.value += 1

    return unless value == 10

    self.flashes = flashes.to_i + 1

    squad.around(x, y).each(&:step)
  end

  def reset
    self.value = 0 if value >= 10
  end
end

squad = Squad.new(input.split("\n"))

puts (1..).find { squad.ticked_members.map(&:value).uniq.size == 1 }
