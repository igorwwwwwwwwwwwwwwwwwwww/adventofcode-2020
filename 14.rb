require 'set'

input = <<EOF
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
EOF

input = <<EOF
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
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

# part 2

def self.power_set(a)
 (0..a.size).flat_map {|x| a.combination(x).to_a}
end

mask1 = 0x0
floating = Set.new
mem = {}
input.lines.each do |line|
  if m = /^mask = ((?:X|1|0){36})$/.match(line)
    mask1 = 0x0
    m[1].chars.reverse.each_with_index.select { |v, i| v == '1' }.map { |v, i| i }.each do |i|
      mask1 = mask1 | (1 << i)
    end
    floating = m[1].chars.reverse.each_with_index.select { |v, i| v == 'X' }.map { |v, i| i }.to_set
    puts "mask1 #{mask1} (#{mask1.to_s(2)}), floating #{floating}"
  elsif m = /^mem\[(\d+)\] = (\d+)$/.match(line)
    power_set(floating.to_a).each do |mask_bits|
      addr = m[1].to_i | mask1
      floating.each do |i|
        if mask_bits.include?(i)
          addr = addr | (1 << i)
        else
          addr = addr & (~(1 << i))
        end
      end
      mem[addr] = m[2].to_i
    end
    # puts "mem[#{addr}] = #{m[2].to_i} (#{addr.to_s(2)})"
  else
    raise "invalid input: #{line.inspect}"
  end
end

puts mem.map { |k, v| v }.sum
