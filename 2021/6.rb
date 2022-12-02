input = "3,4,3,1,2"

# input = File.read("6.txt")

fish = input.split(",").map(&:to_i)

1.upto(256) do |i|
  fish.map! { _1 - 1 }
  resets = fish.select { _1 < 0 }
  fish += [8] * resets.count
  fish.map! { _1 == -1 ? 6 : _1 }
end

p fish.count
