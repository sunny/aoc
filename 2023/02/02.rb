# input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

# Part 1

input = File.read("02.txt")

max = {"red" => 12, "green" => 13, "blue" => 14}

sum = input.lines.sum do |line|
  match = line.match(/(\d+): (.*)/)
  tally = match[2].split(";").flat_map { _1.split(",").map(&:split) }
  next 0 if tally.any? { |count, color| count.to_i > max[color] }

  match[1].to_i
end

p sum

# Part 2

input = File.read("02.txt")

total = input.lines.sum do |line|
  draws = line.split(":").last.split(";")
  tally = draws.flat_map { _1.split(",").map(&:split) }

  result = tally.each_with_object(Hash.new(0)) do |(count, color), hash|
    count = count.to_i
    hash[color] = count if count > hash[color]
  end

  result.values.inject(:*)
end

p total
