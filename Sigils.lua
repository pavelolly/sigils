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
function SuitablePlacements(grid, shapes)
    if grid.FreeArea ~= Shapes.area(shapes) then
        return function() print("Bad area: grid.FreeArea = "..grid.FreeArea..", Shapes.area = "..Shapes.area(shapes)) end
    end

    local grid_copy = DeepCopy(grid)
    grid = DeepCopy(grid)

    -- print("Initital grid:")
    -- Grid.print(grid)

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
                    -- so this counter os corrent as i visit the same permutaion which is already counted
                    permutationsVisisted = permutationsVisisted - 1
                end
            else
                rotations = rotations or {}
                for i = 1, #pshapes do
                    rotations[i] = 0
                end
            end
        
            -- print("========================================")
            permutationsVisisted = permutationsVisisted + 1
            -- print("Permutaitons visited: "..permutationsVisisted)
            -- print("Dealing with permutaion: "..Array.tostring(permutation))
            -- print("Shapes:")
            -- Shapes.printMany(pshapes)
            -- print("And rotations: "..Array.tostring(rotations))
            -- print()

            -- try to place pshapes with different rotations
            local wrong_shape_max_idx = 0
            local cur_shape_idx = 1
            while 0 < cur_shape_idx and cur_shape_idx <= #pshapes do
                local could_place = false
                while rotations[cur_shape_idx] < pshapes[cur_shape_idx].UniqueRotationsCount do
                    -- print("Try shape #"..cur_shape_idx.." rotated "..rotations[cur_shape_idx].." times")
                    totalVisited = totalVisited + 1

                    local shape = Shapes.rotate(pshapes[cur_shape_idx], rotations[cur_shape_idx])

                    local frow, fcol = NextFreeBlock(grid)
                    local orow, ocol = Shapes.getOrigin(shape)
                    assert(frow and orow, "There is no place for shape")
                    local row = frow - orow + 1
                    local col = fcol - ocol + 1

                    -- Matrix.print(shape)
                    -- print("At: ("..row..", "..col..")")

                    could_place = PlaceShape(grid, shape, row, col)
                    if could_place then
                        -- print("Placed shape #"..cur_shape_idx.."; Grid:")
                        -- Matrix.print(grid)
                        -- print()
                        break
                    end

                    -- print("Could not place shape #"..cur_shape_idx)
                    -- print()
                    rotations[cur_shape_idx] = rotations[cur_shape_idx] + 1
                end

                if not could_place then
                    -- print("Stop rotating shape #"..cur_shape_idx)
                    if cur_shape_idx > wrong_shape_max_idx then
                        wrong_shape_max_idx = cur_shape_idx
                    end
                    -- if could not place shape at current index go back and try to rotate one of prev shapes
                    while cur_shape_idx > 0 and pshapes[cur_shape_idx].UniqueRotationsCount - rotations[cur_shape_idx] <= 1 --[[0 or 1]] do
                        rotations[cur_shape_idx] = 0
                        cur_shape_idx = cur_shape_idx - 1
                        if cur_shape_idx >= 1 then
                            RemoveLastShape(grid)
                            -- print("Removed shape #"..cur_shape_idx.."; Grid:")
                            -- Matrix.print(grid)
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
                    -- print("Moving to shape #"..cur_shape_idx)
                end
            end

            -- print("Done with permutation: "..Array.tostring(permutation))
            -- print("Having rotations: "..Array.tostring(rotations))
            -- print()
        
            -- print("Cleaning up")
            grid = DeepCopy(grid_copy)
            -- Matrix.print(grid)

            if cur_shape_idx > #pshapes then
                -- print("Returning")
                prev_permutation = permutation
                prev_rotations = rotations
                return Array.copy(permutation), Array.copy(rotations)
            end
            -- print("Going to the next permutation, skipping prefix of length "..wrong_shape_max_idx)
        until not NextPermutationSkipPrefix(permutation, wrong_shape_max_idx)

        print("=========== SuitablePlacements Statistic ==============")

        local function factorial(n)
            local res = 1
            for i = 1,n do
                res = res * i
            end
            return res
        end

        local permutaitonsCount = factorial(#shapes)
        local seen = {}
        local init_per = GetInitialPermutation(shapes)
        for i, e in ipairs(init_per) do
            if not Array.find(seen, e) then
                permutaitonsCount = permutaitonsCount / factorial(Array.count(init_per, e))
                table.insert(seen, e)
            end
        end
        permutaitonsCount = math.tointeger(permutaitonsCount)
        print("Permutaitons visited: "..permutationsVisisted.."/"..permutaitonsCount..
              " ("..(permutationsVisisted / permutaitonsCount * 100).." %)")
        local rotationsPerPermutaionCount = 1
        for i = 1,#shapes do
            rotationsPerPermutaionCount = rotationsPerPermutaionCount * shapes[i].UniqueRotationsCount
        end
        print("Total Iterations visited: "..totalVisited.."/"..(permutaitonsCount * rotationsPerPermutaionCount)..
              " ("..(totalVisited / (permutaitonsCount * rotationsPerPermutaionCount) * 100).." %)")
        return nil
    end
end

-- lua -lSigils -e "for p, r in SuitablePlacements(Grid.create(4, 4), {Shapes.Talos.I, Shapes.Talos.Z, Shapes.Talos.L, Shapes.Talos.J}) do end"