require "array"
require "matrix"
require "permutations"
require "shapes"

function GetNewGrid(rows, cols)
    local grid = Matrix.create(rows, cols)
    grid.TotalArea = rows * cols
    grid.FreeArea = grid.TotalArea
    grid.ShapeLabel = "1"

    function grid.nextLabel(grid)
        grid.ShapeLabel = utf8.char(utf8.codepoint(grid.ShapeLabel) + 1)
        return grid.ShapeLabel
    end

    function grid.prevLabel(grid)
        if grid.ShapeLabel ~= "1" then
            grid.ShapeLabel = utf8.char(utf8.codepoint(grid.ShapeLabel) - 1)
        end
        return grid.ShapeLabel
    end

    function grid.printInfo(grid)
        Matrix.print(grid)
        print("TotalArea", grid.TotalArea)
        print("FreeArea", grid.FreeArea)
        print("ShapeLabel", grid.ShapeLabel)
    end

    function grid.clear(grid)
        Matrix.fill(grid, 0)
        grid.FreeArea = grid.TotalArea
        grid.ShapeLabel = "1"
    end

    return grid
end

function RemoveLastShape(grid)
    local count = 0
    grid:prevLabel()
    for i = 1, #grid do
        for j = 1, #(grid[1]) do
            if grid[i][j] == grid.ShapeLabel then
                grid[i][j] = 0
                count = count + 1
            end
        end
    end
    grid.FreeArea = grid.FreeArea + count
end

function PlaceShape(grid, shape, row, col)
    row = row or 1
    col = col or 1

    local count = 0
    for i, shape_row in ipairs(shape) do
        for j, elem in ipairs(shape_row) do
            local grid_row = row + i - 1
            local grid_col = col + j - 1

            if (not Matrix.inBounds(grid, grid_row, grid_col)) or (grid[grid_row][grid_col] ~= 0 and elem ~= 0) then
                -- pretend like you have placed some shape
                grid:nextLabel()
                grid.FreeArea = grid.FreeArea - count
                -- then remove it
                RemoveLastShape(grid)
                return false
            end
            
            if elem ~= 0 then
                grid[grid_row][grid_col] = grid.ShapeLabel
                count = count + 1
            end
        end
    end

    grid:nextLabel()
    grid.FreeArea = grid.FreeArea - count
    return true
end

function NextFreeSpot(grid)
    for i, row in ipairs(grid) do
        for j, elem in ipairs(row) do
            if elem == 0 then return i, j end
        end
    end
    return nil
end

function PlaceShapes(grid, shapes)
    if #shapes * Shapes.Area ~= grid.FreeArea then return false end
    for i, shape in ipairs(shapes) do
        row, col = NextFreeSpot(grid)
        if not row then return false end
        local shape_col = 1
        while shape[1][shape_col] == 0 do
            shape_col = shape_col + 1
            col = col > 0 and col - 1 or 0
        end
        if not PlaceShape(grid, shape, row, col) then return false end
    end
    return true
end

function RotateShapes(shapes)
    local rotations
    shapes = Array.copy(shapes)

    local rotate = function(shape, n)
        local rshape = Matrix.rotate(shape, n)
        rshape.nrotations = shape.nrotations
        return rshape
    end

    return function()
        if not rotations then
            rotations = {}
            for i = 1,#shapes do
                rotations[i] = 0
            end
        else
            for i = #shapes,1,-1 do
                if rotations[i] < shapes[i].nrotations - 1 then
                    rotations[i] = rotations[i] + 1
                    shapes[i] = rotate(shapes[i], 1)
                    break
                end
                -- rotate back to initial state
                shapes[i] = rotate(shapes[i], -rotations[i])
                rotations[i] = 0

                if i == 1 then
                    rotations = nil
                end
            end
        end

        if (not rotations) or (not next(rotations)) then
            return nil
        else
            return shapes, rotations
        end
    end
end

function PlaceShapesRotated(grid, shapes, rotations)
    if #shapes * Shapes.Area ~= grid.FreeArea then return false end

    local rshapes = Array.copy(shapes)
    for i, nrot in ipairs(rotations) do
        rshapes[i] = Matrix.rotate(rshapes[i], nrot)
    end

    return PlaceShapes(grid, rshapes)
end

function FindAnyRotation(grid, shapes)
    if #shapes * Shapes.Area ~= grid.FreeArea then return false end

    local count = 1
    for rotated_shapes, rotations in RotateShapes(shapes) do
        grid:clear()
        local res = PlaceShapes(grid, rotated_shapes)
        if res then
            -- io.write("Rotations enumerated:", count, "\n")
            return rotations
        end
        count = count + 1
    end
    -- io.write("Rotations enumerated:", count, "\n")
    return nil
end

function FindAnyPlacement(grid, shapes)
    if #shapes * Shapes.Area ~= grid.FreeArea then return false end

    local count = 1
    for order in permutations(shapes) do
        grid:clear()
        local rotation = FindAnyRotation(grid, order)
        if rotation then
            io.write("Pemutaions enumerated:", count, "\n")
            return order, rotation
        end
        count = count + 1
    end
    io.write("Pemutaions enumerated:", count, "\n")
    return nil
end
