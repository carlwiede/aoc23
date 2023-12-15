include("../ReadFile.jl")
lines = ReadFile.read_input()

function get_hash(str)
    current_value = 0
    for c in str
        current_value += Int(c)
        current_value *= 17
        current_value %= 256
    end
    return current_value
end

function part1(input::Vector{String})::Int
    strings = split(input[1], ",")
    strings[end] = string(strings[end][1:end-1]) # remove pesky \r, sheesh
    
    mapreduce(
        str -> get_hash(str),
        +,
        strings
    )
end

using OrderedCollections

hashmap = OrderedDict{Int, OrderedDict{String, Int}}()

function get_box_value(box_num)
    box_value = 0
    for (i, key) in enumerate(keys(hashmap[box_num]))
        box_value += (box_num+1)*i*hashmap[box_num][key]
    end
    return box_value
end

function update_boxes(box_num, hash_name, op, value)
    if !(box_num in keys(hashmap))
        hashmap[box_num] = OrderedDict{String, Int}()
    end
    if op == '='
        hashmap[box_num][hash_name] = value        
    else
        delete!(hashmap[box_num], hash_name)
    end
end

function get_hash2(str)
    current_value = 0
    hash_name = ""
    for c in str
        if c == '=' 
            update_boxes(current_value, hash_name, c, parse(Int, str[end]))
            return
        elseif c == '-' 
            update_boxes(current_value, hash_name, c, -1)
            return
        end
        current_value += Int(c)
        current_value *= 17
        current_value %= 256
        hash_name *= c
    end
end

function part2(input::Vector{String})::Int
    strings = split(input[1], ",")
    strings[end] = string(strings[end][1:end-1]) # remove pesky \r, sheesh
    foreach(str -> get_hash2(str), strings)
    mapreduce(
        box_num -> get_box_value(box_num),
        +,
        keys(hashmap),
    )
end

@show part1(lines)
@show part2(lines)