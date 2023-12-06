def read_line
    c = ""
    line = ""

    loop do 
        c = STDIN.getc
        if c == nil or c == "\n" then break end
        line += c
    end

    return line
end


def read_races
    times = read_line().split(":")[1].split(" ").map { |t| t.strip.to_i }
    distances = read_line().split(":")[1].split(" ").map { |d| d.strip.to_i }

    races = times.map.with_index { |t, i| {:time => t, :distance => distances[i]} }
end

def get_roots(a, b, c)
    delta = b * b - 4 * a * c

    if delta < 0 then return nil end

    if delta == 0 then return -b / (2 * a) end

    x1, x2 = [(-b + Math.sqrt(delta)) / (2 * a), (-b - Math.sqrt(delta)) / (2 * a)]

    [x1.floor + 1, x2.ceil - 1]    
end

def get_strategy(race)
    time = race[:time]
    distance_record = race[:distance]

    # f (x) = - x^2 + time * x

    # - x^2 + time * x > distance_record
    # - x^2 + time * x - distance_record > 0

    x1, x2 = get_roots(-1, time, -distance_record)

    (x1..x2).size
end

data = read_races

result = data.map { |race| get_strategy race }.reduce(:*)

puts result
