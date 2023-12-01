include("../ReadString.jl")
input = ReadString.read_input()

numstrings = [("one", 1), ("two", 2), ("three", 3), ("four", 4),
              ("five", 5), ("six", 6), ("seven", 7), ("eight", 8),
              ("nine", 9), ("1", 1), ("2", 2), ("3", 3), ("4", 4),
              ("5", 5), ("6", 6), ("7", 7), ("8", 8), ("9", 9)]

println(mapreduce(x->parse(Int,mapreduce(f->map(x->"$x", last(reduce((x, y) -> x[1] < y[1] ? x : y, map(x->(first(x[1]), x[2]), filter(x->x[1] !== nothing, map(ns -> (f.(ns[1], x), ns[2]), numstrings)))))), *, [findfirst, findlast])), +, input))
