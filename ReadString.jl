module ReadString

export read_input

function read_input()::Vector{String}
    # Open file
    file = open("input.txt", "r")

    # Read content
    file_content = read(file, String)

    # Close file
    close(file)

    # Create input array
    input_str = split(file_content, '\n')

    return input_str
end

end # module