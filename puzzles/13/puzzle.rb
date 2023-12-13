# frozen_string_literal: true

class Array
  def differences(other)
    each_with_index.count { |el, index| el != other[index] }
  end
end

# --- Day 13: Point of Incidence ---
class Puzzle13
  def expected_output
    {
      example: [405, 400],
      full: [30_487, 31_954]
    }
  end

  def solve_part1(input)
    sum_reflection_lines input, allowed_differences: 0
  end

  def solve_part2(input)
    sum_reflection_lines input, allowed_differences: 1
  end

  private

  def sum_reflection_lines(input, allowed_differences:)
    patterns = input.split("\n\n").map { |pattern| pattern.split("\n").map { |l| l.split('') } }

    sum = 0

    patterns.each do |pattern|
      found = false
      (pattern.length - 1).times do |i|
        if !found && symmetric?(pattern, i, allowed_differences)
          sum += (i + 1) * 100
          found = true
        end
      end

      found = false
      pattern = pattern.transpose
      (pattern.length - 1).times do |i|
        if !found && symmetric?(pattern, i, allowed_differences)
          sum += i + 1
          found = true
        end
      end
    end

    sum
  end

  def symmetric?(pattern, point_of_symmetry, allowed_differences = 0)
    j = 0
    smudges = 0
    while point_of_symmetry - j >= 0 && point_of_symmetry + 1 + j < pattern.length && smudges <= allowed_differences
      smudges += pattern[point_of_symmetry - j].differences(pattern[point_of_symmetry + 1 + j])

      j += 1
    end

    true if smudges == allowed_differences
  end
end
