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

calories = []
elf_calories = []
input.each_line do |line|
  if line == "\n"
    # end of current elf's inventory, start a new list for the next elf
    calories.append(elf_calories)
    elf_calories = []
  else
    # add calorie count to current elf's list
    elf_calories.append(line.to_i)
  end
end

# find elf with the most calories
most_calories = 0
calories.each do |c|
  total = c.sum
  most_calories = total if total > most_calories
end

# output result
puts most_calories
