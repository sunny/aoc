input = "D2FE28"
# input = File.read("16.txt") # => 660797830937

def read(bits)
  version = bits.slice!(0, 3).join.to_i(2)
  type = bits.slice!(0, 3).join.to_i(2)

  if type == 4
    result, bits = number_from_packet(bits)
  elsif type == 0
    result, bits = sum(bits)
  elsif type == 1
    result, bits = product(bits)
  elsif type == 2
    result, bits = min(bits)
  elsif type == 3
    result, bits = max(bits)
  elsif type == 5
    result, bits = sub_packets(bits)
    result = result[0] > result[1] ? 1 : 0
  elsif type == 6
    result, bits = sub_packets(bits)
    result = result[0] < result[1] ? 1 : 0
  elsif type == 7
    result, bits = sub_packets(bits)
    result = result[0] == result[1] ? 1 : 0
  else
    raise "unknown operator type #{type}"
  end
  return result, bits
end

def sum(bits)
  result, bits = sub_packets(bits)
  return result.sum, bits
end

def product(bits)
  result, bits = sub_packets(bits)
  return result.reduce(:*), bits
end

def min(bits)
  result, bits = sub_packets(bits)
  return result.min, bits
end
def max(bits)
  result, bits = sub_packets(bits)
  return result.max, bits
end

def number_from_packet(bits)
  number = ""
  loop do
    encoder, bit, bits = bits[0], bits[1..4], bits[5..-1]
    number += bit.join
    break if encoder == "0"
  end
  return number.to_i(2), bits
end

def sub_packets(packet)
  length_type, packet = packet[0], packet[1..-1]
  subs = []

  if length_type == "0"
    length_packet, packet = packet[0...15], packet[15..-1]
    sub_length = length_packet.join.to_i(2)

    sub_packets, packet = packet[0...sub_length], packet[sub_length..-1]
    while sub_packets.size > 0
      result, sub_packets = read(sub_packets)
      subs.push(result)
    end
  else
    length_packet, packet = packet[0...11], packet[11..-1]
    sub_count = length_packet.join.to_i(2)

    sub_count.times do |i|
      result, packet = read(packet)
      subs.push(result)
    end
  end

  return subs, packet
end

bits = input.chars.map { _1.to_i(16).to_s(2).rjust(4, "0") }.join.chars
p read(bits)[0]
# p read(bits)[0] == 660797830937
