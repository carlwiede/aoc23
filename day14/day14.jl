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

# Basically, find the stride, calculate what number will
# eventually end up at exactly 1000000000 (it's cyclic)
function part2(input::Vector{String})::Int
    
    total = 0
    start_cycles = 200
    end_cycles = 220
    cycle_list = Dict()
    
    for i in start_cycles:end_cycles

        char_array = [filter(c -> c != '\r', collect(str)) for str in input]
        cycles = i

        for _ in 1:1:cycles
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
            # Tilt west
            for y in 1:1:length(char_array)
                last_blocker = (y, 0)
                for x in 1:1:length(char_array[1])
                    if char_array[y][x] == '.'
                        continue
                    elseif char_array[y][x] == '#'
                        last_blocker = (y, x)
                    elseif char_array[y][x] == 'O'
                        last_blocker = (last_blocker[1], last_blocker[2]+1)
                        char_array[y][x] = '.'
                        char_array[last_blocker[1]][last_blocker[2]] = 'O'
                    end
                end
            end
            # Tilt south
            for x in 1:1:length(char_array[1])
                last_blocker = (length(char_array)+1, x)
                for y in length(char_array):-1:1
                    if char_array[y][x] == '.'
                        continue
                    elseif char_array[y][x] == '#'
                        last_blocker = (y, x)
                    elseif char_array[y][x] == 'O'
                        last_blocker = (last_blocker[1]-1, last_blocker[2])
                        char_array[y][x] = '.'
                        char_array[last_blocker[1]][last_blocker[2]] = 'O'
                    end
                end
            end
            # Tilt east
            for y in 1:1:length(char_array)
                last_blocker = (y, length(char_array[1])+1)
                for x in length(char_array[1]):-1:1
                    if char_array[y][x] == '.'
                        continue
                    elseif char_array[y][x] == '#'
                        last_blocker = (y, x)
                    elseif char_array[y][x] == 'O'
                        last_blocker = (last_blocker[1], last_blocker[2]-1)
                        char_array[y][x] = '.'
                        char_array[last_blocker[1]][last_blocker[2]] = 'O'
                    end
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
        cycle_list[i] = total

    end

    # Numerical analysis :ppp
    stride = 1
    initial_value = cycle_list[start_cycles]
    for i in 1:1:length(cycle_list)
        if cycle_list[i+start_cycles] == initial_value
            break
        end
        stride += 1
    end

    big_num = div(1000000000 - cycle_list[start_cycles], stride)
    adjustor = 1000000000 - (cycle_list[start_cycles] + big_num * stride)
    total = cycle_list[start_cycles+adjustor]

    return total
end

@show part1(lines)
@show part2(lines)