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

acc = 0
ip = 0

# part 1

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
