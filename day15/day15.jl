include("../ReadFile.jl")
lines = ReadFile.read_input()

function part1(input::Vector{String})::Int
    strings = split(input[1], ",")
    strings[end] = string(strings[end][1:end-1]) # remove pesky \r, sheesh
    mapreduce(
        str -> reduce((x, c) -> (x + Int(c)) * 17 % 256, str, init=0),
        +,
        strings
    )
end

using OrderedCollections

hashmap = Dict{Int, OrderedDict{String, Int}}()

function get_box_value(box_num)
    !isempty(hashmap[box_num]) && return sum((box_num + 1) * i * hashmap[box_num][key] for (i, key) in enumerate(keys(hashmap[box_num])))
end

function update_boxes(box_num, hash_name, op, value)
    !(box_num in keys(hashmap)) && (hashmap[box_num] = OrderedDict{String, Int}())
    op == '=' && (hashmap[box_num][hash_name] = value)
    op == '-' && delete!(hashmap[box_num], hash_name)
end

function get_hash(str)
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
    foreach(str -> get_hash(str), strings)
    mapreduce(
        box_num -> get_box_value(box_num),
        +,
        keys(hashmap),
    )
end

@show part1(lines)
@show part2(lines)