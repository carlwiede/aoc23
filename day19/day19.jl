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
            break;
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

possible::Vector{Any} = []

function check(workflow, combs)
    workflow == "R" && return
    workflow == "A" && (push!(possible, combs); return)
    for cond in workflows[workflow]
        var, op, val, dest = cond
        var == "" && (check(dest, combs); return)
        if op == '<'
            if combs[var][1] < val
                bababooey = deepcopy(combs)
                bababooey[var] = (bababooey[var][1], min(bababooey[var][2], val-1))
                check(dest, bababooey)
                if combs[var][2] >= val
                    combs[var] = (val, combs[var][2])
                else
                    return
                end
            end
        else
            if combs[var][2] > val
                bababooey = deepcopy(combs)
                bababooey[var] = (max(val+1, bababooey[var][1]), bababooey[var][2])
                check(dest, bababooey)
                if combs[var][1] <= val
                    combs[var] = (combs[var][1], val)
                else
                    return
                end
            end
        end
    end
end

function part2(input::Vector{String})::Int
    combinations = Dict{}('x' => (1, 4000), 'm' => (1, 4000), 'a' => (1, 4000), 's' => (1, 4000))
    check("in", combinations)
    total = 0
    @show possible
    for d in possible
        x, m, a, s = d['x'], d['m'], d['a'], d['s']
        total += (x[2]-x[1]+1)*(m[2]-m[1]+1)*(a[2]-a[1]+1)*(s[2]-s[1]+1)
    end
    return total
end

@show part1(lines)
@show part2(lines)