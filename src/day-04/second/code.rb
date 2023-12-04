require 'set'

def read_line
    line = ""

    loop do
        c = STDIN.getc
        if c == nil or c == "\n" then break end
        line += c
    end

    line
end

def read_scratchcard
    line = read_line

    if line == "" then return -1 end

    first, second = line.split ":"

    id = first.split(" ").last.to_i

    winners_raw, numbers = second
        .split("|")
        .map { |x| x.strip }
    
    winners = Set.new nil

    winners_raw.split(" ").each do |x|
        num = x.to_i

        if num == 0 then next end
        
        winners.add num
    end

    sum = 0

    numbers.split(" ").each do |x|
        num = x.to_i

        if num == 0 then next end

        if winners.include? num then
            sum += 1
        end
    end

    sum
end

cumulative_copies = []
i = 0

loop do
    if (cumulative_copies[i] == nil) then
        cumulative_copies.push(1)
    else
        cumulative_copies[i] += 1
    end

    instances = read_scratchcard

    if instances == -1 then break end

    for j in 0...instances do
        if cumulative_copies[i + j + 1] == nil then
            cumulative_copies.push(0)
        end

        if instances == 0 then break end

        cumulative_copies[i + j + 1] += cumulative_copies[i]
    end

    i += 1
end

total = 0

for j in 0...i do
    unless cumulative_copies[j] == nil then
        total += cumulative_copies[j]
    end
end

puts total
