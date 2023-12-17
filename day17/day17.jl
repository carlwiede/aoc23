lines = readlines("input.txt")

# Turn lines into cool matrix
grid = map(c -> parse(Int, c), hcat(collect.(lines)...))

function min_path(grid, allowed_range)

    # Get length of grid
    n = size(grid, 1)

    # Create mod grids
    grid_h, grid_v = fill(sum(grid), n, n), fill(sum(grid), n, n)

    # Init top left corner
    grid_h[1, 1] = grid_v[1, 1] = 0

    while true

        checksum = sum(grid_h) + sum(grid_v)

        for steps in allowed_range, pos in 1:n

            # Update v for downward, h for rightward
            if pos >= steps + 1
                grid_v[[pos], :] = min.(grid_v[[pos], :], grid_h[[pos-steps], :] + sum(grid[pos-steps+1:pos, :], dims=1))
                grid_h[:, [pos]] = min.(grid_h[:, [pos]], grid_v[:, [pos-steps]] + sum(grid[:, pos-steps+1:pos], dims=2))
            end

            # Update v for upward, h for leftward
            if pos + steps <= n
                grid_v[[pos], :] = min.(grid_v[[pos], :], grid_h[[pos+steps], :] + sum(grid[pos:pos+steps-1, :], dims=1))
                grid_h[:, [pos]] = min.(grid_h[:, [pos]], grid_v[:, [pos+steps]] + sum(grid[:, pos:pos+steps-1], dims=2))
            end

        end

        # Grids are no longer updating, we are done here
        if checksum == sum(grid_h) + sum(grid_v)
            break
        end

    end

    return min(last(grid_h), last(grid_v))
end

function part1()::Int
    return min_path(grid, 1:3)
end

function part2()::Int
    return min_path(grid, 4:10)
end

@show part1()
@show part2()