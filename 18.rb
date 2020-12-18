input = <<EOF
1 + 2 * 3 + 4 * 5 + 6
1 + (2 * 3) + (4 * (5 + 6))
2 * 3 + (4 * 5)
5 + (8 * 3 + 9 + 3 * 4 * 3)
5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
EOF

input = File.read("18.txt")

lines = input.lines.map(&:strip).reject { |line| line[0] == '#' }

def self.read_subexp(tokens)
  level = 1
  sub = []
  while level > 0
    t = tokens.shift
    if t == '('
      level += 1
    elsif t == ')'
      level -= 1
    end
    sub << t
  end
  sub.pop # we added one closing paren too many
  sub
end

def self.eval_tokens(tokens)
  acc = nil
  while tokens.size > 0
    # puts "tokens: #{tokens}"

    if acc
      lhs = acc
    else
      t = tokens.shift
      if t == '('
        sub = read_subexp(tokens)
        lhs = eval_tokens(sub)
      else
        lhs = t.to_i
      end
    end

    op = tokens.shift

    t = tokens.shift
    if t == '('
      sub = read_subexp(tokens)
      rhs = eval_tokens(sub)
    else
      rhs = t.to_i
    end

    case op
    when '+'
      acc = lhs + rhs
    when '*'
      acc = lhs * rhs
    else
      raise "invalid op #{op}"
    end

    # puts "lhs: #{lhs}"
    # puts "op: #{op}"
    # puts "rhs: #{rhs}"
  end

  acc
end

results = lines.map do |line|
  tokens = line.gsub(' ', '').chars
  eval_tokens(tokens)
end

puts results.reduce(:+)
