def read(bits)
  version = bits.slice!(0, 3)
  type = bits.slice!(0, 3).join.to_i(2)
  return read_number(bits) if type == 4

  packets = read_packets(bits)
  case type
  when 0 then packets.sum
  when 1 then packets.reduce(:*)
  when 2 then packets.min
  when 3 then packets.max
  when 5 then packets[0] > packets[1] ? 1 : 0
  when 6 then packets[0] < packets[1] ? 1 : 0
  when 7 then packets[0] == packets[1] ? 1 : 0
  end
end

def read_number(bits)
  parts = []
  loop do
    encoder = bits.slice!(0, 1).first
    parts.push bits.slice!(0, 4)
    return parts.join.to_i(2) if encoder == 0
  end
end

def read_packets(bits)
  if bits.slice!(0, 1).first == 1
    return bits.slice!(0, 11).join.to_i(2).times.map { read(bits) }
  end

  packets = []
  tail = bits.slice!(0, bits.slice!(0, 15).join.to_i(2)).dup
  packets.push read(tail) while tail.any?
  packets
end

input = File.read("16.txt")
puts read(input.chars.map { _1.to_i(16).to_s(2).rjust(4, "0") }.join.chars.map(&:to_i))
