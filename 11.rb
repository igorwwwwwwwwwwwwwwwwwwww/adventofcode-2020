input = <<EOF
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
EOF

# input = <<EOF
# .......#.
# ...#.....
# .#.......
# .........
# ..#L....#
# ....#....
# .........
# #........
# ...#.....
# EOF

input = File.read("11.txt")

map = input.lines.map(&:strip).map(&:chars)

# part 1

def self.render(map)
  map.map { |row| row.join }.join("\n")
end

def self.step(map)
  xmax = map.first.size
  ymax = map.size

  map2 = []
  (0..ymax-1).each do |y|
    row2 = []
    (0..xmax-1).each do |x|
      adjacent_occupied = [-1, 0, 1]
        .product([-1, 0, 1])
        .reject { |v| v == [0, 0] }
        .reject { |dx, dy| x+dx < 0 || y+dy < 0 || x+dx > xmax-1 || y+dy > ymax-1 }
        .map { |dx, dy| (map[y+dy] || [])[x+dx] }
        .select { |v| v == '#' }
        .size

      case map[y][x]
      when 'L'
        # empty
        if adjacent_occupied == 0
          row2 << '#'
        else
          row2 << 'L'
        end
      when '#'
        # occupied
        if adjacent_occupied >= 4
          row2 << 'L'
        else
          row2 << '#'
        end
      when '.'
        # floor
        row2 << '.'
      else
        raise "invalid value #{map[y][x].inspect} at #{x} #{y}"
      end
    end
    map2 << row2
  end
  map2
end

def self.steps(map, n)
  n.times do
    map = step(map)
  end
  map
end

def self.steps_trace(map, n)
  puts render(map)

  n.times do
    puts
    map = step(map)
    puts render(map)
  end
  map
end

def self.steps_converge(map)
  prev = nil
  i = 0
  until map == prev
    prev = map
    map = step(map)
    i += 1
  end
  map
end

# steps_trace(map, 5)
# puts

# puts steps(map, 5) == steps(map, 6)
# puts

puts steps_converge(map).flatten.select { |v| v == '#' }.size

# part 2

def self.explore(map, x, y, dx, dy)
  xmax = map.first.size
  ymax = map.size

  while x+dx >= 0 && x+dx < xmax && y+dy >= 0 && y+dy < ymax
    x = x+dx
    y = y+dy
    if map[y][x] != '.'
      return map[y][x]
    end
  end

  nil
end

def self.step2(map)
  xmax = map.first.size
  ymax = map.size

  map2 = []
  (0..ymax-1).each do |y|
    row2 = []
    (0..xmax-1).each do |x|
      visible_occupied = [-1, 0, 1]
        .product([-1, 0, 1])
        .reject { |v| v == [0, 0] }
        .map { |dx, dy| explore(map, x, y, dx, dy) }
        .select { |v| v == '#' }
        .size

      case map[y][x]
      when 'L'
        # empty
        if visible_occupied == 0
          row2 << '#'
        else
          row2 << 'L'
        end
      when '#'
        # occupied
        if visible_occupied >= 5
          row2 << 'L'
        else
          row2 << '#'
        end
      when '.'
        # floor
        row2 << '.'
      else
        raise "invalid value #{map[y][x].inspect} at #{x} #{y}"
      end
    end
    map2 << row2
  end
  map2
end

def self.steps2(map, n)
  n.times do
    map = step2(map)
  end
  map
end

def self.steps2_trace(map, n)
  puts render(map)

  n.times do
    puts
    map = step2(map)
    puts render(map)
  end
  map
end

def self.steps2_converge(map)
  prev = nil
  i = 0
  until map == prev
    prev = map
    map = step2(map)
    i += 1
  end
  map
end

# steps2_trace(map, 6)
# puts

puts steps2_converge(map).flatten.select { |v| v == '#' }.size
