require "./compare_packets"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
end

RSpec.describe 'compare_packets' do
  it { expect(compare_packets(1, 1)).to eq(0) }
  it { expect(compare_packets(1, 2)).to eq(-1) }
  it { expect(compare_packets(2, 1)).to eq(1) }
  it { expect(compare_packets([], [])).to eq(0) }
  it { expect(compare_packets([1], [1])).to eq(0) }
  it { expect(compare_packets([1], [2])).to eq(-1) }
  it { expect(compare_packets([2], [1])).to eq(1) }
  it { expect(compare_packets([1], [1, 2])).to eq(-1) }
  it { expect(compare_packets([2], [1, 2])).to eq(1) }
  it { expect(compare_packets([1], 1)).to eq(0) }
  it { expect(compare_packets([1], 2)).to eq(-1) }
  it { expect(compare_packets([2], 1)).to eq(1) }
  it { expect(compare_packets([2, 1], [2])).to eq(1) }
  it { expect(compare_packets([2], [2, 1])).to eq(-1) }
  it { expect(compare_packets([1,1,3,1,1], [1,1,5,1,1])).to eq(-1) }
  it { expect(compare_packets([[1],[2,3,4]], [[1],4])).to eq(-1) }
  it { expect(compare_packets([9], [[8,7,6]])).to eq(1) }
  it { expect(compare_packets([[4,4],4,4], [[4,4],4,4,4])).to eq(-1) }
  it { expect(compare_packets([7,7,7,7], [7,7,7])).to eq(1) }
  it { expect(compare_packets([], [3])).to eq(-1) }
  it { expect(compare_packets([[[]]], [[]])).to eq(1) }
  it { expect(compare_packets([1,[2,[3,[4,[5,6,7]]]],8,9], [1,[2,[3,[4,[5,6,0]]]],8,9])).to eq(1) }
  it { expect(compare_packets([], [[]])).to eq(-1) }
  it { expect(compare_packets([1, [2, [3, [4, [5, 6, 7]]]], 8, 9], [])).to eq(1) }
end
