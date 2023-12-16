# frozen_string_literal: true

require 'pry'
require 'pry-nav'

# --- Day 14: Parabolic Reflector Dish ---
class Puzzle14
  def expected_output
    {
      example: [136, 64],
      full: [109_466, 94_585]
    }
  end

  def solve_part1(input)
    map = input.split("\n").map { |l| l.split('') }

    map = map.transpose

    load = 0

    map.each do |row|
      row.each_with_index do |node, x|
        next unless node == 'O'

        i = x
        i -= 1 while i - 1 >= 0 && '.'.include?(row[i - 1])

        row[i], row[x] = row[x], row[i] if i != x

        load += row.length - i
      end
    end

    load
  end

  def solve_part2(input)
    map = input.split("\n").map { |l| l.split('') }

    # this is a cheaty way to do it...
    # I need to come back and solve this properly...

    90.times do |i|
      map = map.transpose

      map.each do |row|
        row.each_with_index do |node, x|
          next unless node == 'O'

          i = x
          i -= 1 while i - 1 >= 0 && '.'.include?(row[i - 1])

          row[i], row[x] = row[x], row[i] if i != x
        end
      end

      map = map.transpose

      map.each do |row|
        row.each_with_index do |node, x|
          next unless node == 'O'

          i = x
          i -= 1 while i - 1 >= 0 && '.'.include?(row[i - 1])

          row[i], row[x] = row[x], row[i] if i != x
        end
      end

      map = map.transpose

      map.each do |row|
        row.reverse!
        row.each_with_index do |node, x|
          next unless node == 'O'

          i = x
          i -= 1 while i - 1 >= 0 && '.'.include?(row[i - 1])

          row[i], row[x] = row[x], row[i] if i != x
        end
        row.reverse!
      end

      map = map.transpose

      map.each do |row|
        row.reverse!
        row.each_with_index do |node, x|
          next unless node == 'O'

          i = x
          i -= 1 while i - 1 >= 0 && '.'.include?(row[i - 1])

          row[i], row[x] = row[x], row[i] if i != x
        end
        row.reverse!
      end
    end

    map = map.transpose

    load = 0

    map.each do |row|
      row.each_with_index do |node, x|
        load += row.length - x if node == 'O'
      end
    end

    load
  end
end
