require "DeepCopy"
require "Matrix"

Grid = {}

function Grid.create(rows, cols)
    local grid = Matrix.create(rows, cols, ".")
    grid.TotalArea = rows * cols
    grid.FreeArea  = grid.TotalArea
    grid.DefaultLabel = "."
    grid.InitialLabel = "1"
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

    return setmetatable(grid, {__eq = Matrix.equals, print = Grid.print})
end

function Grid.print(grid)
    Matrix.print(grid)
    print("TotalArea:", grid.TotalArea)
    print("FreeArea:", grid.FreeArea)
    print("CurrentLabel:", grid.CurrentLabel)
end

function Grid.clear(grid)
    Matrix.fill(grid, grid.DefaultLabel)
    grid.FreeArea = grid.TotalArea
    grid.CurrentLabel = grid.InitialLabel
end

function Grid.haveSamePlacement(grid1, grid2)
    if #grid1 ~= #grid2 or #grid1[1] ~= #grid2[1] then
        return false
    end

    local labels_map = {}
    for i = 1, #grid1 do
        for j = 1, #grid1[1] do
            local label1 = grid1[i][j]
            local label2 = grid2[i][j]

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