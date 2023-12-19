lines = readlines("input.txt")

# NOTE: You need two empty lines after the last grid in the input

function assert_mirror(grid, start, stop)::Int
    potential_value = start
    while true
        start -= 1
        stop += 1

        if start < 1 || stop > length(grid)
            return potential_value
        end

        if grid[start] != grid[stop]
            return 0
        end
    end
end

function part1(input::Vector{String})::Int
    total = 0

    # Load grids
    grids = []
    current = []
    for line in input
        if line == "" || line == "\r"
            push!(grids, current)
            current = []
        else
            push!(current, line)
        end
    end

    popindices = []

    # Check vertically
    for i in eachindex(grids)
        vert_grid = [join(chars) for chars in zip(grids[i]...)]
        for j in 1:length(vert_grid)-1
            if vert_grid[j] == vert_grid[j+1]
                val = assert_mirror(vert_grid, j, j+1)
                if val > 0
                    push!(popindices, i)
                    total += val
                    @goto end_outer_v
                end
            end
        end
        @label end_outer_v
    end

    splice!(grids, popindices)

    # Check horizontally
    for i in eachindex(grids)
        for j in 1:length(grids[i])-1
            if grids[i][j] == grids[i][j+1]
                val = assert_mirror(grids[i], j, j+1)
                if val > 0
                    total += val * 100
                    @goto end_outer_h
                end
            end
        end
        @label end_outer_h
    end
    return total
end

using Distances

function assert_smudge(grid, start, stop)
    potential_value = start
    smudges = 0
    while true
        start -= 1
        stop += 1

        if start < 1 || stop > length(grid)
            return (smudges, potential_value)
        end

        smudges += hamming(grid[start], grid[stop])
    end

end

function part2(input::Vector{String})::Int
    total = 0

    # Load grids
    grids = []
    current = []
    for line in input
        if line == "" || line == "\r"
            push!(grids, current)
            current = []
        else
            push!(current, line)
        end
    end

    for i in eachindex(grids)
        vert_grid = [join(chars) for chars in zip(grids[i]...)]
        for j in length(vert_grid)-1:-1:1
            diff = hamming(vert_grid[j], vert_grid[j+1])
            if diff in [0,1]
                (smudges, val) = assert_smudge(vert_grid, j, j+1)
                if diff + smudges == 1
                    total += val
                    @goto end_v
                end
            end
        end
        @label end_v
    end
    for i in eachindex(grids)
        for j in length(grids[i])-1:-1:1
            diff = hamming(grids[i][j], grids[i][j+1])
            if diff in [0,1]
                (smudges, val) = assert_smudge(grids[i], j, j+1)
                if diff + smudges == 1
                    total += val * 100
                    @goto end_h
                end
            end
        end
        @label end_h
    end
    return total
end

@show part1(lines)
@show part2(lines)