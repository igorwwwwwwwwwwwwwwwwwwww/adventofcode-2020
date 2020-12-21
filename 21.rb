require 'set'

input = <<EOF
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
EOF

input = File.read("21.txt")

ingredients = input.lines.map(&:strip).map {|line|
  raise unless m = /^(.+) \(contains (.+)\)$/.match(line)
  [m[1].split(' '), m[2].split(', ')]
}.to_h

# puts ingredients.inspect

possibilities = {}
ingredients.each do |k, v|
  v.each do |a|
    possibilities[a] ||= Set.new
    possibilities[a] << k.to_set
  end
end

identified = Set.new
translations = possibilities
  .map { |k, v| [k, v.reduce(:&)] }
  .group_by { |k, v| v.size }
  .sort_by { |k, v| k }
  .flat_map { |_, vs|
    vs = vs.to_h

    found_keys = []
    out = []

    100.times do
      vs.each do |k, v|
        v = v - identified
        next unless v.size == 1
        identified << v.first
        out << [k, v.first]
        found_keys << k
      end

      found_keys.each { |k| vs.delete(k) }

      break if vs.size == 0
    end

    raise "failed after 100 tries" unless vs.size == 0

    out
  }
  .to_h
  .invert

# puts translations.inspect

safe_ingredients = ingredients
  .flat_map { |k, v| k.reject { |i| translations[i] } }
  .to_set

# puts safe_ingredients.inspect

# part 1

puts ingredients
  .flat_map { |k, v| k.to_set & safe_ingredients }
  .map(&:size)
  .sum

# part 2

puts translations.sort_by { |k, v| v }.to_h.keys.join(',')
