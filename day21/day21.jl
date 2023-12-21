lines = readlines("input.txt")

function surroundings(pos)
    return [(pos[1]+1, pos[2]), (pos[1]-1, pos[2]), (pos[1], pos[2]+1), (pos[1], pos[2]-1)]
end

function part1(input::Vector{String})::Int
    
    max_steps = 64
    to_visit = Set{Tuple{Int, Int}}()

    # Find S
    s_pos = (1,1)
    for (i, line) in enumerate(input)
        x_pos = findfirst(c -> c == 'S', line)
        x_pos !== nothing && (s_pos = (i, x_pos); break)
    end
    
    push!(to_visit, s_pos)

    for i in 1:max_steps
        possies = collect(to_visit)
        to_visit = Set{Tuple{Int, Int}}()
        while !isempty(possies)
            pos = pop!(possies)
            for sur in surroundings(pos)
                if sur[1] >= 1 && sur[2] >= 1 && sur[1] <= length(input) && sur[2] <= length(input[1]) && input[sur[1]][sur[2]] != '#'
                    push!(to_visit, sur)
                end
            end
        end
    end
    return length(to_visit)
end

function part2(input::Vector{String}, max_steps)::Int
    to_visit = Set{Tuple{Int, Int}}()

    # Find S
    s_pos = (1,1)
    for (i, line) in enumerate(input)
        x_pos = findfirst(c -> c == 'S', line)
        x_pos !== nothing && (s_pos = (i, x_pos); break)
    end
    
    push!(to_visit, s_pos)

    cache = Dict{Int, Int}()

    n = length(input)
    k, r = round(Int, max_steps / n), max_steps % n

    for i in 1:r+2*n
        possies = collect(to_visit)
        to_visit = Set{Tuple{Int, Int}}()
        while !isempty(possies)
            pos = pop!(possies)
            for sur in surroundings(pos)
                if input[(sur[1] % length(input) + length(input) - 1) % length(input) + 1][(sur[2] % length(input[1]) + length(input[1]) - 1) % length(input[1]) + 1] != '#'
                    push!(to_visit, sur)
                end
            end
        end
        cache[i] = length(to_visit)
    end

    d2 = cache[r+2*n] + cache[r] - 2 * cache[r+n]
    d1 = cache[r+2*n] - cache[r+n]
    return cache[r+2*n] + (k-2) * (2 * d1 + (k-1) * d2) // 2
end

@show part1(lines)
@show part2(lines, 26501365)