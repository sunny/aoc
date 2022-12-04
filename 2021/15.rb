require "set"
require "pqueue"

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

# input = File.read("15.txt")

input = input.lines.map { |x| x.chomp.chars.map(&:to_i) }

def adjacent(input, x, y)
  out = [
    ([x, y - 1] if y > 0),
    ([x, y + 1] if y < input.length - 1),
    ([x - 1, y] if x > 0),
    ([x + 1, y] if x < input[0].length - 1),
  ].compact

  # since its from day 11
  out.map { |el| [el.last, el.first] }
end

def dijkstra(matrix)
  height = matrix.length
  width = matrix[0].length
  from = [0, 0]
  to = [height - 1, width - 1]
  checked = Set[]
  q = PQueue.new
  q.push([0, from])
  costs = {}
  until q.empty?
    # have a max heap
    qi = q.shift
    cost = qi.first
    node = qi.last
    return cost if node == to

    checked.add(node)
    row = node.first
    col = node.last
    adjs = adjacent(matrix, col, row)
    adjs.each do |a|
      adj_row = a.first
      adj_col = a.last
      acost = matrix[adj_row][adj_col]
      ccost = cost + acost
      min_for_a = costs.fetch(a, 9_999_999)
      if ccost < min_for_a
        costs[a] = ccost
        q.push([ccost, a])
      end
    end
  end
  9_999_999
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

# input = [[8]]
new_input = []

input.each do |row|
  new_input = row + new_input
  new_input[x][y] = 0
end
