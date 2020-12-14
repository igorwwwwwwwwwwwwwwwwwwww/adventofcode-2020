input = <<EOF
939
7,13,x,x,59,x,31,19
EOF

input = File.read("13.txt")

# part 1

earliest_t = input.lines[0].to_i
bus_lines = input.lines[1].split(',').reject { |v| v == 'x' }.map(&:to_i)

current_t = earliest_t
until found = bus_lines.find { |v| current_t % v == 0 }
  current_t += 1
end

puts (current_t-earliest_t)*found

# part 2

# 7,13,x,x,59,x,31,19
# y+0=7x,y+1=13x,y+4=59x,y+6=31x,y+7=19x
# y=7x-0,y=13x-1,y=59x-4,y=31x-6,y=19x-7
#
# faster solution using extended euclid to compute lcm with offset

bus_lines = input.lines[1].split(',').each_with_index.map { |v, i| if v == 'x' then [nil, i] else [v.to_i, i] end }

# puts bus_lines.inspect

current_t = 0
bus_lines.each do |v, i|
  current_t = v-i if v && v-i > current_t
end

until bus_lines.all? {|v, i| !v || (current_t+i) % v == 0 }
  current_t += 1
end

puts current_t
