input = "NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
"

# input = File.read("14.txt")

template, rules = input.split("\n\n")
template = template.chars
rules = rules.split("\n").map { |r| r.split(" -> ") }.to_h

# (1..40).each do |i|
(1..2).each do |i|
  new_template = template.each_cons(2).flat_map do |pair|
    [pair.first, rules[pair.join]]
  end + [template.last]
  rules[template.join] = new_template.join

  template = new_template
  p [i, template.size, rules.size]

  pp rules
end
min, max = template.tally.to_a.map(&:last).sort.minmax
p max - min
