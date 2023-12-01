codes = []

c = "a"

while c != nil do
    first = nil
    last = nil

    while c != "\n" do
        is_number = c[0].ord >= "0"[0].ord && c[0].ord <= "9"[0].ord

        if is_number and first == nil then
            first = c
        end
        
        if is_number then
            last = c
        end

        c = $stdin.getc
    end

    codes.push(first + last)

    c = $stdin.getc
end

sum = 0

codes.each {|code| sum += code.to_i }

puts sum
