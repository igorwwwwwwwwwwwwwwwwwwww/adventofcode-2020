input = <<EOF
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
EOF

input = File.read("04.txt")

passports = input
  .split("\n\n")
  .map(&:split)
  .map { |kvs|
    kvs.map { |kv| kv.split(':', 2) }.to_h
  }

# part 1

required = %w[byr iyr eyr hgt hcl ecl pid] # cid

puts passports.select { |p| required.all? { |f| p[f] } }.size
