lines = readlines("input.txt")

function inside(point)
    min, max = 200000000000000, 400000000000000
    point[1] >= min && point[1] <= max && point[2] >= min && point[2] <= max
end

function future(pt, h1, h2)
    h1[2][1] > 0 && pt[1] < h1[1][1] && return false
    h1[2][1] < 0 && pt[1] > h1[1][1] && return false
    h1[2][2] > 0 && pt[2] < h1[1][2] && return false
    h1[2][2] < 0 && pt[2] > h1[1][2] && return false

    h2[2][1] > 0 && pt[1] < h2[1][1] && return false
    h2[2][1] < 0 && pt[1] > h2[1][1] && return false
    h2[2][2] > 0 && pt[2] < h2[1][2] && return false
    h2[2][2] < 0 && pt[2] > h2[1][2] && return false

    true
end

function part1(input::Vector{String})::Int

    hailstones::Vector{Tuple{Vector{Int}, Vector{Int}}} = []
    for line in input
        position, velocity = split(line, " @ ")
        push!(hailstones, (map(x -> parse(Int, x), split(position, ", ")), map(x -> parse(Int, x), split(velocity, ", "))))
    end
    intersections = 0
    for i in 1:1:length(hailstones)
        for j in i+1:1:length(hailstones)
            h1, h2 = hailstones[i], hailstones[j]

            # h1 = ax + c
            m = h1[2][2] / h1[2][1]
            a = m
            c = h1[1][2] - m * h1[1][1]

            # h2 = bx + d
            m = h2[2][2] / h2[2][1]
            b = m
            d = h2[1][2] - m * h2[1][1]

            a == b && continue
            
            pt = ((d-c)/(a-b),a*((d-c)/(a-b))+c)

            inside(pt) && future(pt, h1, h2) && (intersections += 1)
        end
    end
    intersections
end

function part2(input::Vector{String})::Int
    return 0
end

@show part1(lines)
@show part2(lines)