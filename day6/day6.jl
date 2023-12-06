include("../ReadString.jl")
lines = ReadString.read_input()

function get_filtered_line1(line)
    return map(x -> parse(Int, x), filter(c -> c != "", split(last(split(line, ":")), " ")))
end

function get_filtered_line2(line)
    return parse(Int, join(string.(map(x -> parse(Int, x), filter(c -> c != "", split(last(split(line, ":")), " "))))))
end

function get_ways_to_win(time, distance)
    a = 0
    ways_to_win = 0

    for t in 1:time
        a = t
        if a * (time - t) > distance
            ways_to_win += 1
        end
    end

    return ways_to_win
end

function part1(input::Vector{String})::Int
    time_list = get_filtered_line1(input[1])
    dist_list = get_filtered_line1(input[2])
    return reduce(*, get_ways_to_win(t, d) for (t, d) in zip(time_list, dist_list))
end

function part2(input::Vector{String})::Int
    time_list = get_filtered_line2(input[1])
    dist_list = get_filtered_line2(input[2])
    return reduce(*, get_ways_to_win(t, d) for (t, d) in zip(time_list, dist_list))
end

@show part1(lines)
@show part2(lines)