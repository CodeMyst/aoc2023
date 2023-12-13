# frozen_string_literal: true

require 'parallel'

# --- Day 12: Hot Springs ---
class Puzzle12
  def expected_output
    {
      example: [21, 525_152],
      full: [7191, 6_512_849_198_636]
    }
  end

  def solve_part1(input)
    @cache = {}
    Parallel.map(input.split("\n").map { |line| line.split(' ') }) do |s|
      record, groups = s
      get_arrangements(record, groups.split(',').map(&:to_i))
    end.sum
  end

  def solve_part2(input)
    @cache = {}
    Parallel.map(input.split("\n").map { |line| line.split(' ') }) do |s|
      record, groups = s
      get_arrangements(([record] * 5).join('?'), groups.split(',').map(&:to_i) * 5)
    end.sum
  end

  private

  def get_arrangements(record, groups)
    return @cache[[record, groups]] if @cache.key? [record, groups]

    if groups.empty?
      return 1 unless record.include?('#')

      return 0
    end

    return 0 if record.empty?

    next_character = record[0]
    next_group = groups[0]

    res = 0

    case next_character
    when '#'
      res = handle_damaged record, groups, next_group
    when '.'
      res = handle_operational record, groups
    when '?'
      res = handle_operational(record, groups) + handle_damaged(record, groups, next_group)
    end

    @cache[[record, groups]] = res
  end

  def handle_damaged(record, groups, next_group)
    group = record[...next_group].gsub('?', '#')

    return 0 if group != '#' * next_group

    if record.length == next_group
      return 1 if groups.length == 1

      return 0
    end

    return get_arrangements(record[next_group + 1...], groups[1...]) if '?.'.include?(record[next_group])

    0
  end

  def handle_operational(record, groups)
    get_arrangements record[1...], groups
  end
end
