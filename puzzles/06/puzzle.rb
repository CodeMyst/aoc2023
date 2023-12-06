# frozen_string_literal: true

# --- Day 6: Wait For It ---
class Puzzle06
  def expected_output
    {
      example: [288, 71_503],
      full: [625_968, 43_663_323]
    }
  end

  def solve_part1(input)
    lines = input.split("\n")
    times = lines.first.split(':').last.split(' ').map(&:chomp).map(&:to_i)
    distances = lines.last.split(':').last.split(' ').map(&:chomp).map(&:to_i)

    races = times.zip(distances)
    races.map { |r| get_number_of_wins(r[0], r[1]) }.inject(:*)
  end

  def solve_part2(input)
    lines = input.split("\n")
    time = lines.first.split(':').last.delete(' ').to_i
    distance = lines.last.split(':').last.delete(' ').to_i

    get_number_of_wins time, distance
  end

  private

  def get_number_of_wins(time, distance)
    max_time = ((time + Math.sqrt(time * time - 4 * distance)) / 2.0).floor
    min_time = ((time - Math.sqrt(time * time - 4 * distance)) / 2.0).floor

    max_time - min_time
  end
end
