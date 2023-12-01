include("../ReadString.jl")
input = ReadString.read_input()

function getValue(input::String)::Int

    firstStringValue = 0
    firstStringPos = 1000

    lastStringValue = 0
    lastStringPos = 0

    firstDigit = 0
    firstDigitPos = 1000

    lastDigit = 0
    lastDigitPos = 0

    strNumbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

    for (index, str) in enumerate(strNumbers)
        find = findfirst(str, input)
        if find !== nothing && first(find) < firstStringPos
            firstStringValue = index
            firstStringPos = first(find)
        end
    end

    for (index, str) in enumerate(strNumbers)
        find = findlast(str, input)
        if find !== nothing && first(find) > lastStringPos
            lastStringValue = index
            lastStringPos = first(find)
        end
    end

    for (index, ch) in enumerate(input)
        if (ch > '0' && ch <= '9')
            firstDigitPos = index
            firstDigit = ch
            break
        end
    end

    for (index, ch) in enumerate(input)
        if (ch > '0' && ch <= '9')
            lastDigitPos = index
            lastDigit = ch
        end
    end

    firstValue = 0
    lastValue = 0

    if firstDigitPos < firstStringPos
        firstValue = parse(Int, firstDigit)
    else
        firstValue = firstStringValue
    end

    if lastDigitPos > lastStringPos
        lastValue = parse(Int, lastDigit)
    else
        lastValue = lastStringValue
    end

    valueStr = "$firstValue$lastValue"
    return parse(Int, valueStr)

end

println(mapreduce(x->getValue(x), +, input))
