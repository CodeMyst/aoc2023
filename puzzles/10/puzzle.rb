# frozen_string_literal: true

# --- Day 10: Pipe Maze ---
class Puzzle10
  def expected_output
    {
      example: [80, 8],
      full: [6_870, 287]
    }
  end

  Node = Struct.new(:x, :y, :pipe, :visited, :dist)

  def solve_part1(input)
    lines = input.split("\n")

    map = lines.each_with_index.map do |line, y|
      line.split('').each_with_index.map do |node, x|
        Node.new(x, y, node, false, 0)
      end
    end

    starting_node = find_start_coords map
    starting_nodes = get_neighouring_nodes(map, starting_node)

    node = starting_nodes[0]

    dist = 1

    until node.nil?
      node.visited = true
      node.dist = dist

      dist += 1

      node = get_neighouring_nodes(map, node).reject(&:visited).first
    end

    dist / 2
  end

  def solve_part2(input)
    lines = input.split("\n")

    map = lines.each_with_index.map do |line, y|
      line.split('').each_with_index.map do |node, x|
        Node.new(x, y, node, false, 0)
      end
    end

    starting_node = find_start_coords map
    starting_node.visited = true
    node = get_neighouring_nodes(map, starting_node).first

    until node.nil?
      node.visited = true

      node = get_neighouring_nodes(map, node).reject(&:visited).first
    end

    # hardcoding the S pipe here
    # insert funny comment here
    starting_nodes = get_neighouring_nodes(map, starting_node)
    starting_node.pipe = starting_nodes.map(&:pipe) == %w[| |] ? '|' : 'F'

    area = 0

    map.each do |line|
      walls = 0
      prev_pipe = ''

      line.each do |node|
        if node.visited && node.pipe == '|'
          walls += 1
        elsif node.visited && node.pipe == 'L'
          prev_pipe = 'L'
        elsif node.visited && node.pipe == '7' && prev_pipe == 'L'
          walls += 1
        elsif node.visited && node.pipe == 'F'
          prev_pipe = 'F'
        elsif node.visited && node.pipe == 'J' && prev_pipe == 'F'
          walls += 1
        elsif !node.visited && walls.odd?
          area += 1
        end
      end
    end

    area
  end

  private

  def get_neighouring_nodes(map, current_node)
    neighbouring_nodes = []

    # top

    x = current_node.x
    y = current_node.y - 1

    unless x.negative? || x >= map[0].length || y.negative? || y > map.length
      neighbouring_nodes << map[y][x] if ['|', 'L', 'J', 'S'].include?(current_node.pipe) && ['|', '7', 'F'].include?(map[y][x].pipe)
    end

    # right

    x = current_node.x + 1
    y = current_node.y

    unless x.negative? || x >= map[0].length || y.negative? || y > map.length
      neighbouring_nodes << map[y][x] if ['-', 'L', 'F', 'S'].include?(current_node.pipe) && ['-', 'J', '7'].include?(map[y][x].pipe)
    end

    # down

    x = current_node.x
    y = current_node.y + 1

    unless x.negative? || x >= map[0].length || y.negative? || y > map.length
      neighbouring_nodes << map[y][x] if ['|', '7', 'F', 'S'].include?(current_node.pipe) && ['|', 'L', 'J'].include?(map[y][x].pipe)
    end

    # left

    x = current_node.x - 1
    y = current_node.y

    unless x.negative? || x >= map[0].length || y.negative? || y > map.length
      neighbouring_nodes << map[y][x] if ['-', 'J', '7', 'S'].include?(current_node.pipe) && ['-', 'L', 'F'].include?(map[y][x].pipe)
    end

    neighbouring_nodes
  end

  def find_start_coords(map)
    map.each do |y|
      y.each do |node|
        return node if node.pipe == 'S'
      end
    end
  end
end
