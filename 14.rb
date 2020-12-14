input = <<EOF
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
EOF

input = File.read("14.txt")

# part 1

mask0 = 0x0
mask1 = 0x0
mem = {}
input.lines.each do |line|
  if m = /^mask = ((?:X|1|0){36})$/.match(line)
    mask0 = 0x0
    mask1 = 0x0
    m[1].chars.reverse.each_with_index.select { |v, i| v == '0' }.map { |v, i| i }.each do |i|
      mask0 = mask0 | (1 << i)
    end
    m[1].chars.reverse.each_with_index.select { |v, i| v == '1' }.map { |v, i| i }.each do |i|
      mask1 = mask1 | (1 << i)
    end
    puts "mask0 #{mask0} (#{mask0.to_s(2)}), mask1 #{mask1} (#{mask1.to_s(2)})"
  elsif m = /^mem\[(\d+)\] = (\d+)$/.match(line)
    mem[m[1].to_i] = m[2].to_i & (~mask0) | mask1
    puts "mem[#{m[1].to_i}] = #{mem[m[1].to_i]} (#{mem[m[1].to_i].to_s(2)})"
  else
    raise "invalid input: #{line.inspect}"
  end
end

puts mem.map { |k, v| v }.sum
