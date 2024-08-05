require "DeepCopy"
require "Matrix"
require "Permutations"

require "Grid"
require "Shapes"

function PlaceShape(grid, shape, row, col)
    if shape.Area > grid.FreeArea then
        return false
    end

    row = row or 1
    col = col or 1

    local blocks = {}
    for i, shape_row in ipairs(shape) do
        for j, elem in ipairs(shape_row) do
            if elem ~= 0 then
                local grid_row = row + i - 1
                local grid_col = col + j - 1

                if (not Matrix.inBounds(grid, grid_row, grid_col)) or grid[grid_row][grid_col] ~= grid.DefaultLabel then
                    -- undo changes
                    for i, block in ipairs(blocks) do
                        grid[block.row][block.col] = grid.DefaultLabel
                    end
                    return false
                end
                
                grid[grid_row][grid_col] = grid.CurrentLabel
    
                table.insert(blocks, {row = grid_row, col = grid_col})
            end
        end
    end

    if #blocks > 0 then
        grid:nextLabel()
        grid.FreeArea = grid.FreeArea - #blocks
        return true
    end
    
    return false
end

function NextFreeBlock(grid)
    return Matrix.find(grid, grid.DefaultLabel)
end

function PlaceShapes(grid, shapes)
    if Shapes.area(shapes) ~= grid.FreeArea then return false end
    for i, shape in ipairs(shapes) do
        row, col = NextFreeBlock(grid)
        if not row then return false end -- probably impossible to return here as it would imply that Shapes.area(shapes) ~= grid.FreeArea
                                         -- which is false already
        local shape_origin_row, shape_origin_col = Shapes.getOrigin(shape)
        if shape_origin_row then
            -- we want to place shape such that its origin is at the free block found earlier
            row = row - shape_origin_row + 1
            col = col - shape_origin_col + 1
            if not PlaceShape(grid, shape, row, col) then return false end
            -- Matrix.print(grid)
            -- print("==================")
        end
    end
    return true
end

-- you can use this in a for loop:
-- for rshapes, rotations in RotatedShapes(shapes) do end
function RotatedShapes(shapes, prev_rotations)
    local rshapes = {}
    if prev_rotations and #shapes == #prev_rotations then
        for i, shape in ipairs(shapes) do
            rshapes[i] = Shapes.rotate(shape, prev_rotations[i])
        end
    else
        for i, shape in ipairs(shapes) do
            rshapes[i] = DeepCopy(shape)
        end
    end

    return function()
        if not prev_rotations then
            prev_rotations = {}
            for i = 1,#rshapes do
                prev_rotations[i] = 0
            end
        else
            for i = #rshapes,1,-1 do
                if prev_rotations[i] < rshapes[i].UniqueRotationsCount - 1 then
                    prev_rotations[i] = prev_rotations[i] + 1
                    rshapes[i] = Shapes.rotate(rshapes[i], 1)
                    break
                end
                -- rotate back to initial state
                rshapes[i] = Shapes.rotate(rshapes[i], -prev_rotations[i])
                prev_rotations[i] = 0

                if i == 1 then
                    prev_rotations = nil
                end
            end
        end

        if (not prev_rotations) or (not next(prev_rotations)) then
            return nil
        end
        return Array.deepCopy(rshapes), Array.copy(prev_rotations)
    end
end

-- check all rotations for shapes and yield every one that fits into grid
function SuitableRotations(grid, shapes)
    if Shapes.area(shapes) ~= grid.FreeArea then
        return function() return nil end
    end

    grid = DeepCopy(grid)
    local grid_copy = DeepCopy(grid)
    local last_rotations
    return function()
        for rshapes, rotations in RotatedShapes(shapes, last_rotations) do
            local could_place = PlaceShapes(grid, rshapes)
            grid = DeepCopy(grid_copy)

            if could_place then

                -- DEBUG
                -- print("\nFound rotation:")
                -- Array.print(rotations)
                -- print("Shapes:")
                -- Shapes.printMany(rshapes)

                last_rotations = Array.copy(rotations)
                return rotations
            end
        end
        return nil
    end
end

-- check every permutation of shapes and every posiible rotations for that permutation
-- yield every suitable permutation with suitable rotations
function SuitablePermutations(grid, shapes)
    if Shapes.area(shapes) ~= grid.FreeArea then
        return function() return nil end
    end

    local last_permutation
    return function()
        for pshapes, permutation in Permutations(shapes, last_permutation) do
            local permutationRotations = {}
            for rotations in SuitableRotations(grid, pshapes) do
                table.insert(permutationRotations, rotations)
            end
            if next(permutationRotations) then
                last_permutation = permutation
                return permutation, permutationRotations
            end
        end
        return nil
    end
end
