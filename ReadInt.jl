module ReadInt

export read_input

function read_input()::Vector{Int}
    # Open file
    file = open("input.txt", "r")

    # Read content
    file_content = read(file, String)

    # Close file
    close(file)

    # Create input array
    input_str = filter(x -> !isempty(x), split(file_content, '\n'))

    # Convert input string to ints
    input = parse.(Int, input_str)

    return input
end

end # module