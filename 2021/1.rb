input = "199
200
208
210
200
207
240
269
260
263"

# input = File.read("1.txt")

def count_more_increases(values)
  values = values.each_cons(3).map(&:sum)
  values.each_with_index.count do |input, index|
    index != 0 && input > values[index - 1]
  end
end

puts count_more_increases(input.split("\n").map(&:to_i))
