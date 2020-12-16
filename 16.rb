input = <<EOF
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
EOF

input = File.read("16.txt")

sections = input.split("\n\n")
rules = sections[0].lines.map do |line|
  k, v = line.split(": ")
  rule = v.split(' or ').map { |x| x.split('-').map(&:to_i) }
  [k, rule]
end.to_h
your_ticket = sections[1].lines[1].split(',').map(&:to_i)
nearby = sections[2].lines[1..-1].map { |line| line.split(',').map(&:to_i) }

# part 1

invalid = nearby
  .select { |t|
    t.any? { |x|
      rules.all? { |_, r|
        r.all? { |c| x < c[0] || x > c[1] }
      }
    }
  }
  .map { |t|
    t.select { |x| rules.all? { |_, r| r.all? { |c| x < c[0] || x > c[1] } } }
  }
  .flatten
  .reduce(:+)

puts invalid.inspect
