include("../ReadString.jl")
lines = ReadString.read_input()

nr_scratchcards = ones(Int, length(lines))
matches_in_cards = zeros(Int, length(lines))

function parse_card(card)
    numbers = split(card, ":")[2]
    winning_side = split(numbers, "|")[1]
    my_side = split(numbers, "|")[2]
    winning_numbers = split(winning_side, " ")
    my_numbers = split(my_side, " ")
    winning_numbers = filter(n -> n != "", winning_numbers)
    my_numbers = filter(n -> n != "", my_numbers)
    winning_ints = map(
        n -> parse(Int, n),
        winning_numbers
    )
    my_ints = map(
        n -> parse(Int, n),
        my_numbers
    )
    return (winning_ints, my_ints)
end

function get_value_of_card(card)
    winning_ints, my_ints = parse_card(card)
    matches = 0
    for num in my_ints
        if in(num, winning_ints)
            matches += 1
        end
    end
    if matches > 0
        winning_value = 1 * 2^(matches-1)
        return winning_value
    end
    return 0
end

function part1(input::Vector{String})::Int
    return mapreduce(
        card -> get_value_of_card(card),
        +,
        input
    )
end

function count_matches(card, i)
    winning_ints, my_ints = parse_card(card)
    matches = 0
    for num in my_ints
        if in(num, winning_ints)
            matches += 1
        end
    end
    matches_in_cards[i] = matches
end

function process_matches()
    for i in 1:203
        for n in 1:matches_in_cards[i]
            nr_scratchcards[i+n] += nr_scratchcards[i]
        end
    end
end

function part2(input::Vector{String})::Int
    for i in 1:203
        card = input[i]
        count_matches(card, i)
    end
    process_matches()
    return reduce(+, nr_scratchcards)
end

println(part1(lines))
println(part2(lines))