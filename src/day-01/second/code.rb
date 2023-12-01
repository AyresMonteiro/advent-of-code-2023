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

c = ""

def get_positions(str, pattern)
    str.enum_for(:scan, pattern).map { Regexp.last_match.begin(0) }
end

while c != nil do
    first = nil
    last = nil

    line = ""

    while c != "\n" do
        line += c
        c = $stdin.getc
    end

    all_positions = numbers.map do |number|
        num = numbers.index(number).to_s

        literal_positions = get_positions(line, number).map do |position|
            [num, position]
        end
        
        positions = get_positions(line, num).map do |position|
            [num, position]
        end

        concated = literal_positions.concat(positions)

        concated.sort! { |a, b| a[1] <=> b[1] }

        concated
    end

    all_positions = all_positions.flatten(1)
    
    all_positions.sort! { |a, b| a[1] <=> b[1] }

    first = all_positions[0][0].to_s
    last = all_positions[all_positions.length - 1][0].to_s

    c = $stdin.getc
    
    codes.push(first + last)
end

sum = 0

codes.each do |code|
    sum += code.to_i
end

puts sum
