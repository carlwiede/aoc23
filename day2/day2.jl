include("../ReadString.jl")
lines = ReadString.read_input()

maxnums = [("red", 12), ("green", 13), ("blue", 14)]

# See if current tuple list is valid
function is_valid_part(clrs)
    return mapreduce(
        tup -> tup[1][2] <= tup[2][2],
        &,
        zip(clrs, maxnums),
    )
end

function is_valid_line(in::String)
    line = last(split(in, ":"))
    for line in split(line, ";")
        cur = [["red", 0], ["green", 0], ["blue", 0]]
        colors = split(line, ",")
        for clr in colors
            for (i, tup) in enumerate(cur)
                if contains(clr, tup[1])
                    cur[i][2] = parse(Int, split(clr, " ")[2])
                end
            end
        end
        if (!is_valid_part([(cur[1][1], cur[1][2]), (cur[2][1], cur[2][2]),(cur[3][1], cur[3][2])]))
            return false
        end
    end
    return true
end

# Get game id as int
function game_id(in::String)::Int
    return parse(
        Int,
        last(
            split(
                first(
                    split(
                        in,
                        ":"
                    )
                ), 
                " "
            )
        )
    )
end

function power_of_line(in::String)::Int
    line = last(split(in, ":"))
    cur = [["red", 0], ["green", 0], ["blue", 0]]
    for line in split(line, ";")
        colors = split(line, ",")
        for clr in colors
            for (i, tup) in enumerate(cur)
                if contains(clr, tup[1])
                    val = parse(Int, split(clr, " ")[2])
                    if (val > cur[i][2])
                        cur[i][2] = val 
                    end
                end
            end
        end
    end
    return cur[1][2] * cur[2][2] * cur[3][2]
end

function part1(input::Vector{String})::Int
    return mapreduce(
        line -> game_id(line),
        +,
        filter(
            line -> is_valid_line(line),
            input
        )
    )
end

function part2(input::Vector{String})::Int
    return mapreduce(
        line -> power_of_line(line),
        +,
        input
    )
end

println(part1(lines))
println(part2(lines))