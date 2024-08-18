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

grid = Grid.create(5, 11)
shapes = {
    Shapes.Lonpos.Corner,
    Shapes.Lonpos.CornerBig,
    Shapes.Lonpos.Square,
    Shapes.Lonpos.I,
    Shapes.Lonpos.L,
    Shapes.Lonpos.LBig,
    Shapes.Lonpos.X,
    Shapes.Lonpos.Clip,
    Shapes.Lonpos.Zig,
    Shapes.Lonpos.Snake,
    Shapes.Lonpos.Crane,
    Shapes.Lonpos.Chocolate
}

temp_filename = "lonpos_solutions"..process_name..".txt"
file = io.open(temp_filename, "w+")

local t1 = os.clock()

print("Process number: "..process_name..
      "\nStart permutaiton: "..(start_permutation and Array.tostring(start_permutation) or "nil")..
      "\nEnd permutaiton:   "..(end_permutation   and Array.tostring(end_permutation)   or "nil")..
      "\nStarted")

for p, f in SuitablePlacements(grid, shapes, {prev_permutation = start_permutation, stop_permutation = end_permutation}) do
    file:write("{"..Array.tostring(p)..", "..Array.tostring(f).."}\n")
end
local t2 = os.clock()

print("Process "..process_name.." done in "..(t2 - t1).." secs")




file:close()
