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
