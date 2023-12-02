# frozen_string_literal: true

# --- Day 2: Cube Conundrum ---
#
# Part 1
#
# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
#
# In game 1, three sets of cubes are revealed from the bag (and then put back again).
# The first set is 3 blue cubes and 4 red cubes; the second set is 1 red cube, 2 green cubes,
# and 6 blue cubes; the third set is only 2 green cubes.
#
# The Elf would first like to know which games would have been possible if the bag
# contained only 12 red cubes, 13 green cubes, and 14 blue cubes?
#
# Determine which games would have been possible if the bag had been loaded with
# only 12 red cubes, 13 green cubes, and 14 blue cubes. What is the sum
# of the IDs of those games?
#
# Part 2
#
# For each game, find the minimum set of cubes that must have been present.
# What is the sum of the power of these sets?
class Puzzle02
  def expected_output
    {
      example: [8, 2_286],
      full: [2176, 63_700]
    }
  end

  MAXIMUMS = {
    red: 12,
    green: 13,
    blue: 14
  }.freeze

  def solve_part1(input)
    input.split("\n")
         .sum do |line|
           line.match(/Game\s(?<game>\d+):/) do |m|
             if game_possible?(line)
               m[:game].to_i
             else
               0
             end
           end
         end
  end

  def game_possible?(game)
    game.scan(/((\s\d+\s\w+,?)+);?/).map { |set| set_possible? set }.all?
  end

  def set_possible?(set)
    set.first
       .strip
       .scan(/(\d+)\s(\w+)/)
       .map { |c| { amount: c[0].to_i, color: c[1] } }
       .group_by { |c| c[:color] }
       .map { |c, s| { color: c, sum: s.sum { |e| e[:amount] } } }
       .select { |c| c[:sum] > MAXIMUMS[c[:color].to_sym] }
       .empty?
  end

  def solve_part2(input)
    lines = input.split("\n")

    sum = 0

    lines.each do |line|
      line.match(/Game\s(?<game>\d+):/) do
        max_red = -1
        max_green = -1
        max_blue = -1

        line.scan(/((\s\d+\s\w+,?)+);?/) do |set|
          cubes = set.first
                     .strip
                     .scan(/(\d+)\s(\w+)/)
                     .map { |c| { amount: c[0].to_i, color: c[1] } }
                     .group_by { |c| c[:color] }
                     .map { |c, s| { color: c, sum: s.sum { |e| e[:amount] } } }

          reds = cubes.select { |c| c[:color] == 'red' }.map { |c| c[:sum] }.first
          greens = cubes.select { |c| c[:color] == 'green' }.map { |c| c[:sum] }.first
          blues = cubes.select { |c| c[:color] == 'blue' }.map { |c| c[:sum] }.first

          max_red = reds if reds && reds > max_red
          max_green = greens if greens && greens > max_green
          max_blue = blues if blues && blues > max_blue
        end

        sum += max_red * max_green * max_blue
      end
    end

    sum
  end
end
