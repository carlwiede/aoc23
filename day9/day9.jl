include("../ReadFile.jl")
lines = ReadFile.read_input()

function get_graph(line)
    all_vals = [map(n -> parse(Int, n), split(line, " "))]
    index = 1
    while !all(v -> v == 0, all_vals[index])
        new_vals = []
        for i in 1:length(all_vals[index])-1
            push!(new_vals, all_vals[index][i+1] - all_vals[index][i])
        end
        push!(all_vals, new_vals)
        index += 1
    end
    all_vals
end

function value_of_line1(graph)
    push!(last(graph), 0)
    for i in length(graph)-1:-1:1
        push!(graph[i], last(graph[i+1]) + last(graph[i]))
    end
    last(graph[1])
end

function value_of_line2(graph)
    prepend!(last(graph), 0)
    for i in length(graph)-1:-1:1
        prepend!(graph[i], first(graph[i]) - first(graph[i+1]))
    end
    first(graph[1])
end

function part1(input::Vector{String})::Int
    mapreduce(
        l -> value_of_line1(get_graph(l)),
        +,
        input
    )
end

function part2(input::Vector{String})::Int
    mapreduce(
        l -> value_of_line2(get_graph(l)),
        +,
        input
    )
end

@show part1(lines)
@show part2(lines)