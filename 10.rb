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

# part 1, nicer

adapters = [0]
adapters += input.lines.map(&:to_i).sort
adapters << adapters.last+3
diffs = adapters.each_cons(2).map { |a, b| b-a }
histogram = diffs.group_by { |v| v }.map { |k, v| [k, v.count] }.to_h

puts histogram[1] * histogram[3]

#

puts "-"

# part 2, slow

def self.walk(adapters, jolts = 0)
  # puts adapters.inspect
  return {} unless adapters.size > 0
  next_adapters = adapters.to_set & [jolts+1, jolts+2, jolts+3].to_set
  return {} unless next_adapters.size > 0
  { jolts => next_adapters }.merge(next_adapters.map { |n| walk(adapters[1..adapters.size], n)}.reduce(:merge))
end

def self.walk_graph(graph, jolts_target, jolts = 0, path = [], paths = Set.new)
  if jolts == jolts_target
    paths << path
    return
  end
  graph[jolts].each do |next_jolt|
    walk_graph(graph, jolts_target, next_jolt, path + [next_jolt], paths)
  end
  paths
end

# graph = walk(adapters)
# puts walk_graph(graph, adapters.last).size

# part 2, fast

# i cheated. thank you stranger.
# https://www.reddit.com/r/adventofcode/comments/ka8z8x/2020_day_10_solutions/gfb598d/

adapters = input.lines.map(&:to_i).sort
adapters.unshift(0)
diffs = adapters.each_cons(2).map { |a, b| b-a }

possibilities = { adapters.last => 1 }
adapters[0..-2].reverse.each do |a|
  possibilities[a] = [a+1, a+2, a+3].map { |x| possibilities[x] || 0 }.sum
end
puts possibilities[0]
