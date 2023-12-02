include("../ReadString.jl")
lines = ReadString.read_input()

maxnums = [("red", 12), ("green", 13), ("blue", 14)]

# See if current tuple list is valid
function is_valid_part(colors)
    return mapreduce(
        tup -> tup[1][2] <= tup[2][2],
        &,
        zip(colors, maxnums),
    )
end

function is_valid_hand(hand)
    cur = [["red", 0], ["green", 0], ["blue", 0]]
    colors = split(hand, ",")
    for color in colors
        for (i, tup) in enumerate(cur)
            if contains(color, tup[1])
                cur[i][2] = parse(Int, split(color, " ")[2])
            end
        end
    end
    return is_valid_part(cur)
end

function is_valid_game(in::String)
    all_hands = last(split(in, ":"))
    for hand in split(all_hands, ";")
        if (!is_valid_hand(hand)) 
            return false
        end
    end
    return true
end

# Get game id as int
function game_id(in::String)::Int
    return parse(Int,last(split(first(split(in,":"))," ")))
end

function power_of_game(in::String)::Int
    all_hands = last(split(in, ":"))
    cur = [["red", 0], ["green", 0], ["blue", 0]]
    for hand in split(all_hands, ";")
        colors = split(hand, ",")
        for color in colors
            for (i, tup) in enumerate(cur)
                if contains(color, tup[1])
                    cur[i][2] = max(cur[i][2], parse(Int, split(color, " ")[2]))
                end
            end
        end
    end
    return mapreduce(x->x[2], *, cur)
end

function part1(input::Vector{String})::Int
    return mapreduce(
        game -> game_id(game),
        +,
        filter(
            game -> is_valid_game(game),
            input
        )
    )
end

function part2(input::Vector{String})::Int
    return mapreduce(
        game -> power_of_game(game),
        +,
        input
    )
end

println(part1(lines))
println(part2(lines))