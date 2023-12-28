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

    hs::Vector{Tuple{Vector{Int}, Vector{Int}}} = []
    for line in input
        p, v = split(line, " @ ")
        p = split(p, ", ") .|> val -> parse(Int, val)
        v = split(v, ", ") .|> val -> parse(Int, val)
        push!(hs, (p, v))
    end

    n = length(hs)
    m = min(n, 10)
    b = [hs[i][1][1] - hs[i%m + 1][1][1] for i in 1:m]
    b[m] = hs[m][1][2] - hs[1][1][2]

    bound1 = 500
    bound2 = 0

    for vxs in [-bound1:bound2, bound2:bound1], vys in [-bound1:bound2, bound2:bound1]
        for vx in vxs, vy in vys
            arr = zeros(m,m)
            for i in 1:m-1
                arr[i, i] = vx - hs[i][2][1]
                arr[i, i%m + 1] = hs[i%m + 1][2][1] - vx
            end

            arr[m, m] = vy - hs[m][2][2]
            arr[m, 1] = hs[1][2][2] - vy

            try
                t = arr\b

                vz = (hs[1][1][3] - hs[2][1][3] + t[1] * hs[1][2][3] - t[2] * hs[2][2][3]) / (t[1] - t[2])

                bababooey = true

                for i in 2:m
                    vz2 = (hs[i][1][3] - hs[i%m + 1][1][3] + t[i] * hs[i][2][3] - t[i%m + 1] * hs[i%m + 1][2][3]) / (t[i] - t[i%m + 1])
                    bababooey &= vz ≈ vz2
                    if !bababooey
                        break
                    end
                end

                if bababooey
                    px = hs[1][1][1] + t[1] * (hs[1][2][1] - vx)
                    py = hs[1][1][2] + t[1] * (hs[1][2][2] - vy)
                    pz = hs[1][1][3] + t[1] * (hs[1][2][3] - vz)

                    return round(px+py+pz)
                end
            catch _
            end
        end
    end

    return 0
end

#@show part1(lines)
@show part2(lines)