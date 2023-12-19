lines = readlines("input.txt")

positions = []
values = []

function is_part(num)::Bool
    max_y = 140
    max_x = 140
    y = num[2]
    x = num[3]
    for x in x-1:x+1
        for y in y-1:y+1
            if !(x > 0 && x <= max_x && y > 0 && y <= max_y)
                continue
            end
            if !isdigit(lines[y][x]) && lines[y][x] != '.'
                return true
            end
        end
    end
    return false
end

function is_gear(num, total)::Int
    y = num[2]
    x = num[3]
    for i in x-1:x+1
        for j in y-1:y+1
            if !(i > 0 && i <= 140 && j > 0 && j <= 140)
                continue
            end
            if !isdigit(lines[j][i]) && lines[j][i] !== '.'
                if lines[j][i] == '*'
                    for (k, pos) in enumerate(positions)
                        if pos == (j, i)
                            return total * values[k]
                        end
                    end
                    push!(positions, (j, i))
                    push!(values, total)
                    return -1
                end
            end
        end
    end
    return 0
end

function validate_nums(nums::Vector)
    for num in nums
        if(is_part(num))
            return parse(Int, mapreduce(
                x -> x[1],
                *,
                nums
            ))
        end
    end
    return 0
end

function validate_gears(nums::Vector)
    for num in nums
        val = is_gear(num, parse(Int, mapreduce(
            x -> x[1],
            *,
            nums
        )))
        if(val == -1)
            return 0
        elseif(val > 0)
            return val
        end
    end
    return 0
end

function part1(input::Vector{String})::Int
    total = 0
    nums = []
    for (i, line) in enumerate(input)
        for (j, ch) in enumerate(line)
            if !isdigit(ch) && nums != []
                total += validate_nums(nums)
                nums = []
            elseif isdigit(ch)
                push!(nums, (ch, i, j))
            end
        end
    end
    return total
end

function part2(input::Vector{String})::Int
    total = 0
    nums = []
    for (i, line) in enumerate(input)
        for (j, ch) in enumerate(line)
            if !isdigit(ch) && nums != []
                total += validate_gears(nums)
                nums = []
            elseif isdigit(ch)
                push!(nums, (ch, i, j))
            end
        end
    end
    return total
end

println(part1(lines))
println(part2(lines))