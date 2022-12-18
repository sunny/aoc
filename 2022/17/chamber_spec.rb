require "rspec"

require "./chamber"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
end

RSpec.describe "Chamber" do
  let(:moves) { ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>".chars }
  let(:chamber) { Chamber.new(moves) }
  let(:drawn_lines) { chamber.draw_lines.join("\n") }

  it "can run until 1 rock is shown" do
    expect(chamber.run_until(1)).to eq(3)
    expect(chamber.rocks_count).to eq(1)
    expect(chamber.ticks).to eq(0)
    expect(chamber.height).to eq(3)
    expect(chamber.width).to eq(7)
    expect(chamber.grid).to be_empty
    expect(chamber.max_placed_y).to eq(nil)
    expect(chamber.next_rock_y).to eq(3)
    expect(chamber.gas_direction).to eq(">")
    expect(chamber.rock.x).to eq(2)
    expect(chamber.rock.y).to eq(3)
    expect(chamber.rock.shape).to eq([[1, 1, 1, 1]])
    expect(chamber.grid).to eq({})

    expect(drawn_lines).to eq(<<~GRID.chomp)
      ..@@@@.
      .......
      .......
      .......
    GRID
  end

  it "can run until 2 rocks are shown" do
    expect(chamber.run_until(2)).to eq(4)
    expect(chamber.rocks_count).to eq(2)
    expect(chamber.ticks).to eq(4)
    expect(chamber.height).to eq(6)
    expect(chamber.width).to eq(7)
    expect(chamber.max_placed_y).to eq(0)
    expect(chamber.next_rock_y).to eq(4)
    expect(chamber.gas_direction).to eq("<")
    expect(chamber.rock.x).to eq(2)
    expect(chamber.rock.y).to eq(4)
    expect(chamber.rock.shape).to eq([[0, 1, 0], [1, 1, 1], [0, 1, 0]])
    expect(chamber.grid)
      .to eq(
        {
          0 => [0, 0, 1, 1, 1, 1, 0],
        }
      )

    expect(drawn_lines).to eq(<<~GRID.chomp)
      ...@...
      ..@@@..
      ...@...
      .......
      .......
      .......
      ..####.
    GRID
  end

  it "can run until 3 rocks are shown" do
    expect(chamber.run_until(3)).to eq(7)
    expect(chamber.rocks_count).to eq(3)
    expect(chamber.ticks).to eq(8)
    expect(chamber.height).to eq(9)
    expect(chamber.width).to eq(7)
    expect(chamber.max_placed_y).to eq(3)
    expect(chamber.next_rock_y).to eq(7)
    expect(chamber.gas_direction).to eq(">")
    expect(chamber.rock.x).to eq(2)
    expect(chamber.rock.y).to eq(7)
    expect(chamber.rock.shape).to eq([[0, 0, 1], [0, 0, 1], [1, 1, 1]])
    expect(chamber.grid)
      .to eq(
        {
          3 => [0, 0, 0, 1, 0, 0, 0],
          2 => [0, 0, 1, 1, 1, 0, 0],
          1 => [0, 0, 0, 1, 0, 0, 0],
          0 => [0, 0, 1, 1, 1, 1, 0],
        }
      )

    expect(drawn_lines).to eq(<<~GRID.chomp)
      ....@..
      ....@..
      ..@@@..
      .......
      .......
      .......
      ...#...
      ..###..
      ...#...
      ..####.
    GRID
  end

  it "can get assigned the 2 grid" do
    chamber.rocks_count = 2
    chamber.ticks = 8
    chamber.grid = {
      3 => [0, 0, 0, 1, 0, 0, 0],
      2 => [0, 0, 1, 1, 1, 0, 0],
      1 => [0, 0, 0, 1, 0, 0, 0],
      0 => [0, 0, 1, 1, 1, 1, 0],
    }
    chamber.max_placed_y = 3
    chamber.run_until(3)

    expect(chamber.max_placed_y).to eq(3)
    expect(chamber.next_rock_y).to eq(7)
    expect(chamber.gas_direction).to eq(">")
    expect(chamber.rock.shape).to eq([[0, 0, 1], [0, 0, 1], [1, 1, 1]])
    expect(chamber.rock.x).to eq(2)
    expect(chamber.rock.y).to eq(7)
    expect(drawn_lines).to eq(<<~GRID.chomp)
      ....@..
      ....@..
      ..@@@..
      .......
      .......
      .......
      ...#...
      ..###..
      ...#...
      ..####.
    GRID
  end

  it "can get assigned the 2 grid and run to 4" do
    chamber.rocks_count = 2
    chamber.ticks = 8
    chamber.grid = {
      3 => [0, 0, 0, 1, 0, 0, 0],
      2 => [0, 0, 1, 1, 1, 0, 0],
      1 => [0, 0, 0, 1, 0, 0, 0],
      0 => [0, 0, 1, 1, 1, 1, 0],
    }
    chamber.max_placed_y = 3
    chamber.run_until(4)
    expect(drawn_lines).to eq(<<~GRID.chomp)
      ..@....
      ..@....
      ..@....
      ..@....
      .......
      .......
      .......
      ..#....
      ..#....
      ####...
      ..###..
      ...#...
      ..####.
    GRID
  end

  it "can run until 4 rocks are shown" do
    chamber.run_until(4)
    expect(chamber.height).to eq(12)
    expect(chamber.max_placed_y).to eq(5)
    expect(chamber.rock.x).to eq(2)
    expect(chamber.rock.y).to eq(9)
    expect(drawn_lines).to eq(<<~GRID.chomp)
      ..@....
      ..@....
      ..@....
      ..@....
      .......
      .......
      .......
      ..#....
      ..#....
      ####...
      ..###..
      ...#...
      ..####.
    GRID
    expect(chamber.grid)
      .to eq(
        {
          5 => [0, 0, 1, 0, 0, 0, 0],
          4 => [0, 0, 1, 0, 0, 0, 0],
          3 => [1, 1, 1, 1, 0, 0, 0],
          2 => [0, 0, 1, 1, 1, 0, 0],
          1 => [0, 0, 0, 1, 0, 0, 0],
          0 => [0, 0, 1, 1, 1, 1, 0],
        }
      )
  end

  it "can run until 5 rocks are shown" do
    chamber.run_until(5)
    expect(chamber.height).to eq(11)
    expect(drawn_lines).to eq(<<~GRID.chomp)
      .......
      ..@@...
      ..@@...
      .......
      .......
      .......
      ....#..
      ..#.#..
      ..#.#..
      #####..
      ..###..
      ...#...
      ..####.
    GRID
    expect(chamber.grid)
      .to eq(
        {
          6 => [0, 0, 0, 0, 1, 0, 0],
          5 => [0, 0, 1, 0, 1, 0, 0],
          4 => [0, 0, 1, 0, 1, 0, 0],
          3 => [1, 1, 1, 1, 1, 0, 0],
          2 => [0, 0, 1, 1, 1, 0, 0],
          1 => [0, 0, 0, 1, 0, 0, 0],
          0 => [0, 0, 1, 1, 1, 1, 0],
        }
      )
  end

  it "can run until 10 rocks are shown" do
    chamber.run_until(11)
    # expect(chamber.height).to eq(21)
    expect(drawn_lines).to eq(<<~GRID.chomp)
      .......
      ..@@@@.
      .......
      .......
      .......
      ....#..
      ....#..
      ....##.
      ##..##.
      ######.
      .###...
      ..#....
      .####..
      ....##.
      ....##.
      ....#..
      ..#.#..
      ..#.#..
      #####..
      ..###..
      ...#...
      ..####.
    GRID
    expect(chamber.grid)
      .to eq(
        {
          16 => [0, 0, 0, 0, 1, 0, 0],
          15 => [0, 0, 0, 0, 1, 0, 0],
          14 => [0, 0, 0, 0, 1, 1, 0],
          13 => [1, 1, 0, 0, 1, 1, 0],
          12 => [1, 1, 1, 1, 1, 1, 0],
          11 => [0, 1, 1, 1, 0, 0, 0],
          10 => [0, 0, 1, 0, 0, 0, 0],
          9 => [0, 1, 1, 1, 1, 0, 0],
          8 => [0, 0, 0, 0, 1, 1, 0],
          7 => [0, 0, 0, 0, 1, 1, 0],
          6 => [0, 0, 0, 0, 1, 0, 0],
          5 => [0, 0, 1, 0, 1, 0, 0],
          4 => [0, 0, 1, 0, 1, 0, 0],
          3 => [1, 1, 1, 1, 1, 0, 0],
          2 => [0, 0, 1, 1, 1, 0, 0],
          1 => [0, 0, 0, 1, 0, 0, 0],
          0 => [0, 0, 1, 1, 1, 1, 0],
        }
      )
  end

  it "finds the pattern on 2022 rocks" do
    chamber.run_until(2022)
    expect(chamber.pattern_size).to eq(35)
    expect(chamber.pattern.join)
      .to eq("13340123011322002340121201212013200")
  end

  it "finds the pattern on 1_000_000_000_000 rocks" do
    chamber.run_until(1_000_000_000_000)
    expect(chamber.pattern_size).to eq(35)
    expect(chamber.pattern.join)
      .to eq("13340123011322002340121201212013200")
  end

  it "calculates the height for 2022 rocks" do
    expect(chamber.run_until(2022)).to eq(3068)
  end

  it "calculates the height for 1_000_000_000_000" do
    expect(chamber.run_until(1_000_000_000_000)).to eq(1_514_285_714_288)
  end
end
