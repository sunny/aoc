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
rules = rules.split("\n").to_h do |r|
  key, value = r.split(" -> ")
  [key, [key.chars.first, value, key.chars.last].join]
end

counters = Hash.new(0)
template.chars.each_cons(2) do |a, b|
  counters[a + b] += 1
end

40.times do
  counters = counters.each_with_object(Hash.new(0)) do |(k, v), hash|
    rules[k].chars.each_cons(2).to_a.each do |pair|
      hash[pair.join] += v
    end
  end
end

chars = counters.each_with_object(Hash.new(0)) do |(k, v), hash|
  hash[k.chars.first] += v
end
chars[template.chars.last] += 1

puts chars.values.max - chars.values.min
