# 1651
# ["AA", "DD", "BB", "JJ", "HH", "EE", "CC"]
input = File.read("example.txt")

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
    shortest_paths_by_name[name] = shortest_paths(tunnels_by_name, name)#.except(name)
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
  bests = best_scored_paths_by_name(graph, start, flow_rate_by_name).first
  bests.sort_by { |h| h[:pressure] }.last
end

def best_scored_paths_by_name(graph, start, flow_rate_by_name, max_minutes = 30)
  queue = []
  # Best paths are a hash of name => { step => { pressure: …, path: … } }
  best_paths = Hash.new do |h, name|
    h[name] = Hash.new do |j, step|
      j[step] = { pressure: 0, path: [] }
    end
  end
  all_paths = []

  # Queue items contain : node, path, steps, pressure
  queue << [start, [start], 0, 0]
  interesting = false

  # Perform BFS to find the shortest paths
  while !queue.empty?
    # puts "Queue #{queue.inspect}" if interesting
    current_node, path, steps, pressure = queue.pop
    raise "Boiled" if steps > max_minutes

    # print "."

    # puts "#{path.join(",")}: steps: #{steps.inspect}, pressure: #{pressure.inspect}" if interesting
    graph[current_node].except(*path).sort_by(&:first).each do |neighbor, distance|
      next_path = path + [neighbor]
      next_steps = steps + distance + 1

      next if next_steps > max_minutes
      if path.include?(neighbor)
        next_pressure = pressure
      else
        next_pressure = pressure + flow_rate_by_name[neighbor] * (max_minutes - next_steps)
      end
      # puts "  #{neighbor}'s next_pressure is #{next_pressure}" if interesting
      # puts "    best path to #{neighbor} on step #{steps}: #{best_paths[neighbor][steps]}" if best_paths[neighbor][steps] && interesting

      if best_paths[neighbor][steps][:pressure] <= next_pressure
        # puts "    new best pressure path #{next_path} for pressure #{next_pressure} at step #{steps}" if interesting
        queue << [neighbor, next_path, next_steps, next_pressure]
        best_paths[neighbor][steps] = { pressure: next_pressure, path: next_path }
      end
      all_paths << { pressure: next_pressure, path: next_path }
    end
  end

  [best_paths.values.flat_map(&:values), all_paths]
end

def double_pressure_paths(graph, start_pair, flow_rate_by_name, max_minutes)
  queue = []

  # Best paths are a hash of [name, name] => { step => { pressure: …, path: … } }
  best_paths = Hash.new do |h, names|
    h[names] = Hash.new do |j, step|
      j[step] = { pressure: 0, path: [] }
    end
  end

  # Queue items contain : pair of names, path, steps, pressure
  queue << [start_pair, [start_pair], 0, 0]
  interesting = false

  # Perform BFS to find the shortest paths
  while !queue.empty?
    # puts "Queue #{queue.inspect}" if interesting
    current_node, path, steps, pressure = queue.pop
    raise "Boiled" if steps > max_minutes

    # interesting_path = [["AA", "AA"], ["II", "DD"], ["JJ", "DD"], ["JJ", "EE"], ["II", "FF"], ["AA", "GG"], ["BB", "HH"], ["BB", "HH"], ["CC", "GG"], ["CC", "FF"], ["CC", "EE"]]
    # interesting = path == interesting_path[0..path.size - 1]
    puts best_paths.map { |_, v| max_steps, hash = v.to_a.sort.last; [" " * steps, max_steps, hash[:pressure], hash[:path].map { _1.join("") }.join(",")].join(" ") }
    top = best_paths.values.flat_map(&:values).sort_by { |h| h[:pressure] }.last
    p top if top

    raise "over the top for example" if top && top[:pressure] > 1707

    # puts interesting_path[0..path.size - 1].inspect
    raise "don't revisit AA" if path == [["AA", "AA"], ["AA", "CC"]]

    # puts "#{" "*steps}#{path.inspect}: steps: #{steps}, pressure: #{pressure}" if interesting
    if graph[current_node].nil?
      p graph
      p current_node
      raise "No graph for #{current_node}"
    end
    paths = find_possible_double_paths_for(current_node, graph, flow_rate_by_name, path)
    puts "paths for #{current_node}:"
    p paths

    puts "  #{" "*steps}paths:#{paths.inspect}" if interesting

    paths.sort_by(&:first).each do |neighbor, distance|
      step_diff, pressure_diff = pressure_and_steps_for_pair_path(path, neighbor, distance, flow_rate_by_name)
      next_steps = steps + step_diff
      next_pressure = pressure + pressure_diff
      next_path = path + [neighbor]
      next if next_steps > max_minutes

      # puts "  #{" "*steps}#{neighbor}'s next_pressure is #{next_pressure}" if interesting
      # puts "    best path to #{neighbor} on step #{steps}: #{best_paths[neighbor][steps]}" if best_paths[neighbor].key?(steps) && interesting
      if best_paths.empty? || best_paths[neighbor][steps][:pressure] <= next_pressure
        # puts "  #{" "*path.size}new best pressure path #{next_path} for pressure #{next_pressure} at step #{steps}" if interesting
        queue << [neighbor, next_path, next_steps, next_pressure]
        best_paths[neighbor][steps] = { pressure: next_pressure, path: next_path }
      end
    end
  end

  best_paths.values.flat_map(&:values).sort_by { |h| h[:pressure] }.last
end

# def paths_for_pair(shortest_paths_by_name, previous_paths, left, right)
#   paths = shortest_paths_by_name[left]
#   raise "Could not find #{left} in #{shortest_paths_by_name.inspect}" unless paths

#   paths.except(*previous_paths).sort_by(&:first)
# end

def find_possible_double_paths_for(current_node, shortest_paths_by_pair, flow_rate_by_name, path)
  shortest_paths_by_pair[current_node]
    .except(*path)
    .sort_by(&:first)
    .to_h
end

def double_tunnels(tunnels_by_name)
  products = tunnels_by_name.to_h do |name, tunnels|
    [name, tunnels.product(tunnels)]
  end
  pairs = tunnels_by_name.keys.to_a.product(tunnels_by_name.keys)
  pairs.sort_by(&:first).to_h do |pair|
    [
      pair,
      ([pair] + products[pair.first] + products[pair.last]).uniq.sort,
    ]
  end
end

def pressure_and_steps_for_pair_path(path, pair, distance, flow_rate_by_name)
  *visited, last_visit = path
  steps_left = (26 - path.size)

  followed_visits = path.transpose.map { _1.each_cons(2).to_a }.flatten(1).uniq

  pressure = 0
  pair.uniq.each do |name|
    distance += 1

    next if visited.empty?
    next if followed_visits.include?([name, name])
    rate = flow_rate_by_name[name]
    next if rate == 0
    next unless last_visit.include?(name)

    # puts "#{" " * path.size} opening #{name}"
    pressure += flow_rate_by_name[name] * steps_left
    distance += 1
  end

  # puts "  #{" "*pair.size}pair: #{pair.inspect}"
  # puts "  #{" "*pair.size}distance: #{distance.inspect}; pressure: #{pressure.inspect}"

  # print "found: "
  # puts "pair: #{pair.inspect}; visited: #{visited.inspect}; last_visit: #{last_visit.inspect}; pressure: #{pressure.inspect}; distance: #{distance.inspect}"

  [distance, pressure]
end

# z.zip(z).map { |a,b| pair, values = a.zip(b); [pair, values.first.combination(2).to_a] }

shortest_paths_by_name = all_shortest_paths_by_name(tunnels_by_name)

# Part 1
# closed_paths = closed_paths_shorted_paths_by_name(shortest_paths_by_name, valve_names_to_open)
# pp pressure_paths(shortest_paths_by_name, "AA", flow_rate_by_name)[:pressure]

reachable_paths = best_scored_paths_by_name(shortest_paths_by_name, "AA", flow_rate_by_name, 26).last
short_list_of_paths = reachable_paths.select do |h|
  (h[:path] & valve_names_to_open).size >= (valve_names_to_open.size / 2 - 1)
end.uniq#.sort_by { _1[:path] }#.select { _1[:path].size == (valve_names_to_open.size + 2) / 2 }
# pp short_list_of_paths

compare = valve_names_to_open.sort
p compare
r = short_list_of_paths.flat_map do |h|
  pressure = h[:pressure]
  path = h[:path] - ["AA"]
  short_list_of_paths.map do |other|
    other_path = other[:path] - ["AA"]
    other_pressure = other[:pressure]
    if (path & other_path).size == 0
      [pressure + other_pressure, path, other_path]
    end
  end.compact
end.sort.last
p r
