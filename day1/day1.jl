include("../ReadString.jl")
lines = ReadString.read_input()

function part1(input::Vector{String})::Int
    return mapreduce(
        line -> parse(Int, "$(line[1])$(line[end])"),
        +, 
        map(
            line -> filter(c -> isdigit(c), line),
            input
        )
    )
end

function part2(input::Vector{String})::Int
    rep = [
        ("one","one1one"),
        ("two","two2two"),
        ("three","three3three"),
        ("four","four4four"),
        ("five","five5five"),
        ("six","six6six"),
        ("seven","seven7seven"),
        ("eight","eight8eight"),
        ("nine","nine9nine"),
    ]
    return part1(
        map(
            line -> foldl(
                (s,p) -> replace(s, p[1] => p[2]),
                rep, init=line
            ),
            input
        )
    )
end

println(part1(lines))
println(part2(lines))