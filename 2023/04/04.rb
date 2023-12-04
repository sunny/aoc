input = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"

# Part 1

input = File.read("04.txt")

total = input.lines.sum do |line|
  match = line.match(/:(.*)\|(.*)/)
  wins = (match[1].split & match[2].split).count
  wins > 0 ? 2.pow(wins - 1) : 0
end

p total

# Part 2

input = File.read("04.txt")

cards = input.lines.to_h do |line|
  match = line.match(/(\d+):(.*)\|(.*)/)
  wins = (match[2].split & match[3].split).count
  [match[1].to_i, [1, wins]]
end

cards.each do |card, (copies, wins)|
  (card + 1).upto(card + wins) do |next_card|
    cards[next_card][0] += copies
  end
end

p cards.values.sum(&:first)
