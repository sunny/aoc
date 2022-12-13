def compare_packets(left, right)
  return -1 if left.nil?
  return 1 if right.nil?
  return left <=> right if left.is_a?(Integer) && right.is_a?(Integer)

  left = Array(left)
  right = Array(right)
  left.zip(right).each do
    result = compare_packets(_1, _2)
    return result unless result == 0
  end

  left.size <=> right.size
end
