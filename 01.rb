input = <<EOF
1721
979
366
299
675
1456
EOF

input = File.read('01.txt')

numbers = input.split.map(&:to_i)

res = nil
numbers.each do |n|
  numbers.each do |m|
    next if n == m
    if n + m == 2020
      res = n * m
      break 2
    end
  end
end

puts res.inspect
