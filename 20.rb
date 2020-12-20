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
  b.to_s(2).reverse.to_i(2)
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

# edge_len = Math.sqrt(tiles.size).to_i
# (0..edge_len-1).each do |y|
#   (0..edge_len-1).each do |x|
#   end
# end

# tiles.each do |a_id, a|
#   tiles.each do |b_id, b|
#     next if a_id == b_id
#   end
# end

# puts (0..(1<<4)-1).to_a.product(tiles[1951]).inspect
#
# puts (0..(1<<4)-1).map { |flags| apply_flags(tiles[1951], flags) }.inspect
# puts (0..(1<<4)-1).map { |flags| apply_flags(tiles[2311], flags) }.inspect

# puts tiles.keys
#   .flat_map { |id| (0..(1<<4)-1).map { |flags| [id, flags] } }
#   .permutation(2)
#   .reject { |a, b| a[0] == b[0] }
#   .select { |a, b|
#     a_id, a_flags = a
#     b_id, b_flags = b
#     matches?(
#       apply_flags(tiles[a_id], a_flags),
#       apply_flags(tiles[b_id], b_flags),
#     )
#   }
#   .map { |a, b| [a[0], b[0]] }
#   .to_a
#   .inspect

# 1951    2311    3079
# 2729    1427    2473
# 2971    1489    1171

puts tiles.keys
  .permutation(2)
  .select { |a_id, b_id|
    a_set = tiles[a_id].to_set + tiles[a_id].map { |x| reverse_bits(x) }.to_set
    b_set = tiles[b_id].to_set + tiles[b_id].map { |x| reverse_bits(x) }.to_set
    (a_set & b_set).size > 0
  }
  .group_by { |x| x[0] }
  .map { |k, v| [k, v.map { |v| v[1] }.to_set] }
  .to_h
  .inspect
