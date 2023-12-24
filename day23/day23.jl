lines = readlines("input.txt")

using OrderedCollections

grid = [line[i] for line in lines, i in 1:length(lines[1])]

dirs = (-1,0), (0,1), (1,0), (0,-1)

function options(pos)
    [pos .+ dir for dir in dirs]
end

function possible(pos)
    possible::Vector{Tuple{Int, Int}} = []
    for (i, opt) in enumerate(options(pos))
        if opt[1] >= 1 && opt[2] >= 1 && opt[1] <= length(grid[:,1]) && opt[2] <= length(grid[1,:]) && grid[opt...] != '#' && !(grid[opt...] == 'v' && i == 1) && !(grid[opt...] == '>' && i == 4)
            push!(possible, opt)
        end
    end
    possible
end

function possible2(pos)
    possible::Vector{Tuple{Int, Int}} = []
    for (i, opt) in enumerate(options(pos))
        if opt[1] >= 1 && opt[2] >= 1 && opt[1] <= length(grid[:,1]) && opt[2] <= length(grid[1,:]) && grid[opt...] != '#'
            push!(possible, opt)
        end
    end
    possible
end

function part1()::Int
    start = (2,2)
    current = start

    visited = [(1,2)]
    path_lengths = []
    to_visit = []

    @label still_visiting
    if !isempty(to_visit)
        current, length_visited = pop!(to_visit)
        visited = visited[1:length_visited]
    end

    while !((length(grid[:,1]), length(grid[1,:])-1) in visited)
        push!(visited, current)
        
        moves = possible(current)
        filter!(x -> !(x in visited), moves)
        
        if length(moves) == 1
            current = moves[1]
        elseif length(moves) == 2
            push!(to_visit, (moves[2], length(visited)))
            current = moves[1]
        else
            break
        end
    end

    # -1 because we don't count the starting position
    push!(path_lengths, length(visited)-1)
    
    if !isempty(to_visit)
        @goto still_visiting
    end

    return max(path_lengths...)
end

function part2()::Int
    target = (length(grid[:,1]), length(grid[1,:])-1)

    G = OrderedDict()

    for y in 1:length(grid[1,:])
        for x in 1:length(grid[:,1])
            if grid[y,x] != '#'
                G[(y,x)] = grid[y,x]
            end
        end
    end

    keypoints = []
    for k in collect(keys(G))
        if length(possible2(k)) > 2
            push!(keypoints, k)
        end
    end
    pushfirst!(keypoints, (1,2))
    push!(keypoints, target)

    E = OrderedDict()
    for k in keys(G)
        E[k] = possible2(k)
    end

    # O is dict with entry for each node, value is list of connected keypoint and how far away they are
    P = OrderedDict()
    for n in keys(E)
        visited = [n]
        connections = []
        function next_endpoint(node, numba=1)
            push!(visited, node)
            if node in keypoints
                push!(connections, (node, numba))
                return
            end
            for conn in E[node]
                if !(conn in visited)
                    next_endpoint(conn, numba+1)
                end
            end
        end
        for con in E[n]
            next_endpoint(con)
        end
        P[n] = connections
    end

    #@show P

    function search(node, dist, best, seen=Set{Tuple{Int, Int}}(), stop=(141, 140))
                
        #println(node, " ", dist, " ", best, " ", seen)

        node == stop && return dist
        node in seen && return best

        push!(seen, node)
        best = maximum(search(n, d+dist, best, seen) for (n, d) in P[node])
        delete!(seen, node)

        return best
    end

    return search((1, 2), 0, 0)
end

@show part1()
@show part2()