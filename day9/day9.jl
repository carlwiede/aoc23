include("../ReadFile.jl")
lines = ReadFile.read_input()

function value_of_line1(line)
    all_vals = [map(n -> parse(Int, n), split(line, " "))]

    # Generate graph
    index = 1
    while !all(v -> v == 0, all_vals[index])
        new_vals = []
        for i in 1:length(all_vals[index])-1
            push!(new_vals, all_vals[index][i+1] - all_vals[index][i])
        end
        push!(all_vals, new_vals)
        index += 1
    end

    # Get value
    push!(last(all_vals), 0)
    for i in length(all_vals)-1:-1:1
        push!(all_vals[i], last(all_vals[i+1]) + last(all_vals[i]))
    end

    return last(all_vals[1])
end

function value_of_line2(line)
    all_vals = [map(n -> parse(Int, n), split(line, " "))]

    # Generate graph
    index = 1
    while !all(v -> v == 0, all_vals[index])
        new_vals = []
        for i in 1:length(all_vals[index])-1
            push!(new_vals, all_vals[index][i+1] - all_vals[index][i])
        end
        push!(all_vals, new_vals)
        index += 1
    end

    # Get value
    prepend!(last(all_vals), 0)
    for i in length(all_vals)-1:-1:1
        prepend!(all_vals[i], first(all_vals[i]) - first(all_vals[i+1]))
    end

    return first(all_vals[1])
end

function part1(input::Vector{String})::Int
    mapreduce(
        l -> value_of_line1(l),
        +,
        input
    )
end

function part2(input::Vector{String})::Int
    mapreduce(
        l -> value_of_line2(l),
        +,
        input
    )
end

@show part1(lines)
@show part2(lines)