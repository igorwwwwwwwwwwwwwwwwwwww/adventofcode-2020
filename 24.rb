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
