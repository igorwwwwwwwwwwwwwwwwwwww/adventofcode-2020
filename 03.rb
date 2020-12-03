input = <<EOF
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
EOF

input = File.read("03.txt")

# part 1

map = input.lines.map do |line|
  line.chomp.chars
end

cycle = map.first.size

trees = 0
x = 0
y = 0

while map[y]
  val = map[y][x]
  if val == '#'
    trees += 1
  end

  x = (x + 3) % cycle
  y += 1
end

puts trees

# part 2

pairs = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]

tree_counts = pairs.map do |dx, dy|
  trees = 0
  x = 0
  y = 0

  while map[y]
    val = map[y][x]
    if val == '#'
      trees += 1
    end

    x = (x + dx) % cycle
    y += dy
  end

  trees
end

# puts tree_counts.inspect
puts tree_counts.reduce(:*)
