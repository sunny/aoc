def compare_packets(left, right)
  case [left, right]
  in [nil, _] then -1
  in [_, nil] then 1
  in [Integer, Integer] then left <=> right
  in [Array, Integer] then compare_packets(left, [right])
  in [Integer, Array] then compare_packets([left], right)
  else
    left.zip(right).lazy.map { compare_packets(_1, _2) }.find { _1 != 0 } ||
      left.size <=> right.size
  end
end
