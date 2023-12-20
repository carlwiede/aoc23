lines = readlines("input.txt")

using DataStructures

function part1(input::Vector{String})::Int

    signals = Queue{Tuple{Int, String, String}}()
    modules = Dict{String, Vector{Any}}()
    total_signals = [0, 0]

    # Parse input
    for line in input
        name, connections = split(line, " -> ")
        connections = split(connections, ", ")
        if first(name) == '%'
            # flip-flop
            modules[name[2:end]] = ['F', 0, connections...]
        elseif first(name) == '&'
            # conjunction
            modules[name[2:end]] = ['C', [], connections...]
        else
            # broadcaster
            modules[name] = [connections...]
        end
    end

    # Adjust conjunction inputs
    for (k, v) in modules
        k == "broadcaster" && continue
        for d in v[3:end]
            !(d in keys(modules)) && continue
            if modules[d][1] == 'C'
                push!(modules[d][2], (k, 0))
            end
        end
    end

    # Let's go
    for i in 1:1000

        # button
        total_signals[1] += 1

        # broadcaster
        for d in modules["broadcaster"]
            enqueue!(signals, (0, "broadcaster", d))
        end

        while !isempty(signals)
            sig, source, dest = dequeue!(signals)
            total_signals[sig+1] += 1
            if !(dest in keys(modules))
                continue
            end

            if modules[dest][1] == 'F'
                if !(sig == 1)
                    modules[dest][2] = modules[dest][2] == 0 ? 1 : 0
                    for d in modules[dest][3:end]
                        enqueue!(signals, (modules[dest][2], dest, d))
                    end
                end
            else
                for (i, mod) in enumerate(modules[dest][2])
                    if mod[1] == source
                        modules[dest][2][i] = (mod[1], sig)
                    end
                end
                sig_to_send = 1
                all(x -> x[2] == 1, modules[dest][2]) && (sig_to_send = 0)
                for d in modules[dest][3:end]
                    enqueue!(signals, (sig_to_send, dest, d))
                end
            end
        end
    end

    return total_signals[1] * total_signals[2]
end

function part2(input::Vector{String})::Int

    signals = Queue{Tuple{Int, String, String}}()
    modules = Dict{String, Vector{Any}}()

    # Parse input
    for line in input
        name, connections = split(line, " -> ")
        connections = split(connections, ", ")
        if first(name) == '%'
            # flip-flop
            modules[name[2:end]] = ['F', 0, connections...]
        elseif first(name) == '&'
            # conjunction
            modules[name[2:end]] = ['C', [], connections...]
        else
            # broadcaster
            modules[name] = [connections...]
        end
    end

    # Adjust conjunction inputs
    for (k, v) in modules
        k == "broadcaster" && continue
        for d in v[3:end]
            !(d in keys(modules)) && continue
            if modules[d][1] == 'C'
                push!(modules[d][2], (k, 0))
            end
        end
    end

    button_presses = 0

    # Inputs to ls
    numbers = [0, 0, 0, 0]

    # Let's go
    while true

        button_presses += 1

        # broadcaster
        for d in modules["broadcaster"]
            enqueue!(signals, (0, "broadcaster", d))
        end

        while !isempty(signals)
            sig, source, dest = dequeue!(signals)

            if !(dest in keys(modules))
                continue
            end

            if modules[dest][1] == 'F'
                if !(sig == 1)
                    modules[dest][2] = modules[dest][2] == 0 ? 1 : 0
                    for d in modules[dest][3:end]
                        enqueue!(signals, (modules[dest][2], dest, d))
                    end
                end
            else
                for (i, mod) in enumerate(modules[dest][2])
                    if mod[1] == source
                        modules[dest][2][i] = (mod[1], sig)
                        if dest == "ls" && sig == 1
                            numbers[i] == 0 && (numbers[i] = button_presses)
                            all(x -> x != 0, numbers) && return lcm(numbers) 
                        end
                    end
                end
                sig_to_send = 1
                all(x -> x[2] == 1, modules[dest][2]) && (sig_to_send = 0)
                for d in modules[dest][3:end]
                    enqueue!(signals, (sig_to_send, dest, d))
                end
            end
        end
    end
end

@show part1(lines)
@show part2(lines)