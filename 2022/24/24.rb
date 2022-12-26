require "./blizzard"

# input = "#.#####
# #.....#
# #>....#
# #.....#
# #...v.#
# #.....#
# #####.#"

input = "#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#"

input = File.read("24.txt")

map = Map.new(input)
# puts map.draw

path = Path.new(map)
pp path.solve(debug: true) # 184 < ?
