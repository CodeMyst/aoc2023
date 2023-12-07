# frozen_string_literal: true

# --- Day 7: Camel Cards ---
class Puzzle07
  def expected_output
    {
      example: [6_440, 5_905],
      full: [247_823_654, 245_461_700]
    }
  end

  TYPES = %i[five_of_a_kind four_of_a_kind full_house three_of_a_kind two_pair one_pair high_card].freeze
  CARDS = %w[A K Q J T 9 8 7 6 5 4 3 2].freeze
  CARDS_J = %w[A K Q T 9 8 7 6 5 4 3 2 J].freeze

  Hand = Struct.new(:type, :cards, :bid, :use_joker) do
    def <=>(other)
      type_index = TYPES.find_index(type)
      other_type_index = TYPES.find_index(other.type)

      return other_type_index <=> type_index if (other_type_index <=> type_index) != 0

      card_array = use_joker ? CARDS_J : CARDS

      5.times do |index|
        card_index = card_array.find_index(cards[index])
        other_card_index = card_array.find_index(other.cards[index])

        return other_card_index <=> card_index if (other_card_index <=> card_index) != 0
      end
    end
  end

  def solve_part1(input)
    hands = input.split("\n").map do |line|
      hand, bid = line.split(' ')

      Hand.new(get_hand_type(hand), hand, bid.to_i)
    end

    hands.sort.each_with_index.map do |hand, index|
      hand.bid * (index + 1)
    end.sum
  end

  def solve_part2(input)
    hands = input.split("\n").map do |line|
      hand, bid = line.split(' ')

      Hand.new(get_hand_type_with_joker(hand), hand, bid.to_i, use_joker: true)
    end

    hands.sort.each_with_index.map do |hand, index|
      hand.bid * (index + 1)
    end.sum
  end

  private

  def get_hand_type_with_joker(hand)
    current_type = get_hand_type(hand)

    return current_type unless hand.include? 'J'

    cards = {}
    jokers = 0

    hand.split('').each do |card|
      if card == 'J'
        jokers += 1
        next
      end

      cards[card] = cards.key?(card) ? cards[card] + 1 : 1
    end

    if cards.length == 4 && jokers == 1
      :one_pair
    elsif cards.length == 3 && jokers == 1
      :three_of_a_kind
    elsif cards.length == 3 && jokers == 2
      :three_of_a_kind
    elsif cards.length == 2 && jokers == 1
      if cards.values == [2, 2]
        :full_house
      else
        :four_of_a_kind
      end
    elsif cards.length == 2 && jokers == 2
      :four_of_a_kind
    elsif cards.length == 2 && jokers == 3
      :four_of_a_kind
    elsif cards.length == 1
      :five_of_a_kind
    elsif jokers == 5
      :five_of_a_kind
    end
  end

  def get_hand_type(hand)
    uniq_cards = hand.split('').uniq

    return :five_of_a_kind if uniq_cards.length == 1

    if uniq_cards.length == 2
      return :four_of_a_kind if hand.count(uniq_cards[0]) == 4 || hand.count(uniq_cards[1]) == 4

      return :full_house
    end

    if uniq_cards.length == 3
      if hand.count(uniq_cards[0]) == 3 || hand.count(uniq_cards[1]) == 3 || hand.count(uniq_cards[2]) == 3
        return :three_of_a_kind
      end

      return :two_pair
    end

    return :one_pair if uniq_cards.length == 4

    :high_card
  end
end
