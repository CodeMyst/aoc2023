# frozen_string_literal: true

# This is a test puzzle to test out the puzzle runner.
class Puzzle00
  def expected_output
    {
      example: [100, 200],
      full: [200, 400]
    }
  end

  def solve_part1(input)
    input.to_i
  end

  def solve_part2(input)
    input.to_i * 2
  end
end
