# 1651
# ["AA", "DD", "BB", "JJ", "HH", "EE", "CC"]
# input = File.read("example.txt")

# 2265
input = File.read("16.txt")

tunnels_by_name = {}
flow_rate_by_name = {}
valve_names = []
valve_names_to_open = []

input.lines.each do |line|
  match = /Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/
  name, flow_rate, tunnels = line.scan(match).first
  valve_names << name
  tunnels_by_name[name] = tunnels.split(', ')
  flow_rate_by_name[name] = flow_rate.to_i
  valve_names_to_open << name if flow_rate.to_i > 0
end

def shortest_paths(graph, start_name)
  queue = []
  shortest_paths = {}

  # Enqueue the start name node and set the distance to 0
  queue << [start_name, 0]
  shortest_paths[start_name] = 0

  # puts "shortest paths from #{start_name}?"

  # While the queue is not empty
  while !queue.empty?
    # Dequeue a node from the queue
    current_node, distance = queue.pop

    # puts "#{" " * queue.size} considering #{current_node} at #{distance}"

    # Enqueue all the neighbors of the current node and update their distances
    raise "Not connected to #{current_node}" if !graph.key?(current_node)

    graph[current_node].each do |neighbor|
      if !shortest_paths.key?(neighbor) || shortest_paths[neighbor] > distance + 1
        queue << [neighbor, distance + 1]
        shortest_paths[neighbor] = distance + 1
      end
    end
  end

  # puts "shortest paths from #{start_name}: #{shortest_paths.except(start_name).inspect}}"
  shortest_paths
end

def all_shortest_paths_by_name(tunnels_by_name)
  shortest_paths_by_name = {}
  tunnels_by_name.keys.each do |name|
    shortest_paths_by_name[name] = shortest_paths(tunnels_by_name, name).except(name)
  end
  tunnels_by_name
  shortest_paths_by_name
end

def closed_paths_shorted_paths_by_name(shortest_paths_by_name, valve_names_to_open)
  paths = {}
  shortest_paths_by_name.each do |name, shortest_paths|
    next unless name == "AA" || valve_names_to_open.include?(name)
    paths[name] = {}
    shortest_paths.each do |neighbor, distance|
      paths[name][neighbor] = distance if valve_names_to_open.include?(neighbor)
    end
  end
  paths
end

def pressure_paths(graph, start, flow_rate_by_name)
  # Initialize the queue and best paths
  queue = []
  # Best paths are a hash of name => { step => { pressure: …, path: … } }
  best_paths = Hash.new do |h, name|
    h[name] = Hash.new do |j, step|
      j[step] = { pressure: 0, path: [] }
    end
  end

  # Queue items contain : node, path, steps, pressure
  queue << [start, [start], 0, 0]
  interesting = false

  # Perform BFS to find the shortest paths
  while !queue.empty?
    # puts "Queue #{queue.inspect}" if interesting
    current_node, path, steps, pressure = queue.pop
    raise "Boiled" if steps > 30

    # interesting_path = ["AA", "MH", "QW", "ZU", "NT", "KF", "FF", "XY", "NQ"]
    interesting = false#path == interesting_path[0..path.size - 1]
    # print "."

    puts "#{path.join(",")}: steps: #{steps.inspect}, pressure: #{pressure.inspect}" if interesting
    graph[current_node].except(*path).sort_by(&:first).each do |neighbor, distance|
      next_path = path + [neighbor]
      next_steps = steps + distance + 1
      next if next_steps > 30
      if path.include?(neighbor)
        next_pressure = pressure
      else
        next_pressure = pressure + flow_rate_by_name[neighbor] * (30 - next_steps)
      end
      puts "  #{neighbor}'s next_pressure is #{next_pressure}" if interesting
      puts "    best path to #{neighbor} on step #{steps}: #{best_paths[neighbor][steps]}" if best_paths[neighbor][steps] && interesting
      if best_paths[neighbor][steps][:pressure] < next_pressure
        puts "    new best pressure path #{next_path} for pressure #{next_pressure} at step #{steps}" if interesting
        queue << [neighbor, next_path, next_steps, next_pressure]
        best_paths[neighbor][steps] = { pressure: next_pressure, path: next_path }
      end
    end
  end

  best_paths.values.flat_map(&:values).sort_by { |h| h[:pressure] }.last
end

shortest_paths_by_name = all_shortest_paths_by_name(tunnels_by_name)
closed_paths = closed_paths_shorted_paths_by_name(shortest_paths_by_name, valve_names_to_open)
# pp closed_paths;nil


pp pressure_paths(closed_paths, "AA", flow_rate_by_name)
