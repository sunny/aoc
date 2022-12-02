input = "16,1,2,0,4,2,7,1,2,14"

# input = File.read("7.txt")

POSITIONS = input.split(",").map(&:to_i)

def n_sum(n)
  n * (n + 1) / 2
end

def cost(to)
  POSITIONS.sum { |pos| n_sum((pos - to).abs) }
end

p (POSITIONS.min..POSITIONS.max).map { cost(_1) }.min
