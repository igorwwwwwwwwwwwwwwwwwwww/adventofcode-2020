require 'matrix'

input = <<EOF
F10
N3
F7
R90
F11
EOF

input = File.read("12.txt")

actions = input.lines.map(&:strip).map { |line| [line[0], line[1..line.size].to_i] }

x = 0
y = 0
dir = 90

# part 1

actions.each do |action, val|
  # puts [action, val].inspect
  case action
  when "N"
    x -= val
  when "S"
    x += val
  when "E"
    y += val
  when "W"
    y -= val
  when "L"
    dir -= val
  when "R"
    dir += val
  when "F"
    raise "direction not divisible by 90" unless dir % 90 == 0
    case (dir % 360)
    when 0
      x -= val
    when 90
      y += val
    when 180
      x += val
    when 270
      y -= val
    else
      raise "invalid direction #{dir}"
    end
  else
    raise "invalid action #{action}"
  end
end

puts (x.abs+y.abs)

# part 2

x = 0
y = 0

dx = 10
dy = -1

rotate = {
  -270 => Matrix[[0, -1], [1, 0]],
  -180 => Matrix[[-1, 0], [0, -1]],
  -90  => Matrix[[0, 1], [-1, 0]],
  0    => Matrix[[1, 0], [0, 1]],
  90   => Matrix[[0, -1], [1, 0]],
  180  => Matrix[[-1, 0], [0, -1]],
  270  => Matrix[[0, 1], [-1, 0]],
}

actions.each do |action, val|
  puts [action, val, 'x.y', x, y, 'dx.dy', dx, dy].join("\t")
  case action
  when "N"
    dy -= val
  when "S"
    dy += val
  when "E"
    dx += val
  when "W"
    dx -= val
  when "L"
    raise "direction not divisible by 90" unless val % 90 == 0
    r = rotate[-(val % 360)]
    dx, dy = (r*Vector[dx, dy]).to_a
  when "R"
    raise "direction not divisible by 90" unless val % 90 == 0
    r = rotate[(val % 360)]
    dx, dy = (r*Vector[dx, dy]).to_a
  when "F"
    x += dx * val
    y += dy * val
  else
    raise "invalid action #{action}"
  end
end

puts (x.abs+y.abs)
