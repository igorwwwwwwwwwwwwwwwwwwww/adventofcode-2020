require 'set'

input = <<EOF
abc

a
b
c

ab
ac

a
a
a
a

b
EOF

input = File.read("06.txt")

groups = input.split("\n\n")

# part 1

puts groups.map { |group| group.lines.map(&:strip).map(&:chars).flatten.uniq.size }.sum

# part 2

puts groups.map { |group| group.lines.map(&:strip).map(&:chars).map(&:to_set).reduce(&:&).size }.sum
