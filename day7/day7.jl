include("../ReadString.jl")
lines = ReadString.read_input()

cards_vals1 = Dict('A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10, '9' => 9, '8' => 8, '7' => 7, '6' => 6, '5' => 5, '4' => 4, '3' => 3, '2' => 2)
function hand_is_higher1(hand1, hand2)::Bool
    for (c1, c2) in zip(hand1[1], hand2[1])
        c1v = cards_vals1[c1]
        c2v = cards_vals1[c2]
        if c1v == c2v
            continue
        elseif c1v > c2v
            return true
        else
            return false
        end
    end
end
function type_value_of_hand1(hand)::Int
    cds = Dict()
    for c in hand[1]
        cds[c] = 1 + get(cds, c, 0)
    end
    if length(cds) == 1 # five kind
        return 7
    elseif length(cds) == 2 # four kind or full house
        if maximum(values(cds)) == 4
            return 6
        else
            return 5
        end
    elseif length(cds) == 3 # three kind or two pair
        if maximum(values(cds)) == 3
            return 4
        else
            return 3
        end
    elseif length(cds) == 4 # one pair
        return 2
    end
    return 1
end

function hand_is_better1(hand1, hand2)
    hand1_val = type_value_of_hand1(hand1)
    hand2_val = type_value_of_hand1(hand2)
    if hand1_val > hand2_val 
        return true
    elseif hand1_val == hand2_val
        return hand_is_higher1(hand1, hand2)
    else
        return false
    end
end

function part1(input::Vector{String})::Int
    formatted_hands = [(split(line, " ")[1], parse(Int, split(line, " ")[2])) for line in input]
    ranked_list = [(i, hand[2]) for (i, hand) in enumerate(reverse(sort(formatted_hands, lt=hand_is_better1)))]
    return mapreduce(hand -> hand[1] * hand[2], +, ranked_list)
end

cards_vals2 = Dict('A' => 14, 'K' => 13, 'Q' => 12, 'T' => 10, '9' => 9, '8' => 8, '7' => 7, '6' => 6, '5' => 5, '4' => 4, '3' => 3, '2' => 2, 'J' => 1)
function hand_is_higher2(hand1, hand2)::Bool
    for (c1, c2) in zip(hand1[1], hand2[1])
        c1v = cards_vals2[c1]
        c2v = cards_vals2[c2]
        if c1v == c2v
            continue
        elseif c1v > c2v
            return true
        else
            return false
        end
    end
end
function type_value_of_hand2(hand)::Int
    cds = Dict()
    for c in hand[1]
        cds[c] = 1 + get(cds, c, 0)
    end
    if length(cds) == 1 # five kind, joker don't matter
        return 7
    elseif length(cds) == 2 # four kind or full house
        if maximum(values(cds)) == 4 # four kind, maybe joker?
            if in('J', keys(cds))
                return 7
            else
                return 6
            end
        else # full house, mby joker?
            if in('J', keys(cds))
                return 7
            else    
                return 5
            end
        end
    elseif length(cds) == 3 # three kind or two pair
        if maximum(values(cds)) == 3 # three kind
            if in('J', keys(cds))
                return 6
            else
                return 4
            end
        else # two pair
            if in('J', keys(cds))
                if cds['J'] == 1
                    return 5
                else
                    return 6
                end
            else
                return 3
            end
        end
    elseif length(cds) == 4 # one pair, maybe three with joker?
        if in('J', keys(cds))
            return 4
        else
            return 2
        end
    else
        if in('J', keys(cds))
            return 2
        else
            return 1
        end
    end
end

function hand_is_better2(hand1, hand2)
    hand1_val = type_value_of_hand2(hand1)
    hand2_val = type_value_of_hand2(hand2)
    if hand1_val > hand2_val
        return true
    elseif hand1_val == hand2_val
        return hand_is_higher2(hand1, hand2)
    else
        return false
    end
end

function part2(input::Vector{String})::Int
    formatted_hands = [(split(line, " ")[1], parse(Int, split(line, " ")[2])) for line in input]
    ranked_list = [(i, hand[2]) for (i, hand) in enumerate(reverse(sort(formatted_hands, lt=hand_is_better2)))]
    return mapreduce(hand -> hand[1] * hand[2], +, ranked_list)
end

@show part1(lines)
@show part2(lines)