input = '389125467'
input = '198753462'

cups = input.strip.chars.map(&:to_i)

# puts cups.inspect

cups_min = cups.min
cups_max = cups.max

current = cups.first

100.times do
  # puts "cups: #{cups}"
  # puts "current: #{current}"

  removed = []
  removed << cups.delete_at((cups.index(current)+1) % (cups.size))
  removed << cups.delete_at((cups.index(current)+1) % (cups.size))
  removed << cups.delete_at((cups.index(current)+1) % (cups.size))

  # puts "pick up: #{removed.inspect}"

  destination = current-1
  if destination < cups_min
    destination = cups_max
  end
  while removed.include?(destination)
    destination -= 1
    if destination < cups_min
      destination = cups_max
    end
  end
  d = cups.index(destination)

  removed.each_with_index do |cup, i|
    cups.insert(d+i+1, cup)
  end

  c = (cups.index(current)+1) % (cups.size)
  current = cups[c]

  # puts "destination: #{destination}"
  # puts
end

# puts cups.inspect

c = cups.index(1)
puts (0..cups.size-1)
  .map { |i| cups[(c+i) % cups.size] }
  .drop(1)
  .join

# part 2

puts "-"

cups = input.strip.chars.map(&:to_i)
cups += (cups.max+1..1_000_000).to_a

cups_min = cups.min
cups_max = cups.max

current = cups.first
c = cups.index(current)

10_000_000.times do |outer|
  puts "#{Time.now} #{outer} processed" if outer % 1000 == 0
  # puts "cups: #{cups}"
  # puts "current: #{current}"

  removed = []
  removed << cups.delete_at((c+1) % (cups.size))
  c = cups.index(current) unless cups[c] == current
  removed << cups.delete_at((c+1) % (cups.size))
  c = cups.index(current) unless cups[c] == current
  removed << cups.delete_at((c+1) % (cups.size))

  # puts "pick up: #{removed.inspect}"

  destination = current-1
  if destination < cups_min
    destination = cups_max
  end
  while removed.include?(destination)
    destination -= 1
    if destination < cups_min
      destination = cups_max
    end
  end
  d = cups.index(destination)

  removed.each_with_index do |cup, i|
    cups.insert(d+i+1, cup)
  end

  c = (cups.index(current)+1) % (cups.size)
  current = cups[c]

  # puts "destination: #{destination}"
  # puts
end

puts cups.size
