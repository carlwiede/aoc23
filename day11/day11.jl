include("../ReadFile.jl")
lines = ReadFile.read_input()

function part1(input::Vector{String})::Int
    star_positions = []

    # Get stars
    for y in 1:length(input)
        for x in 1:length(input[1])-1
            if input[y][x] == '#'
                push!(star_positions, (y, x))
            end
        end
    end

    new_input = []

    for y in 1:length(input)
        push!(new_input, input[y])
        if isempty(filter(p -> p[1] == y, star_positions))
            push!(new_input, input[y])
        end
    end

    added = 0
    for x in 1:length(input[1])-1
        if isempty(filter(p -> p[2] == x, star_positions))
            for y in 1:length(new_input)
                new_input[y] = string(new_input[y][1:x+added], '.', new_input[y][x+1+added:end])
            end
            added += 1
        end
    end

    input = copy(new_input)

    # Get stars again
    star_positions = []
    for y in 1:length(input)
        for x in 1:length(input[1])-1
            if input[y][x] == '#'
                push!(star_positions, (y, x))
            end
        end
    end

    lengths = 0
    for i in 1:length(star_positions)
        for j in 1+i:length(star_positions)
            dy = abs(star_positions[i][1] - star_positions[j][1])
            dx = abs(star_positions[i][2] - star_positions[j][2])
            lengths += dx + dy
        end
    end
    
    return lengths
end

function part2(input::Vector{String})::Int

    multi = 1000000000 - 1

    star_positions = []

    # Get stars
    for y in 1:length(input)
        for x in 1:length(input[1])-1
            if input[y][x] == '#'
                push!(star_positions, (y, x, 0, 0))
            end
        end
    end

    for y in 1:length(input)
        if isempty(filter(p -> p[1] == y, star_positions))
            for (i, p) in enumerate(star_positions)
                if p[1] > y
                    star_positions[i] = (p[1], p[2], p[3] + 1, p[4])
                end
            end
        end
    end

    for x in 1:length(input[1])-1
        if isempty(filter(p -> p[2] == x, star_positions))
            for (i, p) in enumerate(star_positions)
                if p[2] > x
                    star_positions[i] = (p[1], p[2], p[3], p[4] + 1)
                end
            end
        end
    end

    lengths = 0
    for i in 1:length(star_positions)
        for j in 1+i:length(star_positions)
            dy = abs((star_positions[i][1] + star_positions[i][3]*multi) - (star_positions[j][1] + star_positions[j][3]*multi))
            dx = abs((star_positions[i][2] + star_positions[i][4]*multi) - (star_positions[j][2] + star_positions[j][4]*multi))
            lengths += dx + dy
        end
    end
    
    return lengths
end

@show part1(lines)
@show part2(lines)