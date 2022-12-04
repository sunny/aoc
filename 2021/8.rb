input = "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"

# input = File.read("8.txt")

# rubocop:disable Layout/SpaceAfterComma
# rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
# rubocop:disable Layout/ExtraSpacing
DIGIT_BY_PLACEMENTS = {
  [0,1,2,  4,5,6] => 0,
  [    2,    5  ] => 1,
  [0,  2,3,4,  6] => 2,
  [0,  2,3,  5,6] => 3,
  [  1,2,3,  5  ] => 4,
  [0,1,  3,  5,6] => 5,
  [0,1,  3,4,5,6] => 6,
  [0,  2,    5  ] => 7,
  [0,1,2,3,4,5,6] => 8,
  [0,1,2,3,  5,6] => 9,
}.freeze
# rubocop:enable Layout/SpaceAfterComma
# rubocop:enable Layout/SpaceInsideArrayLiteralBrackets
# rubocop:enable Layout/ExtraSpacing

NUMBER_BY_SIZE = {
  2 => 1,
  3 => 7,
  4 => 4,
}.freeze

class Display
  attr_reader :digits, :outputs

  def initialize(line)
    digits, outputs = line.split(" | ")
    @digits = split_digits(digits)
    @outputs = split_digits(outputs)
  end

  def number
    outputs.map { |digit| number_by_digit[digit] }.join.to_i
  end

  def split_digits(digits)
    digits.split.map { _1.chars.sort.join }
  end

  def digit_chars_by_size
    @digit_chars_by_size ||=
      digits.to_h { |digit| [NUMBER_BY_SIZE[digit.size], digit.chars] }
  end

  def segments_by_count
    @segments_by_count ||=
      digits.join.chars.tally.to_a.group_by(&:last).transform_values do |v|
        v.map(&:first)
      end
  end

  def segment_code_to_placement
    @segment_code_to_placement ||= begin
      seg = {}

      # - top is in 3 (appears 7 times) and not 4 (appears 4 times)
      # - top-left appears 6 times
      # - top-right appears 8 times
      # - middle is in 4 (appears 4 times) and not 1 (appears 2 times)
      # - bottom-left appears 4 times
      # - bottom-right appears 9 times
      # - bottom is the last one

      seg[0] = digit_chars_by_size[7] - digit_chars_by_size[4]
      seg[1] = segments_by_count[6]
      seg[2] = segments_by_count[8] - seg[0]
      seg[3] = digit_chars_by_size[4] - digit_chars_by_size[1] - seg[1]
      seg[4] = segments_by_count[4]
      seg[5] = segments_by_count[9]
      seg[6] = segments_by_count[7] - seg[3]

      seg.to_h { |k, v| [v.first, k] }
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def number_by_digit
    @number_by_digit ||= digits.to_h do |digit|
      placements = digit.chars.map { |c| segment_code_to_placement[c] }
      [digit, DIGIT_BY_PLACEMENTS[placements.sort]]
    end
  end
end

p input.lines.sum { |line| Display.new(line).number }
