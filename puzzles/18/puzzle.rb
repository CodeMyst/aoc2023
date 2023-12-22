# frozen_string_literal: true

# --- Day 18: Lavaduct Lagoon ---
class Puzzle18
  def expected_output
    {
      example: [62, 952_408_144_115],
      full: [74_074, 112_074_045_986_829]
    }
  end

  Point = Struct.new(:x, :y) do
    def shoelace(other) = x * other.y - y * other.x

    def +(other) = Point.new(x + other.x, y + other.y)

    def *(other) = Point.new(x * other, y * other)
  end

  DIRS = {
    R: Point.new(1, 0),
    D: Point.new(0, 1),
    L: Point.new(-1, 0),
    U: Point.new(0, -1)
  }.freeze

  def solve_part1(input)
    get_area input, use_colors: false
  end

  def solve_part2(input)
    get_area input, use_colors: true
  end

  private

  def get_area(input, use_colors:)
    points = [Point.new(0, 0)]
    edge_length = 0

    input.split("\n").each do |line|
      match = line.match(/^(?<dir>[A-Z])\s(?<amount>\d+)\s\(#(?<color>\w{6})\)$/)

      if use_colors
        color = match[:color]
        amount = color[...5].to_i 16
        dir = case color[-1].to_i
              when 0 then DIRS[:R]
              when 1 then DIRS[:D]
              when 2 then DIRS[:L]
              when 3 then DIRS[:U]
              end
      else
        dir = DIRS[match[:dir].to_sym]
        amount = match[:amount].to_i
      end

      edge_length += amount

      points << points.last + (dir * amount)
    end

    points.each_cons(2).sum { |p1, p2| p1.shoelace p2 }.abs / 2 + edge_length / 2 + 1
  end
end
