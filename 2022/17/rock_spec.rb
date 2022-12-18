require "rspec"

require "./rock"

describe "Rock" do
  it "can be created from a horizontal line shape" do
    rock = Rock.from_shape([[1, 1, 1, 1]])
    expect(rock.width).to eq(4)
    expect(rock.height).to eq(1)
    expect(rock.min_x).to eq(0)
    expect(rock.max_x).to eq(3)
    expect(rock.min_y).to eq(0)
    expect(rock.max_y).to eq(0)
    expect(rock.coords).to eq([[0, 0], [1, 0], [2, 0], [3, 0]])
  end

  it "can be created from a diamond shape" do
    rock = Rock.from_shape([[0, 1, 0], [1, 1, 1], [0, 1, 0]])
    expect(rock.width).to eq(3)
    expect(rock.height).to eq(3)
    expect(rock.min_x).to eq(0)
    expect(rock.max_x).to eq(2)
    expect(rock.min_y).to eq(0)
    expect(rock.max_y).to eq(2)
    expect(rock.coords).to eq([[1, 2], [0, 1], [1, 1], [2, 1], [1, 0]])
  end

  it "can be created from a angle shape" do
    rock = Rock.from_shape([[0, 0, 1], [0, 0, 1], [1, 1, 1]])
    expect(rock.width).to eq(3)
    expect(rock.height).to eq(3)
    expect(rock.min_x).to eq(0)
    expect(rock.max_x).to eq(2)
    expect(rock.min_y).to eq(0)
    expect(rock.max_y).to eq(2)
    expect(rock.coords).to eq([[2, 2], [2, 1], [0, 0], [1, 0], [2, 0]])
  end

  it "can be created from a vertical line shape" do
    rock = Rock.from_shape([[1], [1], [1], [1]])
    expect(rock.width).to eq(1)
    expect(rock.height).to eq(4)
    expect(rock.min_x).to eq(0)
    expect(rock.max_x).to eq(0)
    expect(rock.min_y).to eq(0)
    expect(rock.max_y).to eq(3)
    expect(rock.coords).to eq([[0, 3], [0, 2], [0, 1], [0, 0]])
  end

  it "can be created from a square shape" do
    rock = Rock.from_shape([[1, 1], [1, 1]])
    expect(rock.width).to eq(2)
    expect(rock.height).to eq(2)
    expect(rock.min_x).to eq(0)
    expect(rock.max_x).to eq(1)
    expect(rock.min_y).to eq(0)
    expect(rock.max_y).to eq(1)
    expect(rock.coords).to eq([[0, 1], [1, 1], [0, 0], [1, 0]])
  end
end
