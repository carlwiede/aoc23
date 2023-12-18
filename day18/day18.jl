lines = readlines("input.txt")

function pr(grid)
    for row in 1:size(grid, 1)
        for col in 1:size(grid, 2)
            print(grid[row, col], "")
        end
        println()
    end
    println()
end

function change(dir, len)::Tuple{Int, Int}
    if dir == "R"
        0, len
    elseif dir == "L"
        0, -len
    elseif dir == "U"
        -len, 0
    elseif dir == "D"
        len, 0
    end
end

function flood!(grid, y, x)
    if grid[y, x] != '#'
        grid[y, x] = '#'
        flood!(grid, y+1, x)
        flood!(grid, y-1, x)
        flood!(grid, y, x+1)
        flood!(grid, y, x-1)
    end
end

function part1(input::Vector{String})::Int
    y, x, = 1, 1
    corners = [(y, x)]
    for line in input
        split_in = split(line, " ")
        dir = split_in[1]
        len = parse(Int, split_in[2])
        ch = change(dir, len)
        y += ch[1]
        x += ch[2]
        push!(corners, (y, x))
    end
    
    min_x = minimum(x for (y, x) in corners)
    max_x = maximum(x for (y, x) in corners)
    min_y = minimum(y for (y, x) in corners)
    max_y = maximum(y for (y, x) in corners)

    width = max_x - min_x + 1
    height = max_y - min_y + 1

    # Initialize 2D array with '.'
    grid = fill('.', height, width)

    # Fill in the outline
    for i in 1:length(corners)-1
        y1, x1 = corners[i]
        y2, x2 = corners[i+1]
        grid[y1-min_y+1:(y1<y2 ? 1 : -1):y2-min_y+1, x1-min_x+1:(x1<x2 ? 1 : -1):x2-min_x+1] .= '#'
    end

    # Hard coded, sue me
    #flood!(grid, 2, 2) # smol
    flood!(grid, 3, 40) # big


    return count(x -> x == '#', grid)
end

function get_dir(num)
    if num == 0
        "R"
    elseif num == 1
        "D"
    elseif num == 2
        "L"
    elseif num == 3
        "U"
    end
end

function get_area(corners)
    return 0.5 * abs(sum(corners[i][1]*corners[i-1][2] - corners[i-1][1]*corners[i][2] for i in 2:1:length(corners)))
end

function get_inside(area, border_len)
    return convert(Int, area - 0.5 * border_len + 1)
end

function part2(input::Vector{String})::Int
    y, x, = 0, 0
    border_len = 0
    corners = Vector{Tuple{Int, Int}}(undef, length(input))
    for i in 1:length(input)
        split_in = split(input[i], " ")
        whole_hex = split_in[3][3:end-1]
        dir = get_dir(parse(Int, whole_hex[end]))
        len = parse(Int, whole_hex[1:end-1], base=16)
        ch = change(dir, len)
        border_len += max(abs(ch[1]), abs(ch[2]))
        y += ch[1]
        x += ch[2]
        corners[i] = (y, x)
    end
    area = get_area(corners)
    inside = get_inside(area, border_len)
    return inside + border_len
end

@show part1(lines)
@show part2(lines)