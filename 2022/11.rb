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

class Item
  attr_reader :start
  attr_reader :values

  def initialize(value, divisibles = [])
    @start = start
    @values = {}
    divisibles.each { |d| @values[d] = value }
  end

  def +(other) = values.each { |d, _| values[d] += other.to_i }
  def *(other) = values.each { |d, v| values[d] *= other == "old" ? v : other.to_i }
  def %(other) = (values[other] %= other)
end

class Monkey
  attr_accessor :inspections,
                :items,
                :operation,
                :value,
                :divider,
                :if_true_monkey,
                :if_false_monkey

  def initialize
    @inspections = 0
  end

  def inspection
    while (item = items.shift)
      self.inspections += 1
      item.send(operation, value)
      monkey = item % divider == 0 ? if_true_monkey : if_false_monkey
      monkey.items.push item
    end
  end
end

monkey_inputs = input.split("\n\n")

divisibles = input.scan(/divisible by (\d+)/).map(&:first).map(&:to_i)
monkeys = monkey_inputs.map { Monkey.new }

monkey_inputs.each_with_index do |monkey_lines, index|
  m = monkeys[index]

  monkey_lines.each_line do |line|
    case line.strip.split(" ")
    in ["Monkey", *] then nil
    in ["Starting", "items:", *items]
      m.items = items.map { Item.new(_1.to_i, divisibles) }
    in ["Operation:", "new", "=", "old", operation, value]
      m.operation = operation
      m.value = value
    in ["Test:", "divisible", "by", divider]
      m.divider = divider.to_i
    in ["If", "true:", "throw", "to", "monkey", if_true_monkey]
      m.if_true_monkey = monkeys[if_true_monkey.to_i]
    in ["If", "false:", "throw", "to", "monkey", if_false_monkey]
      m.if_false_monkey = monkeys[if_false_monkey.to_i]
    end
  end
end

10_000.times { monkeys.each(&:inspection) }

p monkeys.map(&:inspections).max(2).reduce(:*)
