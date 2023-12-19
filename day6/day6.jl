lines = readlines("input.txt")

function get_filtered_line1(line)
    return map(x -> parse(Int, x), filter(c -> c != "", split(last(split(line, ":")), " ")))
end

function get_filtered_line2(line)
    return parse(Int, join(string.(map(x -> parse(Int, x), filter(c -> c != "", split(last(split(line, ":")), " "))))))
end

function get_ways_to_win(time, distance)
    a = -(-time/2)
    b = sqrt((-time/2)^2-distance)
    x1 = a + b
    x2 = a - b
    return Int(ceil(x1)) - Int(floor(x2)) - 1
end

function part1(input::Vector{String})::Int
    time_list = get_filtered_line1(input[1])
    dist_list = get_filtered_line1(input[2])
    return reduce(*, get_ways_to_win(t, d) for (t, d) in zip(time_list, dist_list))
end

function part2(input::Vector{String})::Int
    time_list = get_filtered_line2(input[1])
    dist_list = get_filtered_line2(input[2])
    return get_ways_to_win(time_list[1], dist_list[1])
end

@show part1(lines)
@show part2(lines)