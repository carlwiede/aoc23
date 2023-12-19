lines = readlines("input.txt")

numstrings = [("one", 1), ("two", 2), ("three", 3), ("four", 4),
              ("five", 5), ("six", 6), ("seven", 7), ("eight", 8),
              ("nine", 9), ("1", 1), ("2", 2), ("3", 3), ("4", 4),
              ("5", 5), ("6", 6), ("7", 7), ("8", 8), ("9", 9)]

println(mapreduce(input_line -> parse(Int, mapreduce(f -> map(digitVal -> "$digitVal", last(reduce((x, y) -> f[2](x[1], y[1]) ? x : y, map(posTuple -> (first(posTuple[1]), posTuple[2]), filter(posInStr -> posInStr[1] !== nothing, map(ns -> (f[1](ns[1], input_line), ns[2]), numstrings)))))), *, [(findfirst, <), (findlast, >)])), +, lines))
