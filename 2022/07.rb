require "pathname"

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
path = Pathname.new("/")
input.each_line.each do |line|
  if line =~ /\$ cd (.+)/
    path = path.join($1)
  elsif line =~ /^(\d+)/
    path.ascend { sizes[_1] += $1.to_i }
  end
end

# Part one
p sizes.values.select { _1 <= 100_000 }.sum

# Part two
size = 30_000_000 - 70_000_000 + sizes[Pathname.new("/")]
p sizes.values.sort.find { _1 >= size }
