# frozen_string_literal: true

# --- Day 9: Mirage Maintenance ---
class Puzzle09
  def expected_output
    {
      example: [114, 2],
      full: [2_105_961_943, 1019]
    }
  end

  def solve_part1(input)
    lines = input.split("\n")

    predictions = []

    lines.each do |line|
      history = line.split(' ').map(&:to_i)
      values = [history]

      values << get_step_values(values.last) until values.last.all? 0

      values.reverse!
      values[0] << 0

      values.length.times do |index|
        next if index.zero?

        values[index] << values[index].last + values[index - 1].last
      end

      predictions << values.last.last
    end

    predictions.sum
  end

  def solve_part2(input)
    lines = input.split("\n")

    predictions = []

    lines.each do |line|
      history = line.split(' ').map(&:to_i)
      values = [history]

      values << get_step_values(values.last) until values.last.all? 0

      values.reverse!
      values[0].unshift 0

      values.length.times do |index|
        next if index.zero?

        values[index].unshift(values[index].first - values[index - 1].first)
      end

      predictions << values.last.first
    end

    predictions.sum
  end

  private

  def get_step_values(history)
    history.each_cons(2).map { |a, b| b - a }
  end
end
