# frozen_string_literal: true

# --- Day 5: If You Give A Seed A Fertilizer ---
#
# Ugly, but it works and it's not bruteforce...
# No time to rewrite
# This was a pain...
class Puzzle05
  def expected_output
    {
      example: [35, 46],
      full: [600_279_879, 20_191_102]
    }
  end

  def solve_part1(input)
    seeds = []
    seed_to_soil = []
    soil_to_fertilizer = []
    fertilizer_to_water = []
    water_to_light = []
    light_to_temperature = []
    temperature_to_humidity = []
    humidity_to_location = []

    current_map = nil

    input.split("\n").each do |line|
      next if line.empty?

      seeds = line.split(':').last.split(' ').map(&:chomp).map(&:to_i) if line.start_with?('seeds: ')

      current_map = seed_to_soil if line == 'seed-to-soil map:'
      current_map = soil_to_fertilizer if line == 'soil-to-fertilizer map:'
      current_map = fertilizer_to_water if line == 'fertilizer-to-water map:'
      current_map = water_to_light if line == 'water-to-light map:'
      current_map = light_to_temperature if line == 'light-to-temperature map:'
      current_map = temperature_to_humidity if line == 'temperature-to-humidity map:'
      current_map = humidity_to_location if line == 'humidity-to-location map:'

      next unless line[0] =~ /\d/

      values = line.split(' ').map(&:chomp).map(&:to_i)

      current_map << { destination_start: values[0], source_start: values[1], length: values[2] }
    end

    locations = []

    seeds.each do |seed|
      soil = get_range_value seed_to_soil, seed
      fertilizer = get_range_value soil_to_fertilizer, soil
      water = get_range_value fertilizer_to_water, fertilizer
      light = get_range_value water_to_light, water
      temperature = get_range_value light_to_temperature, light
      humidity = get_range_value temperature_to_humidity, temperature
      location = get_range_value humidity_to_location, humidity

      locations << location
    end

    locations.min
  end

  def solve_part2(input)
    seeds = []
    seed_to_soil = []
    soil_to_fertilizer = []
    fertilizer_to_water = []
    water_to_light = []
    light_to_temperature = []
    temperature_to_humidity = []
    humidity_to_location = []

    current_map = nil

    input.split("\n").each do |line|
      next if line.empty?

      seeds = line.split(':').last.split(' ').map(&:chomp).map(&:to_i) if line.start_with?('seeds: ')

      current_map = seed_to_soil if line == 'seed-to-soil map:'
      current_map = soil_to_fertilizer if line == 'soil-to-fertilizer map:'
      current_map = fertilizer_to_water if line == 'fertilizer-to-water map:'
      current_map = water_to_light if line == 'water-to-light map:'
      current_map = light_to_temperature if line == 'light-to-temperature map:'
      current_map = temperature_to_humidity if line == 'temperature-to-humidity map:'
      current_map = humidity_to_location if line == 'humidity-to-location map:'

      next unless line[0] =~ /\d/

      values = line.split(' ').map(&:chomp).map(&:to_i)

      current_map << {
        destination_range: (values[0]...values[0] + values[2]),
        source_range: (values[1]...values[1] + values[2])
      }
    end

    seed_ranges = seeds.each_slice(2).to_a.map { |r| (r[0]...r[0] + r[1]) }

    soil = seed_ranges.flat_map { |s| map_range(s, seed_to_soil) }.uniq
    fertilizer = soil.flat_map { |f| map_range(f, soil_to_fertilizer) }.uniq
    water = fertilizer.flat_map { |w| map_range(w, fertilizer_to_water) }.uniq
    light = water.flat_map { |l| map_range(l, water_to_light) }.uniq
    temperature = light.flat_map { |t| map_range(t, light_to_temperature) }.uniq
    humidity = temperature.flat_map { |h| map_range(h, temperature_to_humidity) }.uniq
    locations = humidity.flat_map { |l| map_range(l, humidity_to_location) }.uniq

    locations.map(&:first).min
  end

  private

  def map_num(map, source) = map[:destination_range].begin + (source - map[:source_range].begin)

  def map_range(source_range, mapping)
    mapped = []
    matched = false

    mapping.each do |map|
      next if map[:source_range].begin >= source_range.end || source_range.begin >= map[:source_range].end

      matched = true

      mapped << (map_num(map, [source_range.begin, map[:source_range].begin].max)...map_num(map, [source_range.end, map[:source_range].end].min))
      mapped.concat(map_range((source_range.begin...map[:source_range].begin), mapping)) if source_range.begin < map[:source_range].begin
      mapped.concat(map_range((map[:source_range].end...source_range.end), mapping)) if map[:source_range].end < source_range.end
    end

    mapped << source_range unless matched
    mapped
  end

  def get_range_value(ranges, value)
    ranges.each do |range|
      if value.between?(range[:source_start], range[:source_start] + range[:length])
        return range[:destination_start] + (value - range[:source_start])
      end
    end

    value
  end
end
