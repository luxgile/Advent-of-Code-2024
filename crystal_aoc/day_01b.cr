input = File.read("day_01_input.txt")

left = [] of Int32
right = [] of Int32

input.each_line do |line|
  left << line[0..5].to_i
  right << line[8..13].to_i
end

left = left.sort
right = right.sort

total_similarity = 0
left.each do |x|
  total_similarity += x * right.count(x)
end

puts total_similarity
