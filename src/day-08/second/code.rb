def read_line
    c = ""
    line = ""

    loop do
        c = STDIN.getc
        break if c == "\n" or c == nil
        line += c
    end

    line
end

instructions = read_line.split("")

read_line

nodes = {}

current_points = []

loop do
    line = read_line

    break if line == nil or line == ""

    current, links = line.split("=").map { |s| s.strip }

    links = links[1, links.length - 2].split(", ")

    nodes[current] = links

    if current.end_with?("A")
        current_points.push current
    end
end

steps = current_points.map { |_| 0 }

finished = false

while !finished do
    instructions.each do |instruction|
        index = instruction == "L" ? 0 : 1

        next_points = []

        current_points.each.with_index do |current, i|
            if current.end_with?("Z")
                next_points.push current
            else
                steps[i] += 1
                next_points.push nodes[current][index]
            end
        end

        current_points = next_points
        
        finished = current_points.all? { |current| current.end_with?("Z") }

        break if finished 
    end
end

puts steps.reduce(:lcm)
