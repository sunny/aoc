require "rspec"

require "./scan"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
end

RSpec.describe Dot do
  let(:scan) { Scan.new("1,1,1\n2,1,1") }
  let(:dot) { scan.at(1, 1, 1) }

  describe "#adjacents" do
    it "returns dots and spaces" do
      expect(dot.adjacents.size).to eq(6)
      expect(scan.adjacents(1, 1, 1)).to all(be_a(Dot).or(be_a(Space)))
    end
  end

  describe "#exposed_sides" do
    it { expect(dot.exposed_sides).to eq(5) }
  end
end

RSpec.describe Scan do
  let(:scan) { Scan.new(input) }
  let(:input) { "1,1,1\n2,1,1" }

  describe "#at" do
    it { expect(scan.at(1, 1, 1)).to be_a(Dot) }
    it { expect(scan.at(2, 1, 1)).to be_a(Dot) }
    it { expect(scan.at(2, 1, 2)).to be_a(Space) }
    it { expect(scan.at(0, 0, 0)).to be_a(Space) }
    it { expect(scan.at(-1, 0, 0)).to be_nil }
    it { expect(scan.at(0, -1, 0)).to be_nil }
    it { expect(scan.at(0, 0, -1)).to be_nil }
  end

  describe "#adjacents" do
    it "returns dots and spaces" do
      expect(scan.adjacents(1, 1, 1)).to all(be_a(Dot).or(be_a(Space)))
      expect(scan.adjacents(0, 0, 0).size).to eq(3)
      expect(scan.adjacents(0, 1, 0).size).to eq(4)
      expect(scan.adjacents(1, 1, 1).size).to eq(6)
    end
  end

  describe "#all_x" do
    it { expect(scan.all_x).to eq([1, 2]) }
  end

  describe "#all_y" do
    it { expect(scan.all_y).to eq([1]) }
  end

  describe "#all_z" do
    it { expect(scan.all_z).to eq([1]) }
  end

  describe "#max_x" do
    it { expect(scan.max_x).to eq(3) }
  end

  describe "#max_y" do
    it { expect(scan.max_y).to eq(2) }
  end

  describe "#max_z" do
    it { expect(scan.max_z).to eq(2) }
  end

  describe "#exposed_sides" do
    it "can parse a simple input" do
      expect(scan.exposed_sides).to eq(10)
    end
  end

  describe "#root" do
    it { expect(scan.root).to be_a(Space) }
  end

  describe "#to_s" do
    it "returns a string of known coordinates" do
      expect(scan.to_s).to eq(<<~GRID.chomp)
        ....
        ....
        ....

        ....
        .##.
        ....

        ....
        ....
        ....
      GRID
    end
  end

  describe "#fill" do
    it "steams and touches all spaces" do
      scan.fill

      expect(scan.to_s).to eq(<<~GRID.chomp)
        ~~~~
        ~~~~
        ~~~~

        ~~~~
        ~55~
        ~~~~

        ~~~~
        ~~~~
        ~~~~
      GRID

      expect(scan.exterior_surface).to eq(10)
    end
  end

  context "with a larger input" do
    let(:input) do
      <<~INPUT
        2,2,2
        1,2,2
        3,2,2
        2,1,2
        2,3,2
        2,2,1
        2,2,3
        2,2,4
        2,2,6
        1,2,5
        3,2,5
        2,1,5
        2,3,5
      INPUT
    end

    describe "#at" do
      it { expect(scan.at(2, 2, 2)).to be_a(Dot) }
      it { expect(scan.at(1, 2, 2)).to be_a(Dot) }
      it { expect(scan.at(3, 2, 2)).to be_a(Dot) }
      it { expect(scan.at(1, 2, 3)).to be_a(Space) }
      it { expect(scan.at(0, 0, 0)).to be_a(Space) }
      it { expect(scan.at(-1, 0, 0)).to be_nil }
      it { expect(scan.at(0, -1, 0)).to be_nil }
      it { expect(scan.at(0, 0, -1)).to be_nil }
    end

    describe "#adjacents" do
      it "returns dots and spaces" do
        expect(scan.adjacents(1, 1, 1)).to all(be_a(Dot).or(be_a(Space)))
        expect(scan.adjacents(0, 0, 0).size).to eq(3)
        expect(scan.adjacents(0, 1, 0).size).to eq(4)
        expect(scan.adjacents(1, 1, 1).size).to eq(6)
      end
    end

    describe "#all_x" do
      it { expect(scan.all_x).to contain_exactly(1, 2, 3) }
    end

    describe "#all_y" do
      it { expect(scan.all_y).to contain_exactly(1, 2, 3) }
    end

    describe "#all_z" do
      it { expect(scan.all_z).to contain_exactly(1, 2, 3, 4, 5, 6) }
    end

    describe "#max_x" do
      it { expect(scan.max_x).to eq(4) }
    end

    describe "#max_y" do
      it { expect(scan.max_y).to eq(4) }
    end

    describe "#max_z" do
      it { expect(scan.max_z).to eq(7) }
    end

    describe "#to_s" do
      it "returns a string of known coordinates" do
        expect(scan.to_s).to eq(<<~GRID.chomp)
          .....
          .....
          .....
          .....
          .....

          .....
          .....
          ..#..
          .....
          .....

          .....
          ..#..
          .###.
          ..#..
          .....

          .....
          .....
          ..#..
          .....
          .....

          .....
          .....
          ..#..
          .....
          .....

          .....
          ..#..
          .#.#.
          ..#..
          .....

          .....
          .....
          ..#..
          .....
          .....

          .....
          .....
          .....
          .....
          .....
        GRID
      end
    end

    describe "#fill" do
      it "steams and touches all spaces" do
        scan.fill
        expect(scan.at(0, 0, 0)).to be_steam
        expect(scan.at(1, 0, 0)).to be_steam
        expect(scan.at(0, 1, 0)).to be_steam
        expect(scan.at(0, 0, 1)).to be_steam
        expect(scan.at(0, 1, 1)).to be_steam
        expect(scan.at(1, 1, 1)).to be_steam
        expect(scan.at(1, 1, 0)).to be_steam
        expect(scan.at(0, 1, 1)).to be_steam
        expect(scan.at(1, 0, 1)).to be_steam

        expect(scan.at(2, 1, 1)).to be_steam
        expect(scan.at(1, 2, 1)).to be_steam
        expect(scan.at(1, 1, 2)).to be_steam
        expect(scan.at(1, 2, 2)).to be_touched
        expect(scan.at(2, 2, 2)).not_to be_touched
        expect(scan.at(2, 2, 1)).to be_touched
        expect(scan.at(2, 1, 2)).to be_touched

        expect(scan.at(2, 2, 5)).not_to be_steam

        expect(scan.to_s).to eq(<<~GRID.chomp)
          ~~~~~
          ~~~~~
          ~~~~~
          ~~~~~
          ~~~~~

          ~~~~~
          ~~~~~
          ~~5~~
          ~~~~~
          ~~~~~

          ~~~~~
          ~~5~~
          ~5#5~
          ~~5~~
          ~~~~~

          ~~~~~
          ~~~~~
          ~~4~~
          ~~~~~
          ~~~~~

          ~~~~~
          ~~~~~
          ~~4~~
          ~~~~~
          ~~~~~

          ~~~~~
          ~~5~~
          ~5.5~
          ~~5~~
          ~~~~~

          ~~~~~
          ~~~~~
          ~~5~~
          ~~~~~
          ~~~~~

          ~~~~~
          ~~~~~
          ~~~~~
          ~~~~~
          ~~~~~
        GRID

        expect(scan.exterior_surface).to eq(58)
      end
    end
  end
end
