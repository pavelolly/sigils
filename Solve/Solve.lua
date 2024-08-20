require "Sigils"

function ParseArray(str)
    local pattern = "{(.*)}"
    local numbers_list = string.match(str, pattern)
    if not numbers_list then
        error("failed to match pattern '"..pattern.."' with str '"..str.."'")
    end

    local array = {}
    for n in string.gmatch(numbers_list, "%d+") do
        table.insert(array, tonumber(n))
    end

    return array
end

function ParseArg(arg)
    if arg == nil or string.match(arg, "%s*nil%s*") then
        return nil
    end
    return ParseArray(arg)
end

process_name      = arg[1]
start_permutation = ParseArg(arg[2])
end_permutation   = ParseArg(arg[3])

filename = "solutions_"..process_name..".txt"
file = io.open(filename, "w+")

local t1 = os.clock()

print("Process number: "..process_name.."\n"..
      "Start permutaiton: "..(start_permutation and Array.tostring(start_permutation) or "nil").."\n"..
      "End permutaiton:   "..(end_permutation   and Array.tostring(end_permutation)   or "nil").."\n"..
      "Started")


-- grid and shapes must be defined outside this file
for p, f in SuitablePlacements(grid, shapes, {prev_permutation = start_permutation, stop_permutation = end_permutation}) do
    file:write("{"..Array.tostring(p)..", "..Array.tostring(f).."}\n")
end
local t2 = os.clock()

print("Process "..process_name.." done in "..(t2 - t1).." secs")

file:close()
