include("../ReadFile.jl")
lines::Vector{String} = ReadFile.read_input()

function get_connections(pos)
    poses = ((0,0),(0,0))

    c = lines[pos[1]][pos[2]]

    if c == '|'
        poses = ((pos[1]-1, pos[2]), (pos[1]+1, pos[2]))
    elseif c == '-'
        poses = ((pos[1], pos[2]-1), (pos[1], pos[2]+1))
    elseif c == 'F'
        poses = ((pos[1]+1, pos[2]), (pos[1], pos[2]+1))
    elseif c == 'L'
        poses = ((pos[1]-1, pos[2]), (pos[1], pos[2]+1))
    elseif c == '7'
        poses = ((pos[1]+1, pos[2]), (pos[1], pos[2]-1))
    elseif c == 'J'
        poses = ((pos[1]-1, pos[2]), (pos[1], pos[2]-1))
    end

    return poses
end

function part1(input::Vector{String})::Int
    
    s_y = 0
    s_x = 0
    for y in 1:length(lines)
        for x in 1:length(lines[1])-1
            if input[y][x] == 'S'
                s_y = y
                s_x = x
            end
        end
    end

    # Replace S with proper connection (hard coded, don't @ me)
    lines[s_y] = string(lines[s_y][1:s_x-1], '7', lines[s_y][s_x+1:end])
    
    p1, p2 = get_connections((s_y, s_x))
    prev1 = (s_y, s_x)
    prev2 = (s_y, s_x)
    c1 = 1
    c2 = 1
    
    while c1 == c2
        next_steps1 = get_connections(p1)
        next = (0,0)
        if next_steps1[1] == prev1
            next = next_steps1[2]
        else
            next = next_steps1[1]
        end
        if next == p2
            break
        end
        prev1 = p1
        p1 = next
        c1 += 1

        next_steps2 = get_connections(p2)
        next = (0,0)
        if next_steps2[1] == prev2
            next = next_steps2[2]
        else
            next = next_steps2[1]
        end
        if next == p1
            break
        end
        prev2 = p2
        p2 = next
        c2 += 1
    end

    lines[s_y] = string(lines[s_y][1:s_x-1], 'S', lines[s_y][s_x+1:end])
    
    return max(c1, c2)
end

function part2(input::Vector{String})::Int
    
    # 0 = Free
    # 1 = Line
    # 2 = Contained
    # 3 = Unexplored
    tiles = Dict{Tuple{Int, Int}, Int}()

    s_y = 0
    s_x = 0
    for y in 1:length(lines)
        for x in 1:length(lines[1])-1
            if input[y][x] == 'S'
                s_y = y
                s_x = x
            end
        end
    end

    # Replace S with proper connection (hard coded, don't @ me)
    lines[s_y] = string(lines[s_y][1:s_x-1], '7', lines[s_y][s_x+1:end])
    
    p1, p2 = get_connections((s_y, s_x))
    prev1 = (s_y, s_x)
    prev2 = (s_y, s_x)
    c1 = 1
    c2 = 1

    tiles[(s_y, s_x)] = 1
    tiles[p1] = 1
    tiles[p2] = 1
    
    while c1 == c2
        next_steps1 = get_connections(p1)
        next = (0,0)
        if next_steps1[1] == prev1
            next = next_steps1[2]
        else
            next = next_steps1[1]
        end
        if next == p2
            break
        end
        tiles[next] = 1
        prev1 = p1
        p1 = next
        c1 += 1

        next_steps2 = get_connections(p2)
        if next_steps2[1] == prev2
            next = next_steps2[2]
        else
            next = next_steps2[1]
        end
        if next == p1
            break
        end
        tiles[next] = 1
        prev2 = p2
        p2 = next
        c2 += 1
    end
    
    for y in 1:length(lines)
        for x in 1:length(lines[1])-1
            if get(tiles, (y,x), 3) == 3
                lines[y] = string(lines[y][1:x-1], '.', lines[y][x+1:end])
            end
        end
    end

    area = 0

    for y in 1:length(lines)
        in_area = false
        latest_corner = '_'
        for x in 1:length(lines[1])-1
            c = lines[y][x]
            
            if c == '.' && in_area
                area += 1
            end

            if c == '|'
                in_area = !in_area
            end

            if c == 'L'
                latest_corner = 'L'
            end

            if c == 'F'
                latest_corner = 'F'
            end

            if c == '7' && latest_corner != 'F'
                in_area = !in_area
            end

            if c == 'J' && latest_corner != 'L'
                in_area = !in_area
            end

        end
    end

    return area
end

@show part1(lines)
@show part2(lines)
