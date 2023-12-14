include("../ReadFile.jl")
lines = ReadFile.read_input()

function part1(input::Vector{String})::Int
    
    char_array = [filter(c -> c != '\r', collect(str)) for str in input]

    # Tilt north
    for x in 1:1:length(char_array[1])
        last_blocker = (0, x)
        for y in 1:1:length(char_array)
            if char_array[y][x] == '.'
                continue
            elseif char_array[y][x] == '#'
                last_blocker = (y, x)
            elseif char_array[y][x] == 'O'
                last_blocker = (last_blocker[1]+1, last_blocker[2])
                char_array[y][x] = '.'
                char_array[last_blocker[1]][last_blocker[2]] = 'O'
            end
        end
    end

    # Count
    total = 0
    for y in 1:1:length(char_array)
        for x in 1:1:length(char_array[1])
            if char_array[y][x] == 'O'
                total += 1 * (length(char_array)-y+1)
            end
        end
    end

    return total
end

function part2(input::Vector{String})::Int
    return 0
end

@show part1(lines)
@show part2(lines)