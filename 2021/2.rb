input = "forward 5
down 5
forward 8
up 3
down 8
forward 2"

# input = File.read("2.txt")

commands = input.lines.map { _1.split }

aim = 0
x = 0
y = 0

commands.each do |command, value|
  value = value.to_i
  case command
  when "forward"
    y += value
    x += aim * value
  when "up"
    aim -= value
  when "down"
    aim += value
  end
end

p x * y
