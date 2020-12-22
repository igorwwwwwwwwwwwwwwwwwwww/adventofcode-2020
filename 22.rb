input = <<EOF
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
EOF

input = File.read("22.txt")

players = input.split("\n\n").map { |p| p.lines.map(&:strip)[1..-1].map(&:to_i) }
num_cards = players.flat_map(&:size).sum

until players.any? { |p| p.size == num_cards }
  # puts players.inspect
  round_winner = players.map(&:first).each_with_index.max[1]
  players[round_winner] += players.map(&:shift).sort.reverse
end

# puts players.inspect

puts players
  .find { |p| p.size > 0 }
  .each_with_index
  .map { |v, i| v * (num_cards-i) }
  .sum
