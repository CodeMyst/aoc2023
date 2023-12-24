# frozen_string_literal: true

# --- Day 19: Aplenty ---
class Puzzle19
  def expected_output
    {
      example: [19_114, 167_409_079_868_000],
      full: [330_820, -1]
    }
  end

  Rating = Struct.new(:x, :m, :a, :s) do
    def rating
      x + m + a + s
    end
  end

  Workflow = Struct.new(:condition, :output)

  def solve_part1(input)
    workflows_input, ratings_input = input.split("\n\n")

    workflows = {}
    ratings = []

    workflows_input.split("\n").each do |workflow|
      match = workflow.match(/(?<name>\w+){(?<conditions>.*)}/)

      name = match[:name]

      workflows[name] = []

      match[:conditions].split(',').each do |condition|
        cond, output = condition.split ':'

        if output.nil?
          output = cond
          cond = nil
        end

        workflows[name] << Workflow.new(cond, output)
      end
    end

    ratings_input.split("\n").each do |rating|
      match = rating.match(/{x=(?<x>\d+),m=(?<m>\d+),a=(?<a>\d+),s=(?<s>\d+)}/)

      ratings << Rating.new(match[:x].to_i, match[:m].to_i, match[:a].to_i, match[:s].to_i)
    end

    ratings.select { |r| run_workflow workflows, 'in', r }
           .map(&:rating)
           .sum
  end

  def solve_part2(input)
  end

  private

  def run_workflow(workflows, start_workflow, rating)
    return true if start_workflow == 'A'
    return false if start_workflow == 'R'

    workflows[start_workflow].each do |workflow|
      return run_workflow workflows, workflow.output, rating if workflow.condition.nil?

      next unless rating.instance_eval workflow.condition

      return run_workflow workflows, workflow.output, rating
    end
  end
end
