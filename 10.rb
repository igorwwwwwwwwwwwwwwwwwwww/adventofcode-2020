require 'set'

input = <<EOF
16
10
15
5
1
11
7
19
6
12
4
EOF

input = <<EOF
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
EOF

input = File.read("10.txt")

adapters = input.lines.map(&:to_i).to_set

built_in_adapter = adapters.max + 3
adapters << built_in_adapter

# part 1

jolts = 0
histogram = Hash.new(0)

while adapters.size > 0
  next_adapter = (adapters & [jolts+1, jolts+2, jolts+3].to_set).min
  raise 'no compatible adapter found' unless next_adapter
  histogram[next_adapter-jolts] += 1
  adapters.delete(next_adapter)
  jolts = next_adapter
  # puts next_adapter
end

# puts histogram
puts histogram[1] * histogram[3]
