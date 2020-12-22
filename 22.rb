require 'set'

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

# input = <<EOF
# Player 1:
# 43
# 19
#
# Player 2:
# 2
# 29
# 14
# EOF

input = File.read("22.txt")

# part 1

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

# part 2

players = input.split("\n\n").map { |p| p.lines.map(&:strip)[1..-1].map(&:to_i) }

def self.recursive_combat(players, seen = Set.new)
  # puts "new game #{players.map(&:size)}"

  until players.any? { |p| p.size == 0 }
    # puts players.inspect

    return 0, players[0] if seen.include?(players) # we've been here before, player 0 wins this game
    seen << players

    recur_decider = players.map(&:first).each_with_index.select { |card, p| players[p].size-1 >= card }.map { |card, p| card }
    if recur_decider.size == 2
      # puts "recur #{recur_decider}"
      round_winner, _ = recursive_combat(players.map(&:dup).each_with_index.map { |v, p| v.slice(1, recur_decider[p]) })
      players[round_winner] << players[round_winner].shift
      players[round_winner] << players[(round_winner+1)%2].shift
      # puts "recur winner #{round_winner}"
    else
      round_winner = players.map(&:first).each_with_index.max[1]
      players[round_winner] += players.map(&:shift).sort.reverse
    end
  end

  game_winner = players.index { |p| p.size > 0 }
  [game_winner, players[game_winner]]
end

puts recursive_combat(players)[1]
  .each_with_index
  .map { |v, i| v * (num_cards-i) }
  .sum
