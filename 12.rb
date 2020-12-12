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
