
# def parse(str, level = 0)
#   eval(str).flat_map do |x|
#     if x.is_a?(Array) && x.size == 2 && !x[0].is_a?(Array) && !x[1].is_a?(Array)
#       Dig.new(level + 1, x[0], x[1])
#     elsif x.is_a?(Array)
#       parse(x.inspect, level + 1)
#     else
#       Dig.new(level, x)
#     end
#   end
# end

# class Num
#   attr_reader :digits

#   def initialize(digits)
#     @digits = digits
#     flatten
#   end

#   def +(other)
#     sum = digits + other.digits
#     Num.new(sum.map(&:inc)).reduce
#   end

#   def reduce
#     while digit_to_explode || digit_to_split
#       puts "reducing #{self}"
#       if digit_to_explode
#         explode
#       else
#         split
#       end
#     end
#     self
#   end

#   def digit_to_explode
#     digits.each_with_index.find { |d, _| d.pair? && d.level == 4 }
#   end

#   def digit_to_split
#     digits.each_with_index.find { |d, _| !d.pair? && d.x >= 10 }
#   end

#   def explode
#     digit, index = digit_to_explode
#     puts "exploding #{digit}"
#     digits[index - 1].x += digit.x if index > 0 && !digits[index - 1].pair?
#     digits[index + 1].x += digit.y if index + 1 < digits.count && !digits[index + 1].pair?

#     digit.x = 0
#     digit.y = nil
#     digit.level -= 1
#     flatten
#     puts "exploded #{self}"
#   end

#   def split
#     digit, index = digit_to_split
#     puts "splitting #{digit} in #{self}"
#     half = digit.x / 2.0
#     digit.x = half.floor
#     digit.y = half.ceil
#   end

#   def flatten
#     @digits = digits.inject([]) do |list, d|
#       if list.last && !list.last.pair? && list.last.level == d.level && !d.pair?
#         list.last.y = d.x
#         list
#       else
#         list + [d]
#       end
#     end
#     # puts "flattened #{self}"
#   end

#   def inspect
#     "Num#{digits.inspect}"
#   end

#   def to_s
#     inspect
#   end
# end

# class Dig
#   attr_accessor :level, :x, :y
#   def initialize(level, x, y = nil)
#     @level = level
#     @x = x
#     @y = y
#   end

#   def inc
#     Dig.new(level + 1, x, y)
#   end

#   def pair?
#     !y.nil?
#   end

#   def inspect
#     "#{[x, y].compact.join(",")}@#{level}"
#   end

#   def to_s
#     inspect
#   end
# end


# p Num.new(parse("[[[[[9,8],1],2],3],4]"))
# p Num.new(parse("[1,2]")) + Num.new(parse("[[3,4],5]"))

# p explode(parse("[[[[[9,8],1],2],3],4]")) == parse("[[[[0,9],2],3],4]")

# [[9,4], [8, 4], [1, 3], [2, 2], [3, 1], [4, 0]]
# # first 4 : 9+=0
# # second 4 : 8+=9
# [[9,4], [8, 4], [1, 3], [2, 2], [3, 1], [4, 0]]

# p Num.new(parse("[[[[[9,8],1],2],3],4]")).reduce
# p Num.new(parse("[7,[6,[5,[4,[3,2]]]]]")).reduce
# p Num.new(parse("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")).reduce
# p Num.new(parse("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")).reduce

# p Num.new(parse("[[[[4,3],4],4],[7,[[8,4],9]]]")) + Num.new(parse("[1,1]"))
