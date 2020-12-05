input = <<EOF
FBFBBFFRLR
BFFFBBFRRR
FFFBBBFRRR
BBFFBBFRLL
EOF

input = File.read("05.txt")

passes = input.lines.map { |line|
  chars = line.strip.chars

  lower = 0
  upper = 127
  chars.slice(0, 7).each_with_index do |c, i|
    case c
    when 'F'
      upper = upper - (1<<(7-i-1))
    when 'B'
      lower = lower + (1<<(7-i-1))
    else
      raise "invalid direction #{c}"
    end
  end
  raise "upper and lower mismatch: #{upper}, #{lower}" unless upper == lower
  row = lower

  lower = 0
  upper = 7
  chars.slice(7, 10).each_with_index do |c, i|
    case c
    when 'L'
      upper = upper - (1<<(3-i-1))
    when 'R'
      lower = lower + (1<<(3-i-1))
    else
      raise "invalid direction #{c}"
    end
  end
  raise "upper and lower mismatch: #{upper}, #{lower}" unless upper == lower
  col = lower

  [row, col, row*8+col]
}

# part 1

# puts passes
puts passes.map { |row, col, seat| seat }.max

# part 2

puts passes.map { |row, col, seat| seat }
  .sort
  .each_cons(2)
  .find { |a, b| a+1 != b }
  .first+1
