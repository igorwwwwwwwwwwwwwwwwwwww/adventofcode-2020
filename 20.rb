require 'set'

input = <<EOF
Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
EOF

# input = 144 tiles
# sqrt(144) = 12
# we need to make a 12x12 grid

# input = File.read("20.txt")

tiles = input.split("\n\n").map(&:strip).map { |block|
  raise unless m = /^Tile (\d+):$/.match(block.lines[0])
  id = m[1].to_i

  frame = block.lines[1..-1].map(&:strip)
  ymax = frame.size-1
  xmax = frame.first.size-1
  edges = [
    (0..xmax).map { |x| frame[0][x] == '#' ? 1 : 0 }.join.to_i(2),
    (0..xmax).map { |x| frame[ymax][x] == '#' ? 1 : 0 }.join.to_i(2),
    (0..ymax).map { |y| frame[y][0] == '#' ? 1 : 0 }.join.to_i(2),
    (0..ymax).map { |y| frame[y][xmax] == '#' ? 1 : 0 }.join.to_i(2),
  ]

  [id, edges]
}.to_h

def self.reverse_bits(b)
  b.to_s(2).rjust(10, '0').reverse.to_i(2)
end

# rotate clockwise
# flip vertical
# flip horizontal
# flip both
#
# RCW   FLV   FLH   FLB
# 1 2   2 1   3 4   4 3
# 3 4   4 3   1 2   2 1
#
# 3 1   1 3   4 2   2 4
# 4 2   2 4   3 1   1 3
#
# 4 3   3 4   2 1   1 2
# 2 1   1 2   4 3   3 4
#
# 2 4   4 2   1 3   3 1
# 1 3   3 1   2 4   4 2

def self.apply_flags(val, flags)
  val = val.dup
  if (flags & 0b01) == 0b01
    val[0] = reverse_bits(val[0])
    val[1] = reverse_bits(val[1])
  end
  if (flags & 0b10) == 0b10
    val[2] = reverse_bits(val[2])
    val[3] = reverse_bits(val[3])
  end
  (flags >> 2).times do
    val[0], val[1], val[2], val[3] = val[2], val[3], val[0], val[1]
  end
  val
end

def self.matches?(a, b)
  a[0] == b[0] || a[1] == b[1] || a[2] == b[2] || a[3] == b[3]
end

num_edge_tiles = Math.sqrt(tiles.size).to_i

# 1951    2311    3079
# 2729    1427    2473
# 2971    1489    1171

# part 1

adjacent = tiles.keys
  .permutation(2)
  .select { |a_id, b_id|
    a_set = tiles[a_id].to_set + tiles[a_id].map { |x| reverse_bits(x) }.to_set
    b_set = tiles[b_id].to_set + tiles[b_id].map { |x| reverse_bits(x) }.to_set
    (a_set & b_set).size > 0
  }
  .flat_map { |a_id, b_id| [[a_id, b_id], [b_id, a_id]] }
  .group_by { |x| x[0] }
  .map { |k, v| [k, v.map { |x| x[1] }.to_set] }
  .to_h

corners = adjacent
  .select { |k, v| v.size == 2 }
  .to_h
  .keys

puts "corners: #{corners.inspect}"
puts corners.reduce(:*)

# part 2

# histogram of distribution
# - 2 is a corner
# - 3 is on a wall
# - 4 is in the center
#
# example (3x3)
#   {2=>4, 3=>4, 4=>1}
#   4 corners, (3-2)*4 side, (3-2)*(3-2) center
#
# 20.txt (12x12)
#   {2=>4, 3=>40, 4=>100}
#   4 corners, (12-2)*4 side, (12-2)*(12-2) center

puts adjacent
  .group_by { |k, v| v.size }
  .map { |k, v| [k, v.size] }
  .sort_by { |k, v| k }
  .to_h
  .inspect

map = {}
placed = Set.new
outer_frame = []

n = corners.shift
placed << n
outer_frame << n
prev = n

(1..((num_edge_tiles-1)*4)-1).each do |i|
  if i % (num_edge_tiles-1) == 0
    n = adjacent[prev].select { |n| adjacent[n].size == 2 }.reject { |n| placed.include?(n) }.first
  else
    n = adjacent[prev].select { |n| adjacent[n].size == 3 }.reject { |n| placed.include?(n) }.first
  end
  raise "no next tile found" unless n
  placed << n
  outer_frame << n
  prev = n
end

a, b, c, d = outer_frame.each_slice(num_edge_tiles-1).to_a
a.each_with_index do |n, i|
  map[[i, 0]] = n
end
b.each_with_index do |n, i|
  map[[num_edge_tiles-1, i]] = n
end
c.each_with_index do |n, i|
  map[[num_edge_tiles-1-i, num_edge_tiles-1]] = n
end
d.each_with_index do |n, i|
  map[[0, num_edge_tiles-1-i]] = n
end

prev = map[[0, 0]]
(1..num_edge_tiles-2).each do |y|
  (1..num_edge_tiles-2).each do |x|
    n = (adjacent[map[[x-1, y]]] & adjacent[map[[x, y-1]]]).reject { |n| placed.include?(n) }.first
    raise unless n
    placed << n
    map[[x, y]] = n
    prev = n
  end
end

grid = (0..num_edge_tiles-1).map do |y|
  (0..num_edge_tiles-1).map do |x|
    map[[x, y]]
  end
end
puts
puts grid.map { |row| row.join(' ') }.join("\n")
puts
