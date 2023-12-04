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
            sum = sum > 0 ? sum << 1 : 1
        end
    end

    sum
end

total = 0

loop do
    sum = read_scratchcard
    if sum == -1 then break end
    total += sum
end

puts total
