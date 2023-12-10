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

def get_diff_matrix
    line = read_line

    if line == "" then
        return []
    end

    numbers = line.split(" ").map { |s| s.strip.to_i }.reverse

    diff_matrix = [numbers]

    i = 1
    j = 1

    loop do
        if diff_matrix[i] == nil then
            diff_matrix[i] = []
        end

        past = diff_matrix[i - 1]

        diff = past[j] - past[j - 1]
        diff_matrix[i].push diff

        correct_length = diff_matrix[i].length == past.length - 1

        all_equal = diff_matrix[i].all? { |n| n == diff_matrix[i][0] }

        if correct_length and all_equal then
            break 
        elsif correct_length and not all_equal then
            i += 1
            j = 1
            next
        end

        j += 1
    end

    diff_matrix
end

def get_next(matrix, row)
    if row == matrix.length then
        return 0
    end

    return matrix[row][matrix[row].length - 1] + get_next(matrix, row + 1)
end

sum = 0

loop do
    m = get_diff_matrix

    if m.length == 0 then
        break
    end

    sum += get_next m, 0
end

puts sum
