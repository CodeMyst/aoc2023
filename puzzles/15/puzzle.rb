# frozen_string_literal: true

# --- Day 15: Lens Library ---
class Puzzle15
  def expected_output
    {
      example: [1320, 145],
      full: [511_215, 236_057]
    }
  end

  class HashMap
    def initialize
      @arr = Array.new(256) { [] }
    end

    def insert(label, lens)
      h = hash label

      index = @arr[h].find_index { |l| l[:label] == label }

      if index
        @arr[h][index][:lens] = lens
      else
        @arr[h] << { label:, lens: }
      end
    end

    def remove(label)
      h = hash label

      index = @arr[h].find_index { |l| l[:label] == label }

      @arr[h].delete_at(index) if index
    end

    def focusing_power
      @arr.each_with_index.map do |box, i|
        box.each_with_index.map do |lens, j|
          (i + 1) * (j + 1) * lens[:lens]
        end.sum
      end.sum
    end
  end

  def solve_part1(input)
    input.split(',').map(&:chomp).map { |i| hash i }.sum
  end

  def solve_part2(input)
    boxes = HashMap.new

    input.split(',').map(&:chomp).each do |step|
      if step.include? '-'
        label = step[0...-1]
        boxes.remove(label)
      elsif step.include? '='
        label = step[0...-2]
        lens = step[-1].to_i
        boxes.insert(label, lens)
      end
    end

    boxes.focusing_power
  end
end

def hash(input)
  res = 0

  input.split('').each do |c|
    res += c.ord
    res *= 17
    res %= 256
  end

  res
end
