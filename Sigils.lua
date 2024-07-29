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

    local blocksPlaced = 0
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
                blocksPlaced = blocksPlaced + 1
            end
        end
    end

    if blocksPlaced > 0 then
        grid:nextLabel()
        grid.FreeArea = grid.FreeArea - blocksPlaced
        return true
    else return false end
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

-- ) you can use this in a for loop:
--   for rshapes, rotations in RotateShapes(shapes) do end
-- ) to properly save and use 'rshapes' and 'rotations' you should copy them
--   (iterator function returns referenses to its inner varibles used for iteration purposes)
--   DO NOT MODIFY RETURNED VALUES!!!
function RotateShapes(shapes, rotations)
    local rshapes = {}
    if rotations and #shapes == #rotations then
        for i, shape in ipairs(shapes) do
            rshapes[i] = Shapes.rotate(shape, rotations[i])
        end
    else
        rotations = {}
        for i, shape in ipairs(shapes) do
            rshapes[i] = DeepCopy(shape)
        end
    end

    return function()
        if not next(rotations) then
            for i = 1,#rshapes do
                rotations[i] = 0
            end
        else
            for i = #rshapes,1,-1 do
                if rotations[i] < rshapes[i].UniqueRotationsCount - 1 then
                    rotations[i] = rotations[i] + 1
                    rshapes[i] = Shapes.rotate(rshapes[i], 1)
                    break
                end
                -- rotate back to initial state
                rshapes[i] = Shapes.rotate(rshapes[i], -rotations[i])
                rotations[i] = 0

                if i == 1 then
                    rotations = nil
                end
            end
        end

        if (not rotations) or (not next(rotations)) then
            return nil
        else
            return rshapes, rotations
        end
    end
end

-- check all rotations for shapes and yield every one that fits into grid
function SuitableRotations(grid, shapes)
    if Shapes.area(shapes) ~= grid.FreeArea then
        return function() return nil end
    end

    local last_rotations
    return function()
        for rshapes, rotations in RotateShapes(shapes, last_rotations) do
            if PlaceShapes(grid, rshapes) then

                -- DEBUG
                -- print("\nFound rotation:")
                -- Array.print(rotations)
                -- print("Shapes:")
                -- Shapes.printMany(rshapes)

                last_rotations = rotations
                return Array.copy(rotations)
            end
            Grid.clear(grid)
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
                table.insert(permutationRotations, Array.copy(rotations))
            end
            if next(permutationRotations) then
                last_permutation = permutation
                return Array.copy(permutation), permutationRotations
            end
            Grid.clear(grid)
        end
        return nil
    end
end
