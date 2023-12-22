lines = readlines("input.txt")

grid = Dict{Tuple{Int, Int, Int}, Int}() # (x, y, z) -> 0 empty / 1 blocked

function settled(block)::Bool
    settled = false
    for x in block[1][1]:block[2][1], y in block[1][2]:block[2][2]
        if min(block[1][3], block[2][3]) == 1 || get(grid, (x, y, min(block[1][3], block[2][3])-1), 0) == 1
            settled = true
            break
        end
    end
    return settled
end

function part1(input::Vector{String})::Int
    
    # Initialize
    blocks = [(map(c -> parse(Int, c), split(split(line, '~')[1], ',')), map(c -> parse(Int, c), split(split(line, '~')[2], ','))) for line in input]
    for block in blocks
        for x in block[1][1]:block[2][1], y in block[1][2]:block[2][2], z in block[1][3]:block[2][3]
            grid[(x, y, z)] = 1
        end
    end

    # Settle the blocks
    while !all(block -> settled(block), blocks)
        for i in 1:1:length(blocks)
            if settled(blocks[i])
                continue
            end
            for x in blocks[i][1][1]:blocks[i][2][1], y in blocks[i][1][2]:blocks[i][2][2], z in blocks[i][1][3]:blocks[i][2][3]
                grid[(x, y, z)] = 0
                grid[(x, y, z-1)] = 1
            end
            blocks[i][1][3] -= 1
            blocks[i][2][3] -= 1
        end
    end

    removable = 0

    # Count possibilities
    for block in blocks
        for x in block[1][1]:block[2][1], y in block[1][2]:block[2][2], z in block[1][3]:block[2][3]
            grid[(x, y, z)] = 0
        end
        if all(block -> settled(block), blocks)
            removable += 1
        end
        for x in block[1][1]:block[2][1], y in block[1][2]:block[2][2], z in block[1][3]:block[2][3]
            grid[(x, y, z)] = 1
        end
    end

    return removable
end

function removal_chain(block)::Int
    chain = 0
    for x in block[1][1]:block[2][1], y in block[1][2]:block[2][2], z in block[1][3]:block[2][3]
        grid[(x, y, z)] = 0
    end
    for block in blocks
        if !settled(block) && get(grid, (block[1][1], block[1][2], block[1][3]), 0) == 1
            chain = 1 + removal_chain(block)
            break
        end
    end
    for x in block[1][1]:block[2][1], y in block[1][2]:block[2][2], z in block[1][3]:block[2][3]
        grid[(x, y, z)] = 1
    end
    return chain
end

function part2(input::Vector{String})::Int
        # Initialize
        global blocks = [(map(c -> parse(Int, c), split(split(line, '~')[1], ',')), map(c -> parse(Int, c), split(split(line, '~')[2], ','))) for line in input]        
        for block in blocks
            for x in block[1][1]:block[2][1], y in block[1][2]:block[2][2], z in block[1][3]:block[2][3]
                grid[(x, y, z)] = 1
            end
        end
    
        # Settle the blocks
        while !all(block -> settled(block), blocks)
            for i in 1:1:length(blocks)
                if settled(blocks[i])
                    continue
                end
                for x in blocks[i][1][1]:blocks[i][2][1], y in blocks[i][1][2]:blocks[i][2][2], z in blocks[i][1][3]:blocks[i][2][3]
                    grid[(x, y, z)] = 0
                    grid[(x, y, z-1)] = 1
                end
                blocks[i][1][3] -= 1
                blocks[i][2][3] -= 1
            end
        end
        
        # Find biggest
        chain = 0
        for (i, block) in enumerate(blocks)
            chain += removal_chain(block)
        end
        return chain
end

@show part1(lines)
blocks = []
grid = Dict{Tuple{Int, Int, Int}, Int}() # (x, y, z) -> 0 empty / 1 blocked
@show part2(lines)