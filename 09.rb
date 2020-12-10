input = <<EOF
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
EOF
window_size = 5

input = File.read("09.txt")
window_size = 25

data = input.lines.map(&:to_i)

i = window_size
found = nil
while data[i]
  candidates = data[i-window_size..i-1]
  res = candidates.permutation(2).select { |a, b| a+b == data[i] && a != b }.first
  unless res
    found = data[i]
    break
  end
  i += 1
end

puts found.inspect
