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

sizes = Hash.new(0)
current_path = "/"

input.each_line do |line|
  case line
  when /^\$ cd \.\.\n/
    current_path = File.dirname(current_path)
  when /^\$ cd ([^\/]+)\n/
    current_path = File.join(current_path, $1)
  when /^(\d+)/
    path = current_path
    loop do
      sizes[path] += $1.to_i
      break if path == "/"
      path = File.dirname(path)
    end
  end
end

# Part one
p sizes.values.select { _1 <= 100_000 }.sum

# Part two
p sizes.values.sort.find { _1 >= 30_000_000 - 70_000_000 + sizes["/"] }
