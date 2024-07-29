require "Matrix"

Grid = {}

function Grid.create(rows, cols)
    local grid = Matrix.create(rows, cols, ".")
    grid.Area     = rows * cols
    grid.FreeArea = grid.Area
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

    return grid
end

function Grid.print(grid)
    Matrix.print(grid)
    print("TotalArea:", grid.TotalArea)
    print("FreeArea:", grid.FreeArea)
    print("CurrentLabel:", grid.CurrentLabel)
end

function Grid.clear(grid)
    Matrix.fill(grid, grid.DefaultLabel)
    grid.FreeArea = grid.Area
    grid.CurrentLabel = grid.InitialLabel
end