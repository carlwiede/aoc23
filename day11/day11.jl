lines = readlines("input.txt")

function solve(input, exp_mult)::Int

    # Expansion multiplier
    multi = exp_mult - 1

    # Get stars
    star_positions = []
    foreach(y -> foreach(x -> input[y][x] == '#' && push!(star_positions, (y, x, 0, 0)),1:length(input[1])), 1:length(input))

    # Update expanded y positions
    foreach(y -> isempty(filter(p -> p[1] == y, star_positions)) && foreach(enum -> enum[2][1] > y && (star_positions[enum[1]] = (enum[2][1], enum[2][2], enum[2][3] + 1, enum[2][4])), enumerate(star_positions)), 1:length(lines))
    
    # Update expanded x positions
    foreach(x -> isempty(filter(p -> p[2] == x, star_positions)) && foreach(enum -> enum[2][2] > x && (star_positions[enum[1]] = (enum[2][1], enum[2][2], enum[2][3], enum[2][4] + 1)), enumerate(star_positions)), 1:length(lines[1])-1)

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