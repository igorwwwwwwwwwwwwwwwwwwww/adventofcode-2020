input = <<EOF
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
EOF

input = File.read("08.txt")

code = input.lines
  .map { |line|
    op, offset = line.strip.split(' ')
    { op: op, offset: offset.to_i }
  }

# part 1

acc = 0
ip = 0

while code[ip]
  # puts [ip, code[ip], acc].inspect

  instr = code[ip]
  if instr[:seen]
    break
  end
  instr[:seen] = true

  case instr[:op]
  when 'nop'
    ip += 1
  when 'acc'
    acc += instr[:offset]
    ip += 1
  when 'jmp'
    ip += instr[:offset]
  end
end

puts acc

# part 2

code.each do |instr|
  instr.delete(:seen)
end

def self.with_permutations(code)
  code.each_with_index do |instr, i|
    if instr[:op] == 'jmp'
      instr[:op] = 'nop'

      yield i

      instr[:op] = 'jmp'
    elsif instr[:op] == 'nop'
      instr[:op] = 'jmp'

      yield i

      instr[:op] = 'nop'
    end
  end
end

class ProbablyInfiniteLoopException < StandardError; end

def run_vm(code)
  acc = 0
  ip = 0
  i = 0

  while code[ip]
    # puts [ip, code[ip], acc, i].inspect

    instr = code[ip]
    if i >= 1_000
      raise ProbablyInfiniteLoopException
    end

    case instr[:op]
    when 'nop'
      ip += 1
    when 'acc'
      acc += instr[:offset]
      ip += 1
    when 'jmp'
      ip += instr[:offset]
    end

    i += 1
  end

  acc
end

with_permutations(code) do |i|
  # puts "permuting #{i}"
  puts run_vm(code)
rescue ProbablyInfiniteLoopException => e
end
