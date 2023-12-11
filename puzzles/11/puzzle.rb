# frozen_string_literal: true

# --- Day 11: Cosmic Expansion ---
class Puzzle11
  def expected_output
    {
      example: [374, 82_000_210],
      full: [10_885_634, 707_505_470_642]
    }
  end

  def solve_part1(input)
    get_sum_of_shortest_distances(input, 2)
  end

  def solve_part2(input)
    get_sum_of_shortest_distances(input, 1_000_000)
  end

  private

  def get_sum_of_shortest_distances(input, expansion)
    lines = input.split("\n").map { |l| l.split('') }

    empty_cols = empty_columns(lines)

    galaxies = []
    empty_y = 0
    lines.each_with_index do |line, y|
      if line.all?('.')
        empty_y += expansion - 1
        next
      end

      line.each_with_index do |node, x|
        empty_x = (expansion - 1) * empty_cols.select { |c| c < x }.length
        galaxies << { x: x + empty_x, y: y + empty_y } if node == '#'
      end
    end

    shortest_distances = 0

    galaxies.combination(2).each do |pair|
      dist = (pair[0][:x] - pair[1][:x]).abs + (pair[0][:y] - pair[1][:y]).abs

      shortest_distances += dist
    end

    shortest_distances
  end

  def empty_columns(lines)
    empty = []

    lines.transpose.each_with_index do |line, index|
      empty << index if line.all?('.')
    end

    empty
  end
end
