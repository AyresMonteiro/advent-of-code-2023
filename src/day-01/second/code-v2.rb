numbers = [
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
]

codes = []

def read_line
    c = ""
    line = ""

    loop do
        line += c
        c = $stdin.getc

        if c == "\n" or c == nil then break end
    end

    line
end

sum = 0;

loop do
    line = read_line

    if line == "" then break end

    first = nil
    last = nil

    numbers.map do |number|
        num = numbers.index(number).to_s

        closure = Proc.new {
            |match|

            position = Regexp.last_match.begin(0)

            if position != nil then
                if first == nil or first[1] > position then
                    first = [num, position]
                end

                if last == nil or last[1] < position then
                    last = [num, position]
                end
            end
        }

        line.scan(number, &closure)
        line.scan(num, &closure)
    end

    sum += (first[0] + last[0]).to_i
end

puts sum
