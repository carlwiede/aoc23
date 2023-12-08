include("../ReadString.jl")
lines = ReadString.read_input()

function part1(input::Vector{String})::Int
    directions = filter(d -> d != '\r', input[1])
    nodes = Dict{}()

    for line in input[3:end]
        nodes[split(line, " = ")[1]] = (split(split(line, ", ")[1], "(")[2], split(split(line, ", ")[2], ")")[1])
    end

    current_node = "AAA"
    steps = 0

    while current_node != "ZZZ"
        for d in directions
            if current_node == "ZZZ"
                break
            end
            current_node = d == 'R' ? nodes[current_node][2] : nodes[current_node][1]
            steps += 1
        end
    end

    return steps
end

function are_all_nodes_z(nodes)
    if length(filter(n -> endswith(n, "Z"), nodes)) > 3
        @show length(nodes), length(filter(n -> endswith(n, "Z"), nodes))
    end
    return length(nodes) == length(filter(n -> endswith(n, "Z"), nodes))
end

function part2(input::Vector{String})::Int
    directions = filter(d -> d != '\r', input[1])
    nodes = Dict{String, Tuple{String, String}}()

    for line in input[3:end]
        nodes[split(line, " = ")[1]] = (split(split(line, ", ")[1], "(")[2], split(split(line, ", ")[2], ")")[1])
    end

    current_nodes = collect(filter(n -> endswith(n, "A"), keys(nodes)))
    node_stride::Vector{Int} = []
    for node in current_nodes
        steps = 0
        while !endswith(node, "Z")
            for d in directions
                if endswith(node, "Z")
                    break
                end
                node = d == 'R' ? nodes[node][2] : nodes[node][1]
                steps += 1
            end
        end
        push!(node_stride, steps)
    end
    return lcm(node_stride)
end

@show part1(lines)
@show part2(lines)
