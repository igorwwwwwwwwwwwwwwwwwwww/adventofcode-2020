input = <<EOF
.#.
..#
###
EOF

input = File.read("17.txt")

def self.set_nested(h, keys, val)
  keys[0..-2].each do |k|
    h[k] = {} unless h[k]
    h = h[k]
  end
  h[keys.last] = val
end

def self.get_nested(h, keys)
  k = nil
  keys.each do |k|
    return nil unless h[k]
    h = h[k]
  end
  h
end

map = {}

z = 0
input.lines.each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    if c == '#'
      set_nested(map, [z, y, x], true)
    end
  end
end

NEIGHBOR_OFFSETS = [-1, 0, 1]
  .product([-1, 0, 1])
  .product([-1, 0, 1])
  .map(&:flatten)
  .reject { |v| v == [0, 0, 0] }
  .freeze

def self.step(map)
  zmin = map.keys.min
  zmax = map.keys.max
  ymin = map.values.flat_map(&:keys).min
  ymax = map.values.flat_map(&:keys).max
  xmin = map.values.flat_map(&:values).flat_map(&:keys).min
  xmax = map.values.flat_map(&:values).flat_map(&:keys).max

  map2 = {}
  (zmin-1..zmax+1).each do |z|
    (ymin-1..ymax+1).each do |y|
      (xmin-1..xmax+1).each do |x|
        active_neighbors = NEIGHBOR_OFFSETS
          .map { |dx, dy, dz| get_nested(map, [z+dz, y+dy, x+dx]) }
          .select { |v| v }
          .size
        if get_nested(map, [z, y, x])
          remains_active = active_neighbors == 2 || active_neighbors == 3
          set_nested(map2, [z, y, x], remains_active)
        else
          becomes_active = active_neighbors == 3
          set_nested(map2, [z, y, x], becomes_active)
        end
      end
    end
  end
  map2
end

def self.steps(map, n)
  n.times do
    map = step(map)
  end
  map
end

def self.render(map)
  zmin = map.keys.min
  zmax = map.keys.max
  ymin = map.values.flat_map(&:keys).min
  ymax = map.values.flat_map(&:keys).max
  xmin = map.values.flat_map(&:values).flat_map(&:keys).min
  xmax = map.values.flat_map(&:values).flat_map(&:keys).max

  (zmin..zmax).each do |z|
    puts "z=#{z}"
    (ymin..ymax).each do |y|
      line = []
      (xmin..xmax).each do |x|
        if get_nested(map, [z, y, x])
          line << '#'
        else
          line << '.'
        end
      end
      puts line.join
    end
    puts
  end
end

# render(steps(map, 3))
puts steps(map, 6).values.flat_map(&:values).flat_map(&:values).select { |v| v }.size
