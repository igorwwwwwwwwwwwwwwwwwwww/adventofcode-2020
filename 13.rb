input = <<EOF
939
7,13,x,x,59,x,31,19
EOF

input = File.read("13.txt")

earliest_t = input.lines[0].to_i
bus_lines = input.lines[1].split(',').reject { |v| v == 'x' }.map(&:to_i)

# part 1

current_t = earliest_t
until found = bus_lines.find { |v| current_t % v == 0 }
  current_t += 1
end

puts (current_t-earliest_t)*found
