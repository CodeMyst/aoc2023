# frozen_string_literal: true

# --- Day 4: Scratchcards ---
#
# Part 1
#
# You have to figure out which of the numbers you have appear
# in the list of winning numbers. The first match makes the card
# worth one point and each match after the first doubles the
# point value of that card.
#
# Part 2
#
# Scratchcards only cause you to win more scratchcards equal to
# the number of winning numbers you have.
#
# Specifically, you win copies of the scratchcards below the winning
# card equal to the number of matches. So, if card 10 were to have
# 5 matching numbers, you would win one copy each of cards
# 11, 12, 13, 14, and 15.
#
# Copies of scratchcards are scored like normal scratchcards and have
# the same card number as the card they copied. So, if you win a copy
# of card 10 and it has 5 matching numbers, it would then win a copy
# of the same cards that the original card 10 won:
# cards 11, 12, 13, 14, and 15. This process repeats until none of
# the copies cause you to win any more cards.
# (Cards will never make you copy a card past the end of the table.)
#
# Process all of the original and copied scratchcards until no more
# scratchcards are won. Including the original set of scratchcards,
# how many total scratchcards do you end up with?
class Puzzle04
  def expected_output
    {
      example: [13, 30],
      full: [21_558, 10_425_665]
    }
  end

  def solve_part1(input)
    sum = 0

    input.split("\n").each do |line|
      scratch_numbers = get_scratch_numbers line
      winning_numbers = get_winning_numbers line
      matching = winning_numbers & scratch_numbers

      sum += 1 if matching.length == 1
      sum += 2**(matching.length - 1) if matching.length > 1
    end

    sum
  end

  def solve_part2(input)
    cards = {}

    input.split("\n").each_with_index do |line, card_id|
      scratch_numbers = get_scratch_numbers line
      winning_numbers = get_winning_numbers line
      matching = winning_numbers & scratch_numbers

      cards[card_id] = if cards.key? card_id
                         cards[card_id] + 1
                       else
                         1
                       end

      next if matching.empty?

      (card_id + 1..card_id + matching.length).each do |m|
        cards[m] = (cards.key?(m) ? cards[m] : 0) + cards[card_id]
      end
    end

    cards.values.sum
  end

  private

  def get_scratch_numbers(line)
    line.split(':')
        .last
        .split('|')
        .first
        .split(' ')
        .map(&:chomp)
        .map(&:to_i)
  end

  def get_winning_numbers(line)
    line.split('|')
        .last
        .split(' ')
        .map(&:chomp)
        .map(&:to_i)
  end
end
