lines = readlines("input.txt")

cache = Dict()

function get_comb(s, nums)
    cached_val = get(cache, (s, nums), -1)
    cached_val != -1 && return cached_val

    length(nums) == 0 && return all(c -> c != '#', s) ? 1 : 0

    num = nums[1]
    combs = 0

    for i in eachindex(s)
        if  i + num - 1 <= length(s) &&
            all(c -> c != '.', s[i:i+num-1]) &&
            (i + num - 1 == length(s) || s[i+num] != '#')

            combs += get_comb(s[i+num+1:end], nums[2:end])
        end

        if s[i] == '#'
            break
        end
    end

    cache[(s, nums)] = combs

    return combs
end

function solve(input::Vector{String}, times)::Int
    mapreduce(
        line -> 
        begin
            springs, groups = split(line)
            springs = join(repeat([springs], times), "?")
            groups = repeat([parse(Int, n) for n in split(groups, ",")], times)
            get_comb(springs, groups)
        end,
        +,
        input
    )
end

@show solve(lines, 1)
@show solve(lines, 5)