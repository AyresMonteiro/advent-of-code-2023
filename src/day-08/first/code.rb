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

loop do
    line = read_line

    break if line == nil or line == ""

    current, links = line.split("=").map { |s| s.strip }

    links = links[1, links.length - 2].split(", ")

    nodes[current] = links
end

current = "AAA"
steps = 0

while current != "ZZZ" do
    instructions.each do |instruction|
        index = instruction == "L" ? 0 : 1

        current = nodes[current][index]
        steps += 1

        break if current == "ZZZ"
    end
end

puts steps