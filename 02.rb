input = <<EOF
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
EOF

input = File.read("02.txt")

valid = 0

input.lines.each do |line|
  m = /^(\d+)-(\d+) ([a-z]): (.*)$/.match(line)
  raise "no match on #{line}" unless m
  min = m[1].to_i
  max = m[2].to_i
  match_c  = m[3]
  password = m[4]

  n = password.chars.select { |c| c == match_c }.count
  if n >= min && n <= max
    valid += 1
  end
end

puts valid
