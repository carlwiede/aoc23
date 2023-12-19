lines = readlines("input.txt")

workflows = Dict{String, Vector{}}()
parts = Vector{Dict{Char, Int}}()

function parse_workflow(line)
    name, rest = split(line, "{")
    workflows[name] = []
    conditions = split(rest[1:end-1], ",")
    endgame = pop!(conditions)
    for condition in conditions
        cond, dest = split(condition, ":")
        var = cond[1]
        op = cond[2]
        val = parse(Int, cond[3:end])
        push!(workflows[name], (var, op, val, dest))
    end
    push!(workflows[name], ("", "", 0, endgame))
end

function parse_part(line)
    push!(parts, Dict{Char, Int}())
    cut_line = line[2:end-1]
    for ass in split(cut_line, ",")
        last(parts)[ass[1]] = parse(Int, ass[3:end])
    end
end

function value_of_part(part)
    sum(values(part))
end

function process_part(workflow, part)
    workflow == "A" && (return value_of_part(part))
    workflow == "R" && (return 0)
    
    returnage = 0
    for condition in workflows[workflow]
        var, op, val, dest = condition
        if var == "" # Last condition 
            returnage = process_part(dest, part)
            break
        end
        if op == '<'
            if part[var] < val
                returnage = process_part(dest, part)
                break
            end
        else
            if part[var] > val
                returnage = process_part(dest, part)
                break
            end
        end
    end
    return returnage
end

function part1(input::Vector{String})::Int
    ind = 1
    for i in 1:length(input)
        ind = i
        input[i] == "" && break
        parse_workflow(input[i])
    end
    for i in ind+1:length(input)
        parse_part(input[i])
    end

    total = 0

    for part in parts
        total += process_part("in", part)
    end

    return total
end

function part2(input::Vector{String})::Int
    return 0
end

@show part1(lines)
@show part2(lines)