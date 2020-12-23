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

class LinkedListNode
  attr_accessor :value
  attr_accessor :next

  def initialize(value, next_ = nil)
    @value = value
    @next = next_
  end

  def delete_next
    deleted = @next
    @next = deleted.next
    deleted.value
  end

  def insert_next(value)
    moved = @next
    @next = LinkedListNode.new(value, moved)
    @next
  end

  def each_node
    yield self
    head = self
    current = head
    while current.next != head
      current = current.next
      yield current
    end
  end

  def inspect
    a = to_a
    "LinkedList<#{a.first..a.last}>"
  end

  def to_a
    a = [@value]
    head = self
    current = head
    while current.next != head
      current = current.next
      a << current.value
    end
    a
  end

  def self.from_a(a)
    head = LinkedListNode.new(a.first)

    prev = head
    a[1..-1].each do |v|
      current = LinkedListNode.new(v)
      prev.next = current
      prev = current
    end

    # circular
    prev.next = head

    head
  end
end

cups = input.strip.chars.map(&:to_i)
cups += (cups.max+1..1_000_000).to_a

cups_min = cups.min
cups_max = cups.max

list = LinkedListNode.from_a(cups)

index = Array.new(cups.size)
list.each_node do |node|
  index[node.value] = node
end

10_000_000.times do |outer|
  puts "#{Time.now} #{outer} processed" if outer % 1_000_000 == 0

  current = list.value

  removed = []
  removed << list.delete_next
  removed << list.delete_next
  removed << list.delete_next

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

  d = index[destination]
  d.insert_next(removed.shift)
    .tap { |node| index[node.value] = node }
    .insert_next(removed.shift)
    .tap { |node| index[node.value] = node }
    .insert_next(removed.shift)
    .tap { |node| index[node.value] = node }

  list = list.next
end

puts index[1].next.value * index[1].next.next.value
