lines = readlines("input.txt")

using LinearAlgebra

wires = Tuple{String, String}[]

function part1(input::Vector{String})::Int
    for line in input
        key, values = split(line, ": ")
        values = split(values, " ")
        for val in values
            push!(wires, (key, val))
        end
    end
    unique_wires = union(first.(wires), last.(wires))
    arr = zeros(Int, length(unique_wires), length(unique_wires))
    for (w1, w2) in wires
        arr[findfirst(==(w1), unique_wires), findfirst(==(w2), unique_wires)] = 1
    end
    D = Diagonal(vec(sum(arr + arr', dims=2))) - arr - arr'
    E = eigvecs(D)[:, 2]
    return count(E .> 0) * count(E .< 0)
end

@show part1(lines)
