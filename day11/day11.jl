include("../ReadFile.jl")
lines = ReadFile.read_input()

function solve(input, exp_mult)::Int

    # Expansion multiplier
    multi = exp_mult - 1

    # Get stars
    star_positions = []
    for y in 1:length(input)
        for x in 1:length(input[1])-1
            if input[y][x] == '#'
                push!(star_positions, (y, x, 0, 0))
            end
        end
    end

    # Update expanded y positions
    for y in 1:length(input)
        if isempty(filter(p -> p[1] == y, star_positions))
            for (i, p) in enumerate(star_positions)
                if p[1] > y
                    star_positions[i] = (p[1], p[2], p[3] + 1, p[4])
                end
            end
        end
    end

    # Update expanded x positions
    for x in 1:length(input[1])-1
        if isempty(filter(p -> p[2] == x, star_positions))
            for (i, p) in enumerate(star_positions)
                if p[2] > x
                    star_positions[i] = (p[1], p[2], p[3], p[4] + 1)
                end
            end
        end
    end

    # Calculate steps
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

@show solve(lines, 2) # Part 1
@show solve(lines, 1000000) # Part 2