require "pp"

def read_line
    c = ""
    line = ""

    loop do
        c = STDIN.getc
        if c == "\n" or c == nil then break end
        line += c
    end

    line
end

HAND_TYPES = {
    :high_card => 1,
    :one_pair => 2,
    :two_pair => 3,
    :three_of_a_kind => 4,
    :full_house => 5,
    :four_of_a_kind => 6,
    :five_of_a_kind => 7
}

VALUES = {
    "2" => 1,
    "3" => 2,
    "4" => 3,
    "5" => 4,
    "6" => 5,
    "7" => 6,
    "8" => 7,
    "9" => 8,
    "T" => 9,
    "J" => 10,
    "Q" => 11,
    "K" => 12,
    "A" => 13
}

def get_strength(hand)
    counting = {}

    hand.split("").each do |card|
        if counting[card] != nil
            counting[card] += 1
        else
            counting[card] = 1
        end
    end

    groups = counting.keys()

    if groups.length == 1
        return :five_of_a_kind
    end

    if groups.length == 2
        if counting[groups[0]] == 4 || counting[groups[1]] == 4
            return :four_of_a_kind
        end

        return :full_house
    end

    if groups.length == 3
        if counting[groups[0]] == 3 || counting[groups[1]] == 3 || counting[groups[2]] == 3
            return :three_of_a_kind
        end

        return :two_pair
    end

    if groups.length == 4
        return :one_pair
    end

    return :high_card
end

def stronger(a, b)
    b_strength = get_strength(b)
    a_strength = get_strength(a)

    hand_cmp = HAND_TYPES[b_strength] <=> HAND_TYPES[a_strength]

    return hand_cmp unless hand_cmp == 0

    a_cards = a.split("")
    b_cards = b.split("")

    5.times do |i|
        a_card = VALUES[a_cards[i]]
        b_card = VALUES[b_cards[i]]

        card_cmp = b_card <=> a_card

        return card_cmp unless card_cmp == 0
    end

    return 0
end

cards = []

loop do
    line = read_line

    if line == nil or line == "" then break end

    hand, bid = line.split(" ")

    cards.push [hand, bid.to_i]
end

cards.sort! { |a, b| stronger(b[0], a[0]) }

sum = cards.each.with_index.to_a.reduce(0) do |sum, ((hand, bid), index)|
    sum + bid * (index + 1)
end

PP.pp sum
