require "./scan"

input = "2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5"

# input = File.read("18.txt")

scan = Scan.new(input)

# Part 1
p scan.exposed_sides

# Part 2
scan.fill
p scan.exterior_surface
