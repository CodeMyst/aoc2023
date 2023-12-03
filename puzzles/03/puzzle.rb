# frozen_string_literal: true

# --- Day 3: Gear Ratios ---
#
# Part 1
#
# The engine schematic (your puzzle input) consists of
# a visual representation of the engine. There are lots
# of numbers and symbols you don't really understand,
# but apparently any number adjacent to a symbol,
# even diagonally, is a "part number" and should be
# included in your sum.
# (Periods (.) do not count as a symbol.)
#
# What is the sum of all of the part numbers in the engine schematic?
#
# Part 2
#
# The missing part wasn't the only issue - one of the gears
# in the engine is wrong. A gear is any * symbol that is
# adjacent to exactly two part numbers. Its gear ratio is
# the result of multiplying those two numbers together.
#
# What is the sum of all of the gear ratios in your engine schematic?
class Puzzle03
  def expected_output
    {
      example: [4361, 467_835],
      full: [537_832, 81_939_900]
    }
  end

  def solve_part1(input)
    sum = 0
    current_num = 0
    has_adjecent_symbol = false

    lines = input.split("\n")

    lines.each_with_index do |line, line_index|
      line.split('').each_with_index do |char, index|
        if numeric? char
          current_num = current_num * 10 + char.to_i

          has_adjecent_symbol = true if adjecent_symbol_coords(lines, index, line_index) { |c| symbol? c }
        else
          sum += current_num if has_adjecent_symbol

          current_num = 0
          has_adjecent_symbol = false
        end
      end
    end

    sum
  end

  def solve_part2(input)
    current_num = 0

    gears = {}

    gear_coords = []

    lines = input.split("\n")

    lines.each_with_index do |line, line_index|
      line.split('').each_with_index do |char, index|
        if numeric? char
          current_num = current_num * 10 + char.to_i

          x, y = adjecent_symbol_coords(lines, index, line_index) { |c| c == '*' }

          gear_coords << { x:, y: } if x && y
        else
          if current_num.positive? && !gear_coords.empty?
            gear_coords.uniq!

            gear_coords.each do |coord|
              gears[coord] = if gears.key? coord
                               { pair?: true, ratio: gears[coord][:ratio] * current_num }
                             else
                               { pair?: false, ratio: current_num }
                             end
            end
          end

          gear_coords = []
          current_num = 0
        end
      end
    end

    gears.values.select { |v| v[:pair?] }.sum { |v| v[:ratio] }
  end

  private

  def adjecent_symbol_coords(lines, x, y)
    (-1..1).each do |dx|
      (-1..1).each do |dy|
        next if dx.zero? && dy.zero?

        xi = x + dx
        yi = y + dy

        next if xi.negative? || xi > lines[y].length - 1 || yi.negative? || yi > lines.length - 1

        return [xi, yi] if yield lines[yi][xi]
      end
    end

    false
  end

  def symbol?(char)
    return false if numeric?(char) || char == '.'

    true
  end

  def numeric?(char)
    char =~ /\d/
  end
end
