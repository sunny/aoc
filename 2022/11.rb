input = "Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1"

# input = File.read("11.txt")

class Monkey
  attr_accessor :items, :symbol, :value, :divider, :if_true, :if_false, :counter

  def initialize = @counter = 0

  def play_and_throw
    while (item = items.shift)
      self.counter += 1
      item = item.send(symbol, value == "old" ? item : value.to_i)
      to_monkey_index = item % divider == 0 ? if_true : if_false
      yield item, to_monkey_index
    end
  end
end

monkeys = input.split("\n\n").map do |lines|
  monkey = Monkey.new
  lines.each_line do |line|
    case line
    when /Starting items: (.*)/
      monkey.items = $1.split.map(&:to_i)
    when /Operation: new = old (.) (.+)/
      monkey.symbol = $1
      monkey.value = $2
    when /Test: divisible by (\d+)/
      monkey.divider = $1.to_i
    when /If true: throw to monkey (\d+)/
      monkey.if_true = $1.to_i
    when /If false: throw to monkey (\d+)/
      monkey.if_false = $1.to_i
    end
  end
  monkey
end

10_000.times do
  monkeys.each do |monkey|
    monkey.play_and_throw do |item, to_monkey_index|
      monkeys[to_monkey_index].items << item % monkeys.map(&:divider).reduce(:*)
    end
  end
end

p monkeys.map(&:counter).max(2).reduce(:*)
