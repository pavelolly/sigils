require "DeepCopy"
require "Matrix"

Grid = {}

function Grid.create(rows, cols)
    assert(math.type(rows) == "integer" and math.type(cols) == "integer", "Grid.create: rows and cols must be integers")

    local grid
    grid = Matrix.create(rows, cols, ".")
    -- const fields
    grid.TotalArea    = rows * cols
    grid.DefaultLabel = "."
    grid.InitialLabel = "1"

    -- these may change
    grid.FreeArea     = grid.TotalArea
    grid.CurrentLabel = grid.InitialLabel

    -- these are "member functions" because i probably want them different in different grids in future
    function grid.nextLabel(grid)
        grid.CurrentLabel = utf8.char(utf8.codepoint(grid.CurrentLabel) + 1)
        return grid.CurrentLabel
    end

    function grid.prevLabel(grid)
        if grid.CurrentLabel ~= grid.InitialLabel then
            grid.CurrentLabel = utf8.char(utf8.codepoint(grid.CurrentLabel) - 1)
        end
        return grid.CurrentLabel
    end

    return setmetatable(grid, {__eq = Grid.haveSamePlacement, print = Grid.print})
end

function Grid.valid(grid)
    local res, msg = Matrix.valid(grid)
    if not res then
        return false, "grid's matrix invalid: "..msg
    end
    if not grid.TotalArea then
        return false, "grid.TotalArea is nil"
    end 
    if not grid.DefaultLabel then
        return false, "grid.DefaultLabel is nil"
    end 
    if not grid.InitialLabel then
        return false, "grid.InitialLabel is nil"
    end 
    if not grid.FreeArea then
        return false, "grid.FreeArea is nil"
    end 
    if not grid.CurrentLabel then
        return false, "grid.CurrentLabel is nil"
    end
    if not grid.nextLabel then
        return false, "grid.nextLabel is nil"
    end 
    if not grid.prevLabel then
        return false, "grid.prevLabel is nil"
    end
    return true
end

function Grid.assertValidArg(arg, func_name, arg_number)
    AssertValidArg(Grid.valid, arg, func_name, arg_number)
end

function Grid.print(grid)
    Matrix.print(grid)
    print("TotalArea:",    grid.TotalArea)
    print("FreeArea:",     grid.FreeArea)
    print("CurrentLabel:", grid.CurrentLabel)
end

function Grid.clear(grid)
    Matrix.fill(grid, grid.DefaultLabel)
    grid.FreeArea     = grid.TotalArea
    grid.CurrentLabel = grid.InitialLabel
end

function Grid.haveSamePlacement(grid, other)
    -- assert(Istable2D(grid) and IsTable2D(other))

    if #grid ~= #other or #grid[1] ~= #other[1] then
        return false
    end

    local labels_map = {}
    for i = 1, #grid do
        for j = 1, #grid[1] do
            local label1 = grid[i][j]
            local label2 = other[i][j]

            local label_mapped = labels_map[label1]
            if label_mapped and label2 ~= label_mapped then
                return false
            else
                labels_map[label1] = label2
            end
        end
    end
    return true
end