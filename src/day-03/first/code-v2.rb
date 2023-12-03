$c = ""

Point = Struct.new(:x, :y) do
end

def read_matrix
    numbers = [[]]
    lines = []
    text_symbols = []

    num = ""
    start_point = nil
    end_point = nil
    line = ""
    started = false

    i = 0
    j = 0

    loop do
        $c = $stdin.getc

        if $c == "\n" or $c == nil then
            if line != "" then
                lines.push(line)
                line = ""
            end

            if started then
                numbers[j].push({:num => num.to_i, :start => start_point, :end => Point.new(i - 1, j), :already_picked => false})
                num = ""
            end

            i = 0
            j += 1
            numbers.push([])

            if $c == nil then
                break
            end

            next
        end

        line += $c

        if $c[0].ord >= "0"[0].ord and $c[0].ord <= "9"[0].ord
            num += $c

            if !started then
                started = true
                start_point = Point.new(i, j)
            end
        elsif started
            numbers[j].push({:num => num.to_i, :start => start_point, :end => Point.new(i - 1, j), :already_picked => false})
            num = ""
            
            started = false
        end

        if not ($c[0].ord >= "0"[0].ord and $c[0].ord <= "9"[0].ord) and $c != nil and $c != "\n" and $c != "." then
            text_symbols.push({:symbol => $c, :point => Point.new(i, j)})
        end

        i += 1
    end

    {
        :numbers => numbers,
        :lines => lines,
        :text_symbols => text_symbols
    }
end

m = read_matrix

sum = 0

m[:text_symbols].each do |s|
    min_x = s[:point][:x] - 1
    max_x = s[:point][:x] + 1
    min_y = s[:point][:y] - 1
    max_y = s[:point][:y] + 1

    filter_numbers = Proc.new do |n| 
        if n[:already_picked] then
            next false
        end

        start = n[:start]
        ending = n[:end]

        if (ending[:x] < min_x) or (start[:x] > max_x) then
            next false
        end
        
        n[:already_picked] = true

        true
    end

    numbers = [
        m[:numbers][min_y > -1 ? min_y : 0].select(&filter_numbers),
        m[:numbers][s[:point][:y]].select(&filter_numbers),
        m[:numbers][max_y < m[:numbers].length ? max_y : m[:numbers].length].select(&filter_numbers)
    ].flatten

    sum += numbers.map { |n| n[:num] }.reduce(:+)
end

puts sum
