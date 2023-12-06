# frozen_string_literal: true

require 'optparse'
require 'colorize'

def find_puzzle(day)
  puzzle_number = format('%02d', day)

  require "./puzzles/#{puzzle_number}/puzzle.rb"

  # returns an instance of the puzzle class
  Object.const_get("Puzzle#{puzzle_number}").new
end

def get_puzzle_input(day)
  puzzle_number = format('%02d', day)
  example_path = "./puzzles/#{puzzle_number}/input_example.txt"
  full_path = "./puzzles/#{puzzle_number}/input_full.txt"

  {
    example: File.read(example_path),
    full: File.read(full_path)
  }
end

def all_days
  Dir.children('./puzzles').map { |entry| File.basename(entry).to_i }.sort
end

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.banner = 'Usage: runner.rb [options]'

    opts.on('-e', '--example', 'Use the example inputs') do |e|
      options[:example] = e
    end

    opts.on('-dDAY', '--day DAY', 'Specific day to run') do |d|
      options[:day] = d.to_i
    end

    opts.on('-pPART', '--part PART', 'Specific part to run') do |p|
      options[:part] = p.to_i
    end

    opts.on('-o', '--show-output', 'Show the output of each puzzle') do |o|
      options[:show_output] = o
    end

    opts.on('-t', '--show-elapsed-time', 'Show elapsed time of each puzzle') do |t|
      options[:show_elapsed_time] = t
    end

    opts.on('-h', '--help', 'Prints this help') do
      puts opts
      exit
    end
  end.parse!

  options
end

def check_success(puzzle, puzzle_output, input_type, part)
  puzzle.expected_output[input_type][part - 1] == puzzle_output
end

def solve_part(puzzle, input, part)
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  output = puzzle.send("solve_part#{part}", input)

  end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  elapsed_time = end_time - start_time

  [output, elapsed_time]
end

def solve_part_and_print_output(puzzle, input, input_type, show_output, show_elapsed_time, part:)
  output, elapsed_time = solve_part(puzzle, input, part)
  success = check_success(puzzle, output, input_type, part)

  if success
    puts " • Part #{part} ✓".colorize(:green)
    puts "   Output: #{output}" if show_output
  else
    puts " • Part #{part} ✗".colorize(:red)
    puts "   Expected: #{puzzle.expected_output[input_type][part - 1]}, Got: #{output}"
  end

  puts "   Elapsed time: #{time_to_human_readable elapsed_time}" if show_elapsed_time

  elapsed_time
end

def time_to_human_readable(time_in_seconds)
  time = time_in_seconds
  unit = 's'

  if time_in_seconds <= 1.0 / 1000.0
    time = time_in_seconds * 1000.0 * 1000.0
    unit = 'µs'
  elsif time_in_seconds <= 1.0
    time = time_in_seconds * 1000.0
    unit = 'ms'
  end

  format('%<time>.2f%<unit>s', { time:, unit: })
end

def run(options)
  days_to_run = options[:day] ? [options[:day]] : all_days
  input_type = options[:example] ? :example : :full
  run_part = options[:part] || 0
  show_output = options[:show_output] || false
  show_elapsed_time = options[:show_elapsed_time] || false

  total_time = 0

  puts "\n🎄 Advent of Code 2023 🎄\n".colorize(color: :green, mode: :bold)

  days_to_run.each do |day|
    puzzle_input = get_puzzle_input day
    puzzle = find_puzzle day

    puts "• Day #{day}".colorize(color: :blue, mode: :bold)

    if [0, 1].include? run_part
      total_time += solve_part_and_print_output(puzzle, puzzle_input[input_type], input_type, show_output, show_elapsed_time, part: 1)
    end

    if [0, 2].include? run_part
      total_time += solve_part_and_print_output(puzzle, puzzle_input[input_type], input_type, show_output, show_elapsed_time, part: 2)
    end

    puts
  end

  puts "Total elapsed time: #{time_to_human_readable total_time}" if show_elapsed_time
end

options = parse_options
run options
