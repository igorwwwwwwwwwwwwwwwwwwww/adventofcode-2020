input = <<EOF
5764801
17807724
EOF

input = File.read("25.txt")

pubkey_card, pubkey_door = input.lines.map(&:to_i)

puts pubkey_card
puts pubkey_door

def self.find_loop_size(pubkey)
  subject = 7
  val = 1
  loop_size = 0
  loop do
    loop_size += 1
    val = (val * subject) % 20201227
    break if val == pubkey
  end
  loop_size
end

def self.transform(loop_size, subject)
  val = 1
  loop_size.times do
    val = (val * subject) % 20201227
  end
  val
end

loop_size_card = find_loop_size(pubkey_card)
loop_size_door = find_loop_size(pubkey_door)

encryption_key1 = transform(loop_size_card, pubkey_door)
encryption_key2 = transform(loop_size_door, pubkey_card)

puts encryption_key1
puts encryption_key2
