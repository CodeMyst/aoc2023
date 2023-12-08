# frozen_string_literal: true

require 'parallel'

# --- Day 8: Haunted Wasteland ---
class Puzzle08
  def expected_output
    {
      example: [6, 6],
      full: [19_631, 21_003_205_388_413]
    }
  end

  def solve_part1(input)
    lines = input.split("\n")

    directions = lines.first

    nodes = {}

    lines[2..].each do |line|
      if /(?<node>\w+) = \((?<left>\w+), (?<right>\w+)\)/ =~ line
        nodes[node] = [left, right]
      end
    end

    current_node = nodes['AAA']
    current_direction_idx = 0
    steps = 0

    while current_node != nodes['ZZZ']
      current_direction = directions[current_direction_idx]
      current_node = nodes[current_node[0]] if current_direction == 'L'
      current_node = nodes[current_node[1]] if current_direction == 'R'

      current_direction_idx = (current_direction_idx + 1) % directions.length

      steps += 1
    end

    steps
  end

  def solve_part2(input)
    lines = input.split("\n")

    directions = lines.first

    nodes = {}

    lines[2..].each do |line|
      if /(?<node>.+) = \((?<left>.+), (?<right>.+)\)/ =~ line
        nodes[node] = [left, right]
      end
    end

    starting_nodes = nodes.select { |n| n[2] == 'A' }.keys

    loop_intervals = Parallel.map(starting_nodes) do |current_node|
      current_direction_idx = 0
      steps = 0

      while current_node[2] != 'Z'
        current_direction = directions[current_direction_idx]
        current_node = nodes[current_node][0] if current_direction == 'L'
        current_node = nodes[current_node][1] if current_direction == 'R'

        current_direction_idx = (current_direction_idx + 1) % directions.length

        steps += 1
      end

      steps
    end

    loop_intervals.reduce(1, :lcm)
  end
end
