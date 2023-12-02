$c = ""

def read_num
    num = ""
    started = false

    loop do
        $c = $stdin.getc

        if $c != nil and $c[0].ord >= "0"[0].ord and $c[0].ord <= "9"[0].ord
            num += $c

            if !started then
                started = true
            end
        elsif started or $c == nil
            break
        end
    end

    num.to_i
end

def read_word
    word = ""
    started = false

    loop do
        $c = $stdin.getc

        if $c != nil and $c[0].ord >= "a"[0].ord and $c[0].ord <= "z"[0].ord
            word += $c

            if !started then
                started = true
            end
        elsif started
            break
        end
    end

    word
end


def read_game
    id = read_num

    red = {:total => 0, :max => 0}
    green = {:total => 0, :max => 0}
    blue = {:total => 0, :max => 0}

    while $c != "\n" and $c != nil do
        num = read_num
        word = read_word

        if word == "red"
            red[:total] += num

            if num > red[:max] then
                red[:max] = num
            end
        elsif word == "green"
            green[:total] += num

            if num > green[:max] then
                green[:max] = num
            end
            
        elsif word == "blue"
            blue[:total] += num

            if num > blue[:max] then
                blue[:max] = num
            end
        end
    end

    {
        id: id,
        red: red,
        green: green,
        blue: blue
    }
end

sum = 0

def game_is_valid?(game, num)
    game[:max] <= num
end

while $c != nil do
    game = read_game

    if game[:id] == 0 then
        break
    end

    if game_is_valid?(game[:red], 12) and game_is_valid?(game[:green], 13) and game_is_valid?(game[:blue], 14)
        sum += game[:id]
    end
end

puts sum
