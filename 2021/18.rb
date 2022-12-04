# rubocop:disable Metrics/ClassLength
class Num
  def self.sum(input)
    input.split("\n").inject(nil) do |sum, line|
      num = parse(eval(line))
      sum ? sum + num : num
    end
  end
  # rubocop:enable Security/Eval

  def self.parse(n, index = 0, level = 0)
    if n.is_a?(Array)
      x = parse(n[0], index, level + 1)
      y = parse(n[1], index + x.count, level + 1)
      Num.new(index, level, x, y)
    else
      Num.new(index, level, n)
    end
  end

  attr_accessor :index, :level, :x, :y

  def initialize(index, level, x, y = nil)
    @index = index
    @level = level
    @x = x
    @y = y
  end

  def reduce
    # puts "------------------------------------"
    # puts "reducing #{to_a}"
    # puts "reducing #{self}"
    # puts "------------------------------------"
    puts to_a.inspect
    explode if pair_to_explode
    split if number_to_split

    p self
    self
  end

  def count
    if pair?
      x.count + y.count
    else
      1
    end
  end

  def pair?
    !!y
  end

  def pair_to_explode
    flatten.find { _1.pair? && _1.level > 3 }
  end

  def flatten
    return self unless y
    return self if !x.pair? && !y.pair?

    [x.flatten, y.flatten].flatten
  end

  def numbers
    flatten.flat_map do |n|
      n.pair? ? [n.x, n.y] : n
    end
  end

  def number_to_split
    numbers.find { |n| n.x >= 10 }
  end

  def split
    num = number_to_split
    half = num.x / 2.0
    num.x = Num.new(0, 0, half.floor)
    num.y = Num.new(0, 0, half.ceil)
    reset_index
    reduce
  end

  def explode
    explode_once
    reduce
  end

  def explode_once
    pair = pair_to_explode
    prev_n = numbers.reverse.find { _1.index < pair.x.index }
    next_n = numbers.find { _1.index > pair.y.index }
    puts "__ exploding #{pair.to_a} to #{prev_n&.to_a} and #{next_n&.to_a}"
    prev_n.x += pair.x.x if prev_n
    next_n.x += pair.y.x if next_n
    pair.x = 0
    pair.y = nil
    reset_index
    self
  end
  # rubocop:enable Metrics/AbcSize

  def reset_index(index = 0)
    if pair?
      self.index = nil
      index = x.reset_index(index)
      y.reset_index(index)
    else
      index += 1
      self.index = index
      index
    end
  end

  def inspect
    if pair?
      "@#{level}:[#{x.inspect}, #{y.inspect}]"
    else
      "##{index}:#{x}"
    end
  end

  def to_s
    inspect
  end

  def +(other)
    puts "----> adding #{self}"
    puts "         and #{other}"
    increment_level
    other.increment_level
    result = Num.new(0, 0, self, other)
    result.reset_index
    result.reduce
  end

  def increment_level
    self.level += 1
    x.increment_level if x.is_a?(Num)
    y.increment_level if y.is_a?(Num)
  end

  def to_a
    if pair?
      [x.to_a, y.to_a]
    else
      x
    end
  end

  def ==(other)
    other.is_a?(Num) && to_a == other.to_a
  end
end
# rubocop:enable Metrics/ClassLength

# rubocop:disable Layout/LineLength
# a = Num.parse([[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]])
# p a.reduce
# # b = Num.parse([1,1])

# # result = a + b

# # p result.to_a

# Num.parse([[[[5, 11], [0, [13, 0]]], [[8, [7, 7]], [[7, 9], [5, 0]]]], [[2, [[0, 8], [3, 4]]], [[[6, 7], 1], [7, [1, 6]]]]]).reduce

# raise unless Num.parse([[[[[4,3],4],4],[7,[[8,4],9]]], [1,1]]).reduce.to_a == [[[[0,7],4],[[7,8],[6,0]]],[8,1]]
# exit
# input = "[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
# [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
# [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]"
# [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
# [7,[5,[[3,8],[1,4]]]]
# [[2,[2,2]],[8,[8,1]]]
# [2,9]
# [1,[[[9,3],9],[[9,0],[0,7]]]]
# [[[5,[7,4]],7],1]
# [[[[4,2],2],6],[8,7]]

# input = "[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
# [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]"

# p Num.parse([[[[[9,8],1],2],3],4]).reduce == Num.parse([[[[0,9],2],3],4])
# p Num.parse([7,[6,[5,[4,[3,2]]]]]).reduce == Num.parse([7,[6,[5,[7,0]]]])
# p Num.parse([[6,[5,[4,[3,2]]]],1]).reduce == Num.parse([[6,[5,[7,0]]],3])
# p Num.parse([[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]).explode_once == Num.parse([[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]])
# p Num.parse([[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]).reduce == Num.parse([[3,[2,[8,0]]],[9,[5,[7,0]]]])
# p Num.parse([[[[[4,3],4],4],[7,[[8,4],9]]], [1,1]]).reduce == Num.parse([[[[0,7],4],[[7,8],[6,0]]],[8,1]])
# p Num.sum("[1,1]\n[2,2]\n[3,3]\n[4,4]").reduce == Num.parse([[[[1,1],[2,2]],[3,3]],[4,4]])
# p Num.sum("[1,1]\n[2,2]\n[3,3]\n[4,4]\n[5,5]").reduce == Num.parse([[[[3,0],[5,3]],[4,4]],[5,5]])
# p Num.sum("[1,1]\n[2,2]\n[3,3]\n[4,4]\n[5,5]\n[6,6]").reduce == Num.parse([[[[5,0],[7,4]],[5,5]],[6,6]])
# p Num.sum("[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]\n[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]").reduce == Num.parse([[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]])

# p Num.sum("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]\n[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]").reduce == Num.parse([[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]])
# input = "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]
# [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]"

# result = input.split("\n").inject(nil) do |sum, line|
#   num = Num.parse(eval(line))
#   sum ? sum + num : num
# end

# p result.to_a

r = Num.sum("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]\n[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]").reduce
p r.reset_index
p r.to_a
p r
# rubocop:enable Layout/LineLength
