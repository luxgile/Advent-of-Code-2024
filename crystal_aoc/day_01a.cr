input = File.read("day_01_input.txt")

left = [] of Int32
right = [] of Int32

input.each_line do |line|
  left << line[0..5].to_i
  right << line[8..13].to_i
end

left.sort!
right.sort!

total_distance = 0
left.zip(right) do |l, r|
  total_distance += (l - r).abs
end
puts total_distance
