input = "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000"

# input = File.read("01.txt")

p input.split("\n\n").map { _1.lines.sum(&:to_i) }.max(3).sum
