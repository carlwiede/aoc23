include("../ReadString.jl")
lines = ReadString.read_input()

function get_filtered_line1(line)
    return map(x -> parse(Int, x), filter(c -> c != "", split(last(split(line, ":")), " ")))
end

function get_filtered_line2(line)
    return parse(Int, join(string.(map(x -> parse(Int, x), filter(c -> c != "", split(last(split(line, ":")), " "))))))
end

function find_start(time, distance)
    low, high = 1, time

    while low < high
        mid = (low + high) ÷ 2
        a = mid

        if a * (time - a) > distance
            if (a-1) * (time - (a-1)) <= distance
               low = a
               break
            end
            high = mid
        else
            if (a+1) * (time - (a+1)) > distance
                low = a+1
                break
            end
            low = mid + 1
        end
    end

    return low
end

function find_end(time, distance)
    low, high = 1, time

    while low < high
        mid = (low + high) ÷ 2
        a = mid

        if a * (time - a) > distance
            if (a+1) * (time - (a+1)) <= distance
               low = a
               break
            end
            low = mid + 1
        else
            if (a-1) * (time - (a-1)) > distance
                low = a-1
                break
            end
            high = mid
        end
    end

    return low
end

function get_ways_to_win(time, distance)
    return find_end(time, distance) - find_start(time, distance) + 1
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