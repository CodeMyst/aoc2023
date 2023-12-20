# frozen_string_literal: true

require 'rb_heap'

class Array
  def <(other)
    each_with_index do |el, i|
      next if el == other[i]

      return el < other[i]
    end

    false
  end
end

# --- Day 17: Clumsy Crucible ---
class Puzzle17
  def expected_output
    {
      example: [102, 94],
      full: [724, 877]
    }
  end

  def solve_part1(input)
    get_min_heat_loss input, 0, 3
  end

  def solve_part2(input)
    get_min_heat_loss input, 3, 10
  end

  private

  LEFT = [-1, 0].freeze
  RIGHT = [1, 0].freeze
  UP = [0, -1].freeze
  DOWN = [0, 1].freeze

  # pure pain...
  def get_min_heat_loss(input, min_straight, max_straight)
    map = input.split("\n").map { |l| l.split('').map(&:to_i) }

    dist = Hash.new { |hash, key| hash[key] = {} }
    dist[[0, 0]][LEFT] = 0
    dist[[0, 0]][RIGHT] = 0
    dist[[0, 0]][UP] = 0
    dist[[0, 0]][DOWN] = 0

    frontier = Heap.new
    frontier.add([0, [0, 0], RIGHT])
    frontier.add([0, [0, 0], DOWN])

    until frontier.empty?
      heat_loss, pos, dir = frontier.pop

      next if heat_loss > dist[pos][dir]

      x, y = pos
      dir_x, dir_y = dir

      max_straight.times do |step|
        x += dir_x
        y += dir_y

        break if x.negative? || x >= map.first.length || y.negative? || y >= map.length

        heat_loss += map[y][x]

        next if step < min_straight

        get_possible_turns(dir).each do |new_dir|
          next if dist.dig([x, y], new_dir) && heat_loss >= dist[[x, y]][new_dir]

          dist[[x, y]][new_dir] = heat_loss
          frontier.add([heat_loss, [x, y], new_dir])
        end
      end
    end

    dist[[map.first.length - 1, map.length - 1]].values.min
  end

  def get_possible_turns(dir)
    case dir
    when RIGHT
      [UP, DOWN]
    when LEFT
      [UP, DOWN]
    when UP
      [RIGHT, LEFT]
    when DOWN
      [RIGHT, LEFT]
    end
  end
end
