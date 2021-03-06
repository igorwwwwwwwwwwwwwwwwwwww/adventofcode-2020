require 'set'

input = 'esew'
input = 'nwwswee'
input = <<EOF
sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
EOF

input = File.read("24.txt")

# https://homepages.inf.ed.ac.uk/rbf/CVonline/LOCAL_COPIES/AV0405/MARTIN/Hex.pdf

lines = input.lines.map(&:strip).map { |l| l.scan(/(?<!n|s)e|se|sw|(?<!n|s)w|nw|ne/) }

destinations = lines.map { |l|
  pos = [0, 0, 0]
  l.each do |dir|
    case dir
    when 'e'
      pos[0] += 1
      pos[1] += 1
    when 'se'
      pos[0] += 1
      pos[2] -= 1
    when 'sw'
      pos[1] -= 1
      pos[2] -= 1
    when 'w'
      pos[0] -= 1
      pos[1] -= 1
    when 'nw'
      pos[0] -= 1
      pos[2] += 1
    when 'ne'
      pos[1] += 1
      pos[2] += 1
    end
  end
  pos
}

# puts lines.inspect
puts destinations.group_by { |v| v }.map { |k, v| [k, v.size] }.select { |k, v| v % 2 == 1 }.size.inspect

# part 2

def self.neighbors(pos)
  [
    [pos[0]+1, pos[1]+1, pos[2]],
    [pos[0]+1, pos[1], pos[2]-1],
    [pos[0], pos[1]-1, pos[2]-1],
    [pos[0]-1, pos[1]-1, pos[2]],
    [pos[0]-1, pos[1], pos[2]+1],
    [pos[0], pos[1]+1, pos[2]+1],
  ]
end

def self.move(pos, dir)
  pos = pos.dup
  case dir
  when 'e'
    pos[0] += 1
    pos[1] += 1
  when 'se'
    pos[0] += 1
    pos[2] -= 1
  when 'sw'
    pos[1] -= 1
    pos[2] -= 1
  when 'w'
    pos[0] -= 1
    pos[1] -= 1
  when 'nw'
    pos[0] -= 1
    pos[2] += 1
  when 'ne'
    pos[1] += 1
    pos[2] += 1
  end
  pos
end

# puts lines.inspect
black_tiles = destinations.group_by { |v| v }.map { |k, v| [k, v.size] }.select { |k, v| v % 2 == 1 }.to_h.keys.to_set

100.times do
  flip_to_white = Set.new
  flip_to_black = Set.new

  (black_tiles + black_tiles.flat_map { |pos| neighbors(pos) }.to_set).each do |pos|
    neighbors_count = neighbors(pos).select { |n| black_tiles.include?(n) }.size
    if black_tiles.include?(pos) && neighbors_count == 0 || neighbors_count > 2
      flip_to_white << pos
    elsif !black_tiles.include?(pos) && neighbors_count == 2
      flip_to_black << pos
    end
  end

  flip_to_white.each { |pos| black_tiles.delete(pos) }
  flip_to_black.each { |pos| black_tiles << pos }
end

puts black_tiles.size
