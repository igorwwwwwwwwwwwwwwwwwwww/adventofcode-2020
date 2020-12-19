input = <<EOF
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
EOF

input = File.read("19.txt")

sections = input.split("\n\n")

NUMERIC = /^([0-9]+)$/

grammar = sections[0].lines.map(&:strip).map { |line|
  k, v = line.split(':')
  v = v.split('|').map { |r|
    r.strip.split(' ').map { |t|
      if NUMERIC.match(t)
        t.to_i
      else
        t[1..-2]
      end
    }
  }
  [k.to_i, v]
}.to_h

def self.to_regexp(grammar, k)
  grammar[k]
    .map { |r|
      r.map { |t|
        if Integer === t
          to_regexp(grammar, t)
        else
          Regexp.escape(t)
        end
      }.join
    }
    .join('|')
    .yield_self { |s| "(#{s})" }
end

r = Regexp.new('^' + to_regexp(grammar, 0) + '$')

# puts r

puts sections[1].lines.map(&:strip).select { |line| r.match(line) }.size
