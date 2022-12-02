input = "A Y
B X
C Z"

input = File.read("02.txt")

outcome_score = {
  ["A", "X"] => 0 + 3, # lose rock/scissors
  ["A", "Y"] => 3 + 1, # draw rock/rock
  ["A", "Z"] => 6 + 2, # win rock/paper
  ["B", "X"] => 0 + 1, # lose paper/rock
  ["B", "Y"] => 3 + 2, # draw paper/paper
  ["B", "Z"] => 6 + 3, # win paper/scissors
  ["C", "X"] => 0 + 2, # lose scissors/paper
  ["C", "Y"] => 3 + 3, # draw scissors/scissors
  ["C", "Z"] => 6 + 1, # win scissors/rock
}

sum = input.lines.map { _1.split }.sum do |a, b|
  outcome_score[[a, b]]
end

p sum
