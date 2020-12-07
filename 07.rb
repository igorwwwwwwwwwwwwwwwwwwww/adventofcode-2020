require 'set'

input = <<EOF
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
EOF

input = <<EOF
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
EOF

input = File.read("07.txt")

rules = {}
input.lines.each do |line|
  m = /^(.+) bags contain (.+)\.$/.match(line.strip)
  raise "line regex failed on #{line.inspect}" unless m

  outer = m[1]
  inner = {}

  m[2].split(', ').each do |rule_str|
    next if rule_str == 'no other bags'

    mr = /^(\d+) (.+) bags?$/.match(rule_str)
    raise "rule_str regex failed on #{rule_str.inspect}" unless mr

    inner[mr[2]] = mr[1].to_i
  end

  rules[outer] = inner
end

# part 1

reverse = {}
rules.each do |outer, inner|
  inner.each do |inner_bag, count|
    reverse[inner_bag] = [] unless reverse[inner_bag]
    reverse[inner_bag] << outer
  end
end

def self.reverse_lookup(reverse, bag, first = true)
  res = Set.new
  res << bag unless first
  if reverse[bag]
    res += reverse[bag].map { |i| reverse_lookup(reverse, i, false) }.reduce(:+)
  end
  res
end

puts reverse_lookup(reverse, 'shiny gold').size

# part 2

def self.lookup(rules, bag, first = true)
  res = 0
  res += 1 unless first
  if rules[bag] && rules[bag].size > 0
    res += rules[bag].map { |i, count| lookup(rules, i, false) * count }.reduce(:+)
  end
  res
end

puts lookup(rules, 'shiny gold')
