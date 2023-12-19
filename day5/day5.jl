lines = readlines("input.txt")

function part1(input::Vector{String})::Int
    # Create get seeds
    seeds = map(x -> parse(Int, x), split(split(input[1], ": ")[2], " "))

    # Create tables
    tables = []
    map_counter = 0
    for line in input[2:end]
        if length(line) == 0
            push!(tables, [])
            map_counter += 1
        elseif endswith(line, "map:")
        else
            # Crunch numbers
            push!(tables[map_counter], map(x->parse(Int, x), split(line, " ")))
        end
    end

    # Find location
    lowest = Inf

    for seed in seeds
        next = seed
        for map in tables
            for nums in map
                if next >= nums[2] && next < nums[2] + nums[3]
                    next += nums[1] - nums[2]
                    break
                end
            end
        end
        lowest = min(lowest, next)
    end

    return lowest
end

function get_ranges(ranges, map)
    A = []
    for (dest, src, sz) in map
        src_end = src+sz
        NR = []
        for (st,ed) in ranges
            before = (st,min(ed,src))
            inter = (max(st, src), min(src_end, ed))
            after = (max(src_end, st), ed)
            if before[2] > before[1]
                push!(NR, before)
            end
            if inter[2] > inter[1]
                push!(A, (inter[1]-src+dest, inter[2]-src+dest))
            end
            if after[2] > after[1]
                push!(NR, after)
            end
        end
        ranges = NR
    end
    return vcat(A, ranges)
end

function part2(input::Vector{String})::Int
        # Create get seeds
        seeds = map(x -> parse(Int, x), split(split(input[1], ": ")[2], " "))

        # Create tables
        tables = []
        map_counter = 0
        for line in input[2:end]
            if length(line) == 0
                push!(tables, [])
                map_counter += 1
            elseif !endswith(line, "map:")
                push!(tables[map_counter], map(x->parse(Int, x), split(line, " ")))
            end
        end

        # Find location
        seedpairs = [(seeds[i], seeds[i+1]) for i in 1:2:length(seeds)-1]

        mini = []
        for pair in seedpairs
            r = [(pair[1], pair[1]+pair[2])]

            for map in tables
                r = get_ranges(r, map)
            end

            push!(mini, minimum(x -> x[1], r))
        end

        return minimum(mini)
end

println(part1(lines))
println(part2(lines))