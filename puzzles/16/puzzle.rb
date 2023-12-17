# frozen_string_literal: true

# --- Day 16: The Floor Will Be Lava ---
class Puzzle16
  def expected_output
    {
      example: [46, 51],
      full: [7_788, 7_987]
    }
  end

  def solve_part1(input)
    map = input.split("\n").map { |l| l.split('').map { |n| [n, false] } }

    @splits = []

    traverse map, { x: 0, y: 0, dir: { x: 1, y: 0 } }

    get_energized_nodes map
  end

  # this takes around a minute
  # I need to go back and optimize this
  def solve_part2(input)
    map = input.split("\n").map { |l| l.split('').map { |n| [n, false] } }

    @splits = []

    max_energized = -1

    0.upto map.first.length do |x|
      reset_map map
      @splits = []

      traverse map, { x:, y: 0, dir: { x: 0, y: 1 } }

      res = get_energized_nodes map
      max_energized = res if res > max_energized
    end

    0.upto map.first.length do |x|
      reset_map map
      @splits = []

      traverse map, { x:, y: map.length - 1, dir: { x: 0, y: -1 } }

      res = get_energized_nodes map
      max_energized = res if res > max_energized
    end

    0.upto map.length do |y|
      reset_map map
      @splits = []

      traverse map, { x: 0, y:, dir: { x: 1, y: 0 } }

      res = get_energized_nodes map
      max_energized = res if res > max_energized
    end

    0.upto map.length do |y|
      reset_map map
      @splits = []

      traverse map, { x: map.first.length - 1, y:, dir: { x: -1, y: 0 } }

      res = get_energized_nodes map
      max_energized = res if res > max_energized
    end

    max_energized
  end

  private

  def reset_map(map)
    map.each do |line|
      line.each do |node|
        node[1] = false
      end
    end
  end

  def get_energized_nodes(map)
    map.map do |line|
      line.count do |node|
        node[1]
      end
    end.sum
  end

  def traverse(map, start_pos)
    current_pos = { x: start_pos[:x], y: start_pos[:y] }

    return if current_pos[:x].negative? ||
              current_pos[:x] >= map.first.length ||
              current_pos[:y].negative? ||
              current_pos[:y] >= map.length

    current_node, = map[current_pos[:y]][current_pos[:x]]
    map[current_pos[:y]][current_pos[:x]][1] = true

    while current_node == '.'
      current_pos[:x] += start_pos[:dir][:x]
      current_pos[:y] += start_pos[:dir][:y]

      return if current_pos[:x].negative? ||
                current_pos[:x] >= map.first.length ||
                current_pos[:y].negative? ||
                current_pos[:y] >= map.length

      current_node, = map[current_pos[:y]][current_pos[:x]]
      map[current_pos[:y]][current_pos[:x]][1] = true
    end

    return if @splits.include?({ x: current_pos[:x], y: current_pos[:y], dir: start_pos[:dir] })

    @splits << { x: current_pos[:x], y: current_pos[:y], dir: start_pos[:dir] }

    if current_node == '/'
      if start_pos[:dir][:x] == 1
        traverse map, { x: current_pos[:x], y: current_pos[:y] - 1, dir: { x: 0, y: -1 } }
      elsif start_pos[:dir][:x] == -1
        traverse map, { x: current_pos[:x], y: current_pos[:y] + 1, dir: { x: 0, y: 1 } }
      elsif start_pos[:dir][:y] == 1
        traverse map, { x: current_pos[:x] - 1, y: current_pos[:y], dir: { x: -1, y: 0 } }
      elsif start_pos[:dir][:y] == -1
        traverse map, { x: current_pos[:x] + 1, y: current_pos[:y], dir: { x: 1, y: 0 } }
      end
    elsif current_node == '\\'
      if start_pos[:dir][:x] == 1
        traverse map, { x: current_pos[:x], y: current_pos[:y] + 1, dir: { x: 0, y: 1 } }
      elsif start_pos[:dir][:x] == -1
        traverse map, { x: current_pos[:x], y: current_pos[:y] - 1, dir: { x: 0, y: -1 } }
      elsif start_pos[:dir][:y] == 1
        traverse map, { x: current_pos[:x] + 1, y: current_pos[:y], dir: { x: 1, y: 0 } }
      elsif start_pos[:dir][:y] == -1
        traverse map, { x: current_pos[:x] - 1, y: current_pos[:y], dir: { x: -1, y: 0 } }
      end
    elsif current_node == '-'
      if start_pos[:dir][:x] == 1
        traverse map, { x: current_pos[:x] + 1, y: current_pos[:y], dir: { x: 1, y: 0 } }
      elsif start_pos[:dir][:x] == -1
        traverse map, { x: current_pos[:x] - 1, y: current_pos[:y], dir: { x: -1, y: 0 } }
      elsif start_pos[:dir][:y] == 1
        traverse map, { x: current_pos[:x] - 1, y: current_pos[:y], dir: { x: -1, y: 0 } }
        traverse map, { x: current_pos[:x] + 1, y: current_pos[:y], dir: { x: 1, y: 0 } }
      elsif start_pos[:dir][:y] == -1
        traverse map, { x: current_pos[:x] - 1, y: current_pos[:y], dir: { x: -1, y: 0 } }
        traverse map, { x: current_pos[:x] + 1, y: current_pos[:y], dir: { x: 1, y: 0 } }
      end
    elsif current_node == '|'
      if start_pos[:dir][:x] == 1
        traverse map, { x: current_pos[:x], y: current_pos[:y] + 1, dir: { x: 0, y: 1 } }
        traverse map, { x: current_pos[:x], y: current_pos[:y] - 1, dir: { x: 0, y: -1 } }
      elsif start_pos[:dir][:x] == -1
        traverse map, { x: current_pos[:x], y: current_pos[:y] + 1, dir: { x: 0, y: 1 } }
        traverse map, { x: current_pos[:x], y: current_pos[:y] - 1, dir: { x: 0, y: -1 } }
      elsif start_pos[:dir][:y] == 1
        traverse map, { x: current_pos[:x], y: current_pos[:y] + 1, dir: { x: 0, y: 1 } }
      elsif start_pos[:dir][:y] == -1
        traverse map, { x: current_pos[:x], y: current_pos[:y] - 1, dir: { x: 0, y: -1 } }
      end
    end
  end
end
