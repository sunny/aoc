input = "root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32"

# input = File.read("21.txt")

class Monkey
  attr_reader :name, :value, :left, :operator, :right, :troop

  def initialize(line, troop)
    @name, job = line.split(": ")
    if job =~ /^(\d+)$/
      @value = $1.to_i
    else
      @left, @operator, @right = job.split
    end
    @troop = troop
  end

  def result
    return :x if name == "humn"
    return [left_monkey.result, :"=", right_monkey.result] if name == "root"
    return value if value

    sides = [left_monkey.result, operator.to_sym, right_monkey.result]
    case sides
    in [Integer => left_number, _, Integer => right_number]
      left_number.public_send(operator, right_number)
    else
      sides
    end
  end

  def left_monkey = @left_monkey ||= troop.find(left)
  def right_monkey = @right_monkey ||= troop.find(right)
end

class Troop
  attr_reader :monkeys

  def initialize(input)
    @monkeys = []
    input.lines.each do |line|
      monkeys.push Monkey.new(line, self)
    end
  end

  def root = find("root")
  def find(name) = monkeys.find { _1.name == name }

  def my_result
    left, _, right = root.result

    while left != :x
      left, right = solve(left, right)
    end

    right
  end

  def solve(left, right)
    case left
    in [x, :+, Integer => n] then [x, right - n]
    in [x, :-, Integer => n] then [x, right + n]
    in [x, :*, Integer => n] then [x, right / n]
    in [x, :/, Integer => n] then [x, right * n]
    in [Integer => n, :+, x] then [x, right - n]
    in [Integer => n, :-, x] then [x, n - right]
    in [Integer => n, :*, x] then [x, right / n]
    in [Integer => n, :/, x] then [x, n / right]
    else
    end
  end
end

troop = Troop.new(input)
p troop.my_result
