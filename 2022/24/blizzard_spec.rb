require "rspec"

require "./blizzard"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
end

RSpec.describe Blizzard do
  let(:input) do
    <<~INPUT
      #.#####
      #.....#
      #>....#
      #.....#
      #...v.#
      #.....#
      #####.#
    INPUT
  end
  let(:map) { Map.new(input) }
  let(:blizzard) { Blizzard.new(1, 2, ">", map) }

  it { expect(blizzard.x).to eq(1) }
  it { expect(blizzard.y).to eq(2) }
  it { expect(blizzard.to_s).to eq(">") }
  it { expect(blizzard.size_x).to eq(5) }
  it { expect(blizzard.size_y).to eq(5) }
  it { expect(blizzard).to be_horizontal }
  it { expect(blizzard).not_to be_vertical }

  context "when going right" do
    let(:blizzard) { Blizzard.new(1, 2, ">", map) }

    it { expect(blizzard).to be_horizontal }
    it { expect(blizzard).not_to be_vertical }

    it { expect(blizzard.pos(0)).to eq([1, 2]) }
    it { expect(blizzard.pos(1)).to eq([2, 2]) }
    it { expect(blizzard.pos(2)).to eq([3, 2]) }
    it { expect(blizzard.pos(3)).to eq([4, 2]) }
    it { expect(blizzard.pos(4)).to eq([5, 2]) }
    it { expect(blizzard.pos(5)).to eq([1, 2]) }
    it { expect(blizzard.pos(6)).to eq([2, 2]) }
  end
  context "when going down" do
    let(:blizzard) { Blizzard.new(4, 4, "v", map) }

    it { expect(blizzard).not_to be_horizontal }
    it { expect(blizzard).to be_vertical }

    it { expect(blizzard.pos(0)).to eq([4, 4]) }
    it { expect(blizzard.pos(1)).to eq([4, 5]) }
    it { expect(blizzard.pos(2)).to eq([4, 1]) }
    it { expect(blizzard.pos(3)).to eq([4, 2]) }
    it { expect(blizzard.pos(4)).to eq([4, 3]) }
    it { expect(blizzard.pos(5)).to eq([4, 4]) }
    it { expect(blizzard.pos(6)).to eq([4, 5]) }
  end
  context "when going down" do
    let(:blizzard) { Blizzard.new(4, 4, "^", map) }

    it { expect(blizzard).not_to be_horizontal }
    it { expect(blizzard).to be_vertical }

    it { expect(blizzard.pos(0)).to eq([4, 4]) }
    it { expect(blizzard.pos(1)).to eq([4, 3]) }
    it { expect(blizzard.pos(2)).to eq([4, 2]) }
    it { expect(blizzard.pos(3)).to eq([4, 1]) }
    it { expect(blizzard.pos(4)).to eq([4, 5]) }
    it { expect(blizzard.pos(5)).to eq([4, 4]) }
    it { expect(blizzard.pos(6)).to eq([4, 3]) }
  end

  context "when going left" do
    let(:blizzard) { Blizzard.new(4, 4, "<", map) }

    it { expect(blizzard).to be_horizontal }
    it { expect(blizzard).not_to be_vertical }

    it { expect(blizzard.pos(0)).to eq([4, 4]) }
    it { expect(blizzard.pos(1)).to eq([3, 4]) }
    it { expect(blizzard.pos(2)).to eq([2, 4]) }
    it { expect(blizzard.pos(3)).to eq([1, 4]) }
    it { expect(blizzard.pos(4)).to eq([5, 4]) }
    it { expect(blizzard.pos(5)).to eq([4, 4]) }
    it { expect(blizzard.pos(6)).to eq([3, 4]) }
  end
end

RSpec.describe Map do
  let(:input) do
    <<~INPUT
      #.#####
      #.....#
      #>....#
      #.....#
      #...v.#
      #.....#
      #####.#
    INPUT
  end
  let(:map) { Map.new(input) }

  it { expect(map.blizzard_min_x).to eq(1) }
  it { expect(map.blizzard_min_y).to eq(1) }
  it { expect(map.blizzard_size_x).to eq(5) }
  it { expect(map.blizzard_size_y).to eq(5) }

  describe "#to_s" do
    it do
      expect(map.draw).to eq(<<~MAP.chomp)
        #.#####
        #.....#
        #>....#
        #.....#
        #...v.#
        #.....#
        #####.#
      MAP
    end

    it { expect(map.draw(0)).to eq(input.chomp) }

    it do
      expect(map.draw(1)).to eq(<<~MAP.chomp)
        #.#####
        #.....#
        #.>...#
        #.....#
        #.....#
        #...v.#
        #####.#
      MAP
    end

    it do
      expect(map.draw(2)).to eq(<<~MAP.chomp)
        #.#####
        #...v.#
        #..>..#
        #.....#
        #.....#
        #.....#
        #####.#
      MAP
    end

    it do
      expect(map.draw(3)).to eq(<<~MAP.chomp)
        #.#####
        #.....#
        #...2.#
        #.....#
        #.....#
        #.....#
        #####.#
      MAP
    end
  end

  describe "#possible_blizzards_on_pos" do
    let(:left_blizzard) { map.blizzards.first }
    let(:down_blizzard) { map.blizzards.last }
    it { expect(map.possible_blizzards_on_pos([1, 1])).to eq([]) }
    it { expect(map.possible_blizzards_on_pos([1, 2])).to eq([left_blizzard]) }
    it { expect(map.possible_blizzards_on_pos([1, 3])).to eq([]) }
    it { expect(map.possible_blizzards_on_pos([2, 2])).to eq([left_blizzard]) }
    it { expect(map.possible_blizzards_on_pos([3, 2])).to eq([left_blizzard]) }
    it do
      expect(map.possible_blizzards_on_pos([4, 2]))
      .to eq([left_blizzard, down_blizzard])
    end
    it { expect(map.possible_blizzards_on_pos([4, 1])).to eq([down_blizzard]) }
    it { expect(map.possible_blizzards_on_pos([4, 3])).to eq([down_blizzard]) }
    it { expect(map.possible_blizzards_on_pos([4, 4])).to eq([down_blizzard]) }
  end

  describe "#minutes_until_clear" do
    let(:input) do
      <<~INPUT
        #.#####
        #.....#
        #>>...#
        #...v.#
        #.....#
        #.....#
        #####.#
      INPUT
    end
    it { expect(map.minutes_until_clear(0, [1, 1])).to eq(0) }
    it { expect(map.minutes_until_clear(0, [1, 2])).to eq(0) }
    it { expect(map.minutes_until_clear(0, [2, 2])).to eq(1) }
    it { expect(map.minutes_until_clear(0, [3, 2])).to eq(2) }
    it { expect(map.minutes_until_clear(1, [3, 2])).to eq(1) }
    it { expect(map.minutes_until_clear(2, [3, 2])).to eq(0) }
    it { expect(map.minutes_until_clear(0, [4, 4])).to eq(1) }
    it { expect(map.minutes_until_clear(0, [4, 4])).to eq(1) }
    it { expect(map.minutes_until_clear(0, [4, 2])).to eq(0) }
    it { expect(map.minutes_until_clear(1, [4, 2])).to eq(3) }

    context "when it is not possible to clear" do
      let(:input) do
        <<~INPUT
          #.#####
          #...v.#
          #>>.v>#
          #.....#
          #.....#
          #.....#
          #####.#
        INPUT
      end

      it { expect(map.minutes_until_clear(0, [4, 2])).to be_nil }
      it { expect(map.minutes_until_clear(1, [4, 2])).to be_nil }
    end
  end

  describe "#adjacent_pos" do
    it { expect(map.adjacent_pos([1, 1])).to match_array([[1, 2], [2, 1]]) }
    it do
      expect(map.adjacent_pos([2, 2]))
        .to match_array([[2, 1], [3, 2], [2, 3], [1, 2]])
    end
  end

  describe "#adjacent_pos_with_cost" do
    it do
      expect(map.adjacent_pos_with_cost(0, [1, 1])).to match_array([
        [[1, 2], 1],
        [[2, 1], 1],
      ])
    end
    it do
      expect(map.adjacent_pos_with_cost(0, [1, 2])).to match_array([
        [[1, 1], 1],
        [[2, 2], 2],
        [[1, 3], 1],
      ])
    end
  end

  context "with more blizzards" do
    let(:input) do
      <<~INPUT
        #.######
        #>>.<^<#
        #.<..<<#
        #>v.><>#
        #<^v^^>#
        ######.#
      INPUT
    end
    # let(:input) { File.read("24.txt") }

    it { expect(map.draw(0)).to eq(input.chomp) }
    it { expect(map.draw(map.pattern_size)).to eq(input.chomp) }
  end
end

RSpec.describe Path do
  let(:map) { Map.new(input) }
  let(:input) do
    <<~INPUT
      #.######
      #>>.<^<#
      #.<..<<#
      #>v.><>#
      #<^v^^>#
      ######.#
    INPUT
  end
  let(:path) { Path.new(map) }

  it { expect(path.enter_pos).to eq([1, 0]) }
  it { expect(path.start_pos).to eq([1, 1]) }
  it { expect(path.end_pos).to eq([6, 4]) }
  it { expect(path.exit_pos).to eq([6, 5]) }

  it { expect(path.solve).to eq(18) }
end
