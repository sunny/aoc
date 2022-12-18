require "./chamber"

input = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

# input = File.read("17.txt")

c = Chamber.new(input.strip.chars)
p c.run_until(2022)
p c.run_until(1_000_000_000_000)
