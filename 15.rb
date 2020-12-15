input = '0,3,6'
input = '0,8,15,2,12,1,4'

starting = input.split(',').map(&:to_i)

# part 1

seen = {}
t = 0
n = 0

starting.each do |n|
  # puts n
  seen[n] = [] unless seen[n]
  seen[n] << t
  t += 1
end

while t < 2020
  if seen[n] && seen[n].size > 1
    n = seen[n][-1] - seen[n][-2]
  else
    n = 0
  end

  # puts n
  seen[n] = [] unless seen[n]
  seen[n] << t
  t += 1
end

puts n
