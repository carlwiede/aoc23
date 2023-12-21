lines = readlines("input.txt")

grid = lines;

@enum Direction up right down left

global energized = Dict{Tuple{Int, Int}, Set{Direction}}()

function new_pos(y, x, dir)
    if dir == up
        y-1, x
    elseif dir == right
        y, x+1
    elseif dir == down
        y+1, x
    else dir == left
        y, x-1
    end
end

function new_dir(c, dir)
    if c == '|' && (dir == right || dir == left)
        return [up, down]
    elseif c == '-' && (dir == up || dir == down)
        return [right, left]
    elseif c == '/'
        dir == right && return [up]
        dir == up && return [right]
        dir == left && return [down]
        dir == down && return [left]
    elseif c == '\\'
        dir == right && return [down]
        dir == up && return [left]
        dir == left && return [up]
        dir == down && return [right]
        return
    else
        return [dir]
    end
end

function beam(y, x, dir)

    # Energize
    if !haskey(energized, (y, x))
        energized[(y,x)] = Set{Direction}()
    else
        if dir in energized[(y,x)]
            return
        end
    end
    push!(energized[(y,x)], dir)

    # Bounds check
    next_y, next_x = new_pos(y, x, dir)
    if next_y < 1 || next_y > length(grid) || next_x < 1 || next_x > length(grid[1])
        return
    end

    next_char = grid[next_y][next_x]
    next_dirs = new_dir(next_char, dir)
    for dir in next_dirs
        beam(next_y, next_x, dir)
    end

end

function part1()::Int
    global energized
    for dir in new_dir(grid[1][1], right)
        beam(1, 1, dir)
    end
    return length(energized)
end

function part2()::Int
    max_beam = 0
    global energized
    
    for x in 1:1:length(grid[1])
        for dir in new_dir(grid[1][x], down)
            beam(1, x, dir)
        end
        max_beam = max(max_beam, length(energized))
        energized = Dict{Tuple{Int, Int}, Set{Direction}}()
    end

    for x in 1:1:length(grid[1])
        for dir in new_dir(grid[end][x], up)
            beam(length(grid), x, dir)
        end
        max_beam = max(max_beam, length(energized))
        energized = Dict{Tuple{Int, Int}, Set{Direction}}()
    end

    for y in 1:1:length(grid)
        for dir in new_dir(grid[y][1], right)
            beam(y, 1, dir)
        end
        max_beam = max(max_beam, length(energized))
        energized = Dict{Tuple{Int, Int}, Set{Direction}}()
    end

    for y in 1:1:length(grid)
        for dir in new_dir(grid[y][length(grid[1])], left)
            beam(y, length(grid[1]), dir)
        end
        max_beam = max(max_beam, length(energized))
        energized = Dict{Tuple{Int, Int}, Set{Direction}}()
    end

    return max_beam
end

@show part1()
@show part2()