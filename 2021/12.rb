input = "start-A
start-b
A-c
A-b
b-d
A-end
b-end"

# input = File.read("12.txt")

class Graph
  attr_accessor :edges

  def initialize(lines)
    @edges = Hash.new { |h, k| h[k] = [] }

    lines.each do |line|
      from, to = line.chomp.split("-")
      @edges[from] << to
      @edges[to] << from
    end
  end

  def root
    Node.new(self, "start")
  end
end

class Node
  attr_reader :graph, :name, :parent

  def initialize(graph, name, parent = nil)
    @graph = graph
    @name = name
    @parent = parent
  end

  def ancestors
    name == "start" ? [self] : [self, *parent.ancestors]
  end

  def descendents
    name == "end" ? [self] : [self, *children.flat_map(&:descendents)]
  end

  def children
    low_parents = ancestors.map(&:name).grep(/[a-z]/)
    exclude = low_parents.select { low_parents.count(_1) == 2 }
    exclude += low_parents.select { low_parents.count(_1) == 1 } if exclude.any?

    (graph.edges[name] - exclude - ["start"]).map do |name|
      Node.new(graph, name, self)
    end
  end
end

puts Graph.new(input.lines).root.descendents.count { _1.name == "end" }
