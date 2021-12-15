input = "1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581"

input = File.read("15.txt")

# class Map
#   attr_reader :grid

#   def initialize(input)
#     @grid = input.lines.each_with_index.map do |line, y|
#       line.chomp.chars.map(&:to_i).each_with_index.map do |n, x|
#         [[x, y], Node.new(n, [x, y], self)]
#       end
#     end.flatten(1).to_h
#   end

#   def start
#     grid[[0, 0]]
#   end

#   def goal
#     grid[grid.keys.max]
#   end

#   def find_path(from, to)
#     visited = [from]
#     current = from

#     while current != to
#       neighbors = current.forward_neighbors - visited
#       current = neighbors.min_by { |n| n.value }
#       p current
#       visited << current
#     end

#     Path.new(visited, self)
#   end
# end

# class Node
#   attr_reader :value, :pos, :map

#   def initialize(value, pos, map)
#     @value = value
#     @pos = pos
#     @map = map
#   end

#   def x
#     pos[0]
#   end

#   def y
#     pos[1]
#   end

#   def forward_neighbors
#     [
#       map.grid[[x, y + 1]],
#       map.grid[[x + 1, y]],
#     ].compact
#   end

#   def neighbors
#     [
#       map.grid[[x, y - 1]],
#       map.grid[[x, y + 1]],
#       map.grid[[x - 1, y]],
#       map.grid[[x + 1, y]]
#     ].compact
#   end

#   def inspect
#     "<Node #{pos.join(",")}: #{value}>"
#   end
# end

# class Path
#   attr_reader :nodes, :map

#   def initialize(nodes, map)
#     @nodes = nodes
#     @map = map
#   end

#   def risk
#     nodes.map(&:value).sum - map.start.value
#   end

#   def alternate(without = [])
#     options = nodes.last.forward_neighbors - nodes - without
#     puts "alt #{nodes.last.inspect}"
#     return Path.new(nodes[0...-1], map).alternate(without) if options.empty?
#     options
#   end
# end

# map = Map.new(input)
# # pp map.start.neighbors
# first_path = map.find_path(map.start, map.goal)

# lowest_path = first_path
# lowest_risk = first_path.risk
# puts "=> #{lowest_risk}"
# pp first_path.alternate

values = input.lines.each_with_index.each_with_object({}) do |(line, y), val|
  line.chomp.chars.each_with_index do |n, x|
    val[[x, y]] = n.to_i
  end
end

graph = values.each_with_object({}) do |((x, y), value), graph|
  coords = [[x, y - 1], [x, y + 1], [x - 1, y], [x + 1, y]]
  graph[[x, y]] = coords.to_h { [_1, values[_1]] }.compact
end

class Graph
	def initialize
		@g = {}	 # the graph // {node => { edge1 => weight, edge2 => weight}, node2 => ...
		@nodes = Array.new
		@INFINITY = 1 << 64
	end

	def add_edge(s,t,w) 		# s= source, t= target, w= weight
		if (not @g.has_key?(s))
			@g[s] = {t=>w}
		else
			@g[s][t] = w
		end

		# Begin code for non directed graph (inserts the other edge too)

		if (not @g.has_key?(t))
			@g[t] = {s=>w}
		else
			@g[t][s] = w
		end

		# End code for non directed graph (ie. deleteme if you want it directed)

		if (not @nodes.include?(s))
			@nodes << s
		end
		if (not @nodes.include?(t))
			@nodes << t
		end
	end

	# based of wikipedia's pseudocode: http://en.wikipedia.org/wiki/Dijkstra's_algorithm

	def dijkstra(s)
		@d = {}
		@prev = {}

		@nodes.each do |i|
			@d[i] = @INFINITY
			@prev[i] = -1
		end

		@d[s] = 0
		q = @nodes.compact
		while (q.size > 0)
			u = nil;
			q.each do |min|
				if (not u) or (@d[min] and @d[min] < @d[u])
					u = min
				end
			end
			if (@d[u] == @INFINITY)
				break
			end
			q = q - [u]
			@g[u].keys.each do |v|
				alt = @d[u] + @g[u][v]
				if (alt < @d[v])
					@d[v] = alt
					@prev[v]  = u
				end
			end
		end
	end

	# To print the full shortest route to a node

	def print_path(dest)
		if @prev[dest] != -1
			print_path @prev[dest]
		end
		print "> #{dest}"
	end

	# Gets all shortests paths using dijkstra

	def shortest_paths(s, dest)
		@source = s
		dijkstra s
    print_path dest
    if @d[dest] != @INFINITY
      puts "\nDistance: #{@d[dest]}"
    else
      puts "\nNO PATH"
		end
	end

  def lowest_risk(from, to)
    @source = from
    dijkstra(from)
    @d[to]
  end
end

# gr = Graph.new
# gr.add_edge([0, 1], [0, 2], 5)
# gr.add_edge([0, 2], [0, 3], 3)
# gr.add_edge([0, 3], [0, 4], 1)
# gr.add_edge([0, 1], [0, 4], 10)
# gr.add_edge([0, 2], [0, 4], 2)
# gr.add_edge([0, 5], [0, 6], 1)
# gr.shortest_paths([0, 1], [0, 3])



gr = Graph.new
graph.each do |from, edges|
  edges.each do |to, weight|
    gr.add_edge(from, to, weight)
  end
end

#   gr.add_edge([0, 1], [0, 2], 5)
# gr.add_edge([0, 2], [0, 3], 3)
# gr.add_edge([0, 3], [0, 4], 1)
# gr.add_edge([0, 1], [0, 4], 10)
# gr.add_edge([0, 2], [0, 4], 2)
# gr.add_edge([0, 5], [0, 6], 1)
last = values.keys.max
p gr.lowest_risk([0, 0], last)
p values[last]
p gr.print_path(last)
