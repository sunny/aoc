input = "[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]"

# input = File.read("10.txt")

class Line
  attr_reader :input, :stack

  CLOSERS = %w[() [] {} <>].to_h(&:chars).invert

  SCORES = {
    ?) => 3,
    ?] => 57,
    ?} => 1_197,
    ?> => 25_137,
    ?( => 1,
    ?[ => 2,
    ?{ => 3,
    ?< => 4,
  }.freeze

  def initialize(input)
    @input = input.chomp
    @stack = []
  end

  def corrupted_score
    input.each_char do |c|
      next stack << c unless CLOSERS.key?(c)
      return SCORES[c] if stack.pop != CLOSERS[c]
    end

    nil
  end

  def incomplete_score
    return if corrupted_score

    stack.reverse.inject(0) { _1 * 5 + SCORES[_2] }
  end
end

scores = input.lines.filter_map { Line.new(_1).incomplete_score }
p scores.sort[scores.size / 2]
