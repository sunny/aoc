input = "$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k"

# input = File.read("07.txt")

dirs = {}
current_dir = nil

input.lines.each do |line|
  case line
  when /^\$ cd \/$/
    current_dir = ""
  when /^\$ cd \.\.$/
    current_dir = current_dir.split("/").tap(&:pop).join("/")
  when /^\$ cd (.+)$/
    current_dir = (current_dir.split("/") + [$1]).join("/")
  when /^(\d+) .+$/
    path = current_dir
    size = $1.to_i
    loop do
      dirs[path] ||= 0
      dirs[path] += size.to_i
      break if path == ""
      path = path.gsub(/(\/|^)[^\/]+$/, "")
    end
  end
end

# Part one
p dirs.select { |k, v| v <= 100_000 }.sum(&:last)

# Part two
space = 70_000_000
required_space = 30_000_000
unused = space - dirs[""]
to_delete = required_space - unused
p dirs.sort_by { |k, v| v }.find { |k, v| v >= to_delete }.last
