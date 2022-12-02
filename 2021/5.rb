input = "0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"

# input = File.read("5.txt")

def sequence(a, b)
  a > b ? (b..a).to_a.reverse : (a..b).to_a
end

def coordinates(x1, y1, x2, y2)
  x = sequence(x1, x2)
  y = sequence(y1, y2)
  x.fill(x1, x.size...y.size)
  y.fill(y1, y.size...x.size)
  x.zip(y)
end

dots = Hash.new { |h, k| h[k] = Hash.new(0) }
input.lines.each do
  coordinates(*_1.scan(/\d+/).map(&:to_i)).each do |x, y|
    dots[y][x] += 1
  end
end

puts dots.sum { |_, v| v.count { _2 > 1 } }
