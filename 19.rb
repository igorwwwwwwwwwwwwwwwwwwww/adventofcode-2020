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

# part 1

def self.to_regexp(grammar, k = 0)
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
    .yield_self { |s| "(?:#{s})" }
end

r = Regexp.new('^' + to_regexp(grammar) + '$')

# puts r

puts sections[1].lines.map(&:strip).select { |line| r.match(line) }.size

# part 2

grammar[8] = [[42], [42, 8]]
grammar[11] = [[42, 31], [42, 11, 31]]

# 8 => 42 | 42 8
# 8 => 42+

# 11 => 42 31 | 42 11 31
# 11 => 42 11? 31
# 11 => 42+ 31+         # (counts for 42 and 31 must match)
#                       # (we can specialize on max input len)

MAX_INPUT = sections[1].lines.map(&:strip).map(&:size).max

# puts grammar.select { |k,v| v.flatten.include?(8) }
# puts grammar.select { |k,v| v.flatten.include?(11) }

# {8=>[[42], [42, 8]], 0=>[[8, 11]]}
# {0=>[[8, 11]], 11=>[[42, 31], [42, 11, 31]]}

# 0 => [[8, 11]]

def self.to_regexp2(grammar, k = 0)
  if k == 8
    return '(?:' + to_regexp2(grammar, 42)+'+)'
  end
  if k == 11
    return '(?:' + (1..MAX_INPUT).map { |i| '(?:' + to_regexp2(grammar, 42) + "{#{i}}" + ')(' + to_regexp2(grammar, 31) + "{#{i}}" + ')' }.join('|') + ')'
  end

  grammar[k]
    .map { |r|
      r.map { |t|
        if Integer === t
          to_regexp2(grammar, t)
        else
          Regexp.escape(t)
        end
      }.join
    }
    .join('|')
    .yield_self { |s| "(?:#{s})" }
end

r = Regexp.new('^' + to_regexp2(grammar) + '$')

# puts r

puts sections[1].lines.map(&:strip).select { |line| r.match(line) }.size
