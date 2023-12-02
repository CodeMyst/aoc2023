# frozen_string_literal: true

# --- Day 1: Trebuchet?! ---
#
# Part 1
#
# On each line, the calibration value can be found by combining
# the first digit and the last digit (in that order) to form a
# single two-digit number.
#
# Part 2
#
# It looks like some of the digits are actually spelled out with
# letters: one, two, three, four, five, six, seven, eight, and nine
# also count as valid "digits".
class Puzzle01
  def expected_output
    {
      example: [142, 281],
      full: [53_974, 52_840]
    }
  end

  def solve_part1(input)
    input.split("\n")
         .map { |l| l.split('') }
         .map { |l| l.select { |c| numeric? c } }
         .map { |l| l.first + l.last }
         .map(&:to_i)
         .sum
  end

  def solve_part2(input)
    input.split("\n")
         .map { |l| get_first_and_last_digit l }
         .sum
  end

  private

  WORD_DIGITS = %w[one two three four five six seven eight nine].freeze
  DIGITS = WORD_DIGITS + (1..9).map(&:to_s)

  def get_first_and_last_digit(line)
    digit_indices = DIGITS.each_with_index.map do |digit, index|
      {
        first: line.index(digit),
        last: line.rindex(digit),
        digit: (index % 9 + 1).to_s
      }
    end

    first_digit = digit_indices.reject { |i| i[:first].nil? }
                               .min { |a, b| a[:first] <=> b[:first] }

    last_digit = digit_indices.reject { |i| i[:last].nil? }
                              .max { |a, b| a[:last] <=> b[:last] }

    (first_digit[:digit] + last_digit[:digit]).to_i
  end

  def numeric?(char)
    true if Integer(char)
  rescue ArgumentError
    false
  end
end
