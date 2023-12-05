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
    
    seeds = Set.new

    seeds_line.split(":")[1].split(" ").each do |seed|
        if seed == "" then next end

        seeds.add seed.to_i
    end

    maps = {:seeds => seeds}

    loop do
        line = read_line

        if line == nil then break 1 end

        map_title = line.split(" ")[0]

        prev = nil

        while line != "" do
            line = read_line

            if line == nil or line == "" then break 1 end

            if maps[map_title] == nil then maps[map_title] = {} end

            destination_start, range_start, range_length = line.split(" ")

            maps[map_title][destination_start.to_i] = [range_start.to_i, range_length.to_i]
        end
    end

    maps
end

def map_range(sources, ranges)
    keys = ranges.keys().map(&:clone)
    
    keys.sort! {|a, b| a <=> b}

    mapped = {}

    sources.each do |source|
        destination_base = nil

        range = ranges.map { |d_start, range| [d_start, range] }.find do |arr|
            destination_start, range = arr

            is_in_range = source >= range[0] && source < (range[0] + range[1])

            if (is_in_range) then destination_base = destination_start end

            is_in_range
        end

        if range == nil then
            mapped[source] = source
        else
            diff = source - range[1][0]
            mapped[source] = range[0] + diff
        end
    end

    mapped
end

data = read_data

seeds_soil_rel = map_range data[:seeds], data["seed-to-soil"]

soils = Set.new seeds_soil_rel.values

soils_fertilizer_rel = map_range soils, data["soil-to-fertilizer"]

fertilizers = Set.new soils_fertilizer_rel.values

fertilizers_water_rel = map_range fertilizers, data["fertilizer-to-water"]

waters = Set.new fertilizers_water_rel.values

waters_light_rel = map_range waters, data["water-to-light"]

lights = Set.new waters_light_rel.values

lights_temperature_rel = map_range lights, data["light-to-temperature"]

temperatures = Set.new lights_temperature_rel.values

temperatures_humidity_rel = map_range temperatures, data["temperature-to-humidity"]

humidities = Set.new temperatures_humidity_rel.values

humidities_location_rel = map_range humidities, data["humidity-to-location"]

locations = Set.new humidities_location_rel.values

PP.pp locations.to_a().min
