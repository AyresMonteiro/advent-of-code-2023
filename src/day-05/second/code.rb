require "pp"
require "set"

def read_line
    c = ""
    line = ""

    loop do
        c = STDIN.getc
        if c == nil or c == "\n" then break end
        line += c
    end

    return line unless c == nil

    nil
end

def read_data
    seeds_line = read_line

    if seeds_line == nil then return nil end
    
    seeds = []

    prev = nil

    seeds_line.split(":")[1].split(" ").each do |seed_info|
        seed_info = seed_info.strip

        if seed_info == "" then next end

        if prev == nil then
            prev = seed_info.to_i
        else
            start = prev
            ending = prev + seed_info.to_i - 1

            seeds.push (start..ending)

            prev = nil
        end
    end

    seeds.sort! {|a, b| a.begin <=> b.begin}

    maps = {:seeds => seeds}

    loop do
        line = read_line

        if line == nil then break 1 end

        map_title = line.split(" ")[0]

        while line != "" do
            line = read_line

            if line == nil or line == "" then break 1 end

            line = line.strip

            if maps[map_title] == nil then maps[map_title] = {} end

            d_start, r_start, r_len = line.split(" ").map { |x| x.strip().to_i }

            maps[map_title][d_start] = r_start .. (r_start + r_len - 1)
        end

        # sort keys by reinserting them in order into a new hash
        unless map_title == "seeds" or maps[map_title] == nil then
            maps[map_title] = maps[map_title].keys().sort().reduce({}) do |acc, key|
                acc[key] = maps[map_title][key]
                acc
            end
        end
    end

    maps
end

def map_range(sources, ranges)
    mapped = sources.map do |source|
        intersected_ranges = ranges.map { |d_start, range| [d_start, range] }.select do |arr|
            dest_start, range = arr

            b = source.begin
            e = source.end

            rb = range.begin
            re = range.end

            b_in_range = b >= rb && b < re
            e_in_range = e >= rb && e < re

            b_in_range || e_in_range
        end

        intersections = intersected_ranges.map do |dest_start, range|
            b = source.begin
            e = source.end

            rb = range.begin
            re = range.end

            intersection_start = [b, rb].max
            intersection_end = [e, re].min

            diffb = intersection_start - rb
            diffe = intersection_end - re

            delta = re - rb

            intersected_range = intersection_start .. intersection_end
            mapped_range = dest_start + diffb .. (dest_start + delta + diffe)

            [intersected_range, mapped_range]
        end

        direct_mappings = [source]

        # get all NOT-INTERSECTED ranges from source
        intersections.each do |arr|
            range, _a  = arr

            direct_mappings = direct_mappings.map do |direct_mapping|
                b = direct_mapping.begin
                e = direct_mapping.end

                rb = range.begin
                re = range.end

                b_in_range = b >= rb && b <= re
                e_in_range = e >= rb && e <= re
                greater = b < rb && e > re

                if greater then
                    next [b..(rb - 1), (re + 1)..e]
                end
                
                if b_in_range && !e_in_range then
                    next [(re + 1)..e]
                end
                
                if !b_in_range && e_in_range then
                    next [b..(rb - 1)]
                end
                
                if !b_in_range && !e_in_range then
                    next [direct_mapping]
                end

                []
            end

            direct_mappings = direct_mappings.flatten
        end

        direct_mappings.concat intersections.map { |i| i[1] }
    end


    mapped.flatten().sort! {|a, b| a.begin <=> b.begin}
end

data = read_data

soils = map_range data[:seeds], data["seed-to-soil"]

fertilizers = map_range soils, data["soil-to-fertilizer"]

waters = map_range fertilizers, data["fertilizer-to-water"]

lights = map_range waters, data["water-to-light"]

temperatures = map_range lights, data["light-to-temperature"]

humidities = map_range temperatures, data["temperature-to-humidity"]

locations = map_range humidities, data["humidity-to-location"]

puts locations[0].begin
