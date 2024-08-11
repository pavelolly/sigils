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

function RemoveLastShape(grid)
    if grid.CurrentLabel == grid.InitialLabel then
        return
    end

    grid:prevLabel()

    local blocksRemoved = 0
    for i, row in ipairs(grid) do
        for j, e in ipairs(row) do
            if grid[i][j] == grid.CurrentLabel then
                grid[i][j] = grid.DefaultLabel
                blocksRemoved = blocksRemoved + 1
            end
        end
    end
    grid.FreeArea = grid.FreeArea + blocksRemoved
end

function NextFreeBlock(grid)
    return Matrix.find(grid, grid.DefaultLabel)
end

-- returns position such that shape's origin is at row, col
-- shape: 0 1, row: 1, col: 1 --> return: 1, 0
--        1 1
local function ShiftByOrigin(shape, row, col)
    local orow, ocol = Shapes.getOrigin(shape)
    if not row or not col or not orow or not col then
        return nil
    end
    return row - orow + 1, col - ocol + 1
end

function PlaceShapes(grid, shapes)
    if Shapes.area(shapes) ~= grid.FreeArea then return false end
    for i, shape in ipairs(shapes) do
        local row, col = ShiftByOrigin(shape, NextFreeBlock(grid))
        if not row or not PlaceShape(grid, shape, row, col) then
            return false
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
function SuitableRotationsBruteForce(grid, shapes)
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
                last_rotations = Array.copy(rotations)
                return rotations
            end
        end
        return nil
    end
end

-- check every permutation of shapes and every posiible rotations for that permutation
-- yield every suitable permutation with suitable rotations
function SuitablePermutationsBruteForce(grid, shapes)
    if Shapes.area(shapes) ~= grid.FreeArea then
        return function() return nil end
    end

    local last_permutation
    return function()
        for pshapes, permutation in Permutations(shapes, last_permutation) do
            local permutationRotations = {}
            for rotations in SuitableRotationsBruteForce(grid, pshapes) do
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

-- same as above but with another PermutationsFunction
function SuitablePermutationsUniqueBruteForce(grid, shapes)
    if Shapes.area(shapes) ~= grid.FreeArea then
        return function() return nil end
    end

    local last_permutation
    return function()
        for pshapes, permutation in PermutationsUnique(shapes, last_permutation) do
            local permutationRotations = {}
            for rotations in SuitableRotationsBruteForce(grid, pshapes) do
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

-- optimized brure force
function SuitablePlacements(grid, shapes, printDebugInfo)
    if grid.FreeArea ~= Shapes.area(shapes) then
        return function() print("Bad area: grid.FreeArea = "..grid.FreeArea..", Shapes.area = "..Shapes.area(shapes)) end
    end

    local grid_copy = DeepCopy(grid)
    grid = DeepCopy(grid)

    if printDebugInfo then
        print("Initital grid:")
        Grid.print(grid)
    end

    local prev_permutation
    local prev_rotations
    local permutationsVisisted = 0
    local totalVisited = 0

    return function()
        local permutation = prev_permutation or GetInitialPermutation(shapes)
        local rotations
        repeat
            -- prepare permuted shapes and rotations
            local pshapes = Permute(shapes, permutation)

            if not rotations and prev_rotations then
                -- this block is supposed to be run only on the first iteration

                -- jump to next rotations
                local zeros_cnt = 0
                for i = #prev_rotations,1,-1 do
                    prev_rotations[i] = (prev_rotations[i] + 1) % pshapes[i].UniqueRotationsCount
                    if prev_rotations[i] ~= 0 then
                        break
                    end
                    zeros_cnt = zeros_cnt + 1
                end
                rotations = prev_rotations

                -- if as the result rotations == {0, 0, ..., 0}
                -- then also jump to next permutation
                if zeros_cnt == #rotations then
                    if not NextPermutation(permutation) then
                        return nil
                    end
                    pshapes = Permute(shapes, permutation)
                else
                    -- so this counter is corrent because i visit the same permutaion which is already counted
                    permutationsVisisted = permutationsVisisted - 1
                end
            else
                rotations = rotations or {}
                for i = 1, #pshapes do
                    rotations[i] = 0
                end
            end
            
            permutationsVisisted = permutationsVisisted + 1

            if printDebugInfo then
                print("========================================")
                print("Permutaitons visited: "..permutationsVisisted)
                print("Dealing with permutaion: "..Array.tostring(permutation))
                print("Shapes:")
                Shapes.printMany(pshapes)
                print("And rotations: "..Array.tostring(rotations))
                print()
            end

            -- try to place pshapes with different rotations
            local wrong_shape_max_idx = 0
            local cur_shape_idx = 1
            while 0 < cur_shape_idx and cur_shape_idx <= #pshapes do
                local could_place = false
                while rotations[cur_shape_idx] < pshapes[cur_shape_idx].UniqueRotationsCount do

                    if printDebugInfo then
                        print("Try shape #"..cur_shape_idx.." rotated "..rotations[cur_shape_idx].." times")
                    end

                    totalVisited = totalVisited + 1

                    local shape = Shapes.rotate(pshapes[cur_shape_idx], rotations[cur_shape_idx])
                    local row, col = ShiftByOrigin(shape, NextFreeBlock(grid))
                    assert(row, "There is no place for shape")

                    if printDebugInfo then
                        Matrix.print(shape)
                        print("At: ("..row..", "..col..")")
                    end

                    could_place = PlaceShape(grid, shape, row, col)
                    if could_place then

                        if printDebugInfo then
                            print("Placed shape #"..cur_shape_idx.."; Grid:")
                            Matrix.print(grid)
                            print()
                        end

                        break
                    end

                    if printDebugInfo then
                        print("Could not place shape #"..cur_shape_idx)
                        print()
                    end

                    rotations[cur_shape_idx] = rotations[cur_shape_idx] + 1
                end

                if not could_place then

                    if printDebugInfo then
                        print("Stop rotating shape #"..cur_shape_idx)
                    end

                    if cur_shape_idx > wrong_shape_max_idx then        
                        -- remember number of shape which we failed to place
                        wrong_shape_max_idx = cur_shape_idx
                    end
                    -- if could not place shape at current index go back and try to rotate one of prev shapes
                    while cur_shape_idx > 0 and pshapes[cur_shape_idx].UniqueRotationsCount - rotations[cur_shape_idx] <= 1 --[[0 or 1]] do
                        rotations[cur_shape_idx] = 0
                        cur_shape_idx = cur_shape_idx - 1
                        if cur_shape_idx >= 1 then
                            RemoveLastShape(grid)

                            if printDebugInfo then
                                print("Removed shape #"..cur_shape_idx.."; Grid:")
                                Matrix.print(grid)
                            end

                        end
                    end
                    -- print()
                    if cur_shape_idx <= 0 then
                        -- goto next permutation
                        break
                    end

                    rotations[cur_shape_idx] = rotations[cur_shape_idx] + 1
                else
                    cur_shape_idx = cur_shape_idx + 1
                end
                if 0 < cur_shape_idx and cur_shape_idx <= #pshapes then

                    if printDebugInfo then
                        print("Moving to shape #"..cur_shape_idx)
                    end

                end
            end

            if printDebugInfo then
                print("Done with permutation: "..Array.tostring(permutation))
                print("Having rotations: "..Array.tostring(rotations))
                print()
            end
         
            grid = DeepCopy(grid_copy)

            if printDebugInfo then
                print("Cleaning up")
                Matrix.print(grid)
            end

            if cur_shape_idx > #pshapes then
                
                if printDebugInfo then
                    print("Returning")
                end

                prev_permutation = permutation
                prev_rotations = rotations
                return Array.copy(permutation), Array.copy(rotations)
            end

            if printDebugInfo then
                print("Going to the next permutation, skipping prefix of length "..wrong_shape_max_idx)
            end

        until not NextPermutationSkipPrefix(permutation, wrong_shape_max_idx)

        
        -- PrintStatistics(shapes, permutationsVisisted, totalVisited, "=========== SuitablePlacements Statistic ==============")
        
        return nil
    end
end

local function factorial(n)
    local res = 1
    for i = 1,n do
        res = res * i
    end
    return res
end

function PrintStatistics(shapes, permutationsVisisted, totalVisited, header)
    if header then io.write(header) io.write("\n") end

    local seen = {}
    local init_per = GetInitialPermutation(shapes)
    local permutaitonsCount = factorial(#shapes)
    for i, e in ipairs(init_per) do
        if not Array.find(seen, e) then
            permutaitonsCount = permutaitonsCount / factorial(Array.count(init_per, e))
            table.insert(seen, e)
        end
    end
    permutaitonsCount = math.tointeger(permutaitonsCount)
    print(string.format("Permutaitons visited:      %d / %d (%.3f %%) / %d (%.3f %%)",
                         permutationsVisisted,
                         permutaitonsCount,
                         permutationsVisisted / permutaitonsCount * 100,
                         factorial(#shapes),
                         permutationsVisisted / factorial(#shapes) * 100))

    local rotationsPerPermutaionCount = 1
    for i = 1,#shapes do
        rotationsPerPermutaionCount = rotationsPerPermutaionCount * shapes[i].UniqueRotationsCount
    end
    print(string.format("Total Iterations visited:  %d / %d (%.3f %%) / %d (%.3f %%)",
                         totalVisited,
                         permutaitonsCount * rotationsPerPermutaionCount,
                         totalVisited / (permutaitonsCount * rotationsPerPermutaionCount) * 100,
                         factorial(#shapes) * rotationsPerPermutaionCount,
                         totalVisited / (factorial(#shapes) * rotationsPerPermutaionCount) * 100))
end

-- lua -lSigils -e "for p, r in SuitablePlacements(Grid.create(4, 4), {Shapes.Talos.Z, Shapes.Talos.L, Shapes.Talos.I, Shapes.Talos.J}, true) do end"