require 'set'

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

input = <<EOF
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
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

# part 2

valid = nearby
  .reject { |t|
    t.any? { |x|
      rules.all? { |_, r|
        r.all? { |c| x < c[0] || x > c[1] }
      }
    }
  }

invalidations = {}
(valid + [your_ticket]).each do |t|
  t.each_with_index do |x, tcol|
    rules.each do |rcol, r|
      unless r.any? { |c| x >= c[0] && x <= c[1] }
        invalidations[rcol] = Set.new unless invalidations[rcol]
        invalidations[rcol] << tcol
      end
    end
  end
end

unclaimed = (0..your_ticket.size-1).to_set

found = {}

invalidations.sort_by { |k, v| -v.size }.each do |k, v|
  diff = unclaimed - v
  raise "expected single element for key #{k}, got #{diff.size}: #{diff}" unless diff.size == 1
  tcol = diff.first

  found[k] = tcol
  unclaimed.delete(tcol)
end

raise "expected single remaining unclaimed item, got: #{unclaimed}" unless unclaimed.size == 1

remaining_col = (rules.keys.to_set - found.keys.to_set).first
found[remaining_col] = unclaimed.first

cols = found.invert

puts your_ticket
  .each_with_index.map { |x, i| [cols[i], x] }.to_h
  .select { |k, v| k.start_with?("departure") }
  .map { |k, v| v }
  .reduce(:*)
