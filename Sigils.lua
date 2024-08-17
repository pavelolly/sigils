require "DeepCopy"
require "Matrix"
require "Permutations"

require "Grid"
require "Shapes"

function PlaceShape(grid, shape, form, row, col)
    if shape.Area > grid.FreeArea then
        return false
    end

    form = form or 1
    row  = row or 1
    col  = col or 1

    local blocks = {}
    local shape_mat = Shapes.getForm(shape, form)
    for i, shape_row in ipairs(shape_mat) do
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

function NextFreeBlock(grid, columnwise)
    return Matrix.find(grid, grid.DefaultLabel, columnwise)
end

-- returns position such that shape's origin is at row, col
-- shape: 0 1, row: 1, col: 1 --> return: 1, 0
--        1 1
local function ShiftByOrigin(shape, form, row, col, search_origin_columnwise)
    local orow, ocol = Shapes.getOrigin(shape, form, search_origin_columnwise)
    if not row or not col or not orow or not col then
        return nil
    end
    return row - orow + 1, col - ocol + 1
end

function PlaceShapes(grid, shapes, forms, columnwise)
    if Shapes.area(shapes) ~= grid.FreeArea then return false end

    if columnwise == nil then
        columnwise = #grid < #grid[1]
    end

    for i, shape in ipairs(shapes) do
        local row, col = NextFreeBlock(grid, columnwise)
        row, col = ShiftByOrigin(shape, forms[i], row, col, columnwise)
        if not row or not PlaceShape(grid, shape, forms[i], row, col) then
            return false
        end
    end
    return true
end

-- you can use this in a for loop:
-- for forms in ShapesForms(shapes) do end
function ShapesForms(shapes, prev_forms)
    if prev_forms then
        prev_forms = Array.copy(prev_forms)
    end

    return function()
        if not prev_forms then
            prev_forms = {}
            for i = 1,#shapes do
                prev_forms[i] = 1
            end
        else
            for i = #shapes,1,-1 do
                if prev_forms[i] < shapes[i].UniqueRotationsCount then
                    prev_forms[i] = prev_forms[i] + 1
                    break
                end
                -- rotate back to initial state
                prev_forms[i] = 1

                if i == 1 then
                    prev_forms = nil
                end
            end
        end

        if (not prev_forms) or (not next(prev_forms)) then
            return nil
        end
        return Array.copy(prev_forms)
    end
end

-- check all forms for shapes and yield every one that fits into grid
function SuitableFormsBruteForce(grid, shapes)
    if Shapes.area(shapes) ~= grid.FreeArea then
        return function() return nil end
    end

    grid = DeepCopy(grid)
    local grid_copy = DeepCopy(grid)
    local last_forms
    return function()
        for forms in ShapesForms(shapes, last_forms) do
            local could_place = PlaceShapes(grid, shapes, forms)
            grid = DeepCopy(grid_copy)

            if could_place then
                last_forms = Array.copy(forms)
                return forms
            end
        end
        return nil
    end
end

-- check every permutation of shapes and every posiible forms for that permutation
-- yield every suitable permutation with suitable forms
function SuitablePermutationsBruteForce(grid, shapes)
    if Shapes.area(shapes) ~= grid.FreeArea then
        return function() return nil end
    end

    local last_permutation
    return function()
        for pshapes, permutation in Permutations(shapes, last_permutation) do
            local permutation_forms = {}
            for forms in SuitableFormsBruteForce(grid, pshapes) do
                table.insert(permutation_forms, forms)
            end
            if next(permutation_forms) then
                last_permutation = permutation
                return permutation, permutation_forms
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
            local permutation_forms = {}
            for forms in SuitableFormsBruteForce(grid, pshapes) do
                table.insert(permutation_forms, forms)
            end
            if next(permutation_forms) then
                last_permutation = permutation
                return permutation, permutation_forms
            end
        end
        return nil
    end
end

-- optimized brure force
-- debug can have:
-- -- print_info
-- -- prev_permutation
-- -- stop_permutation
-- -- prev_forms
-- -- number_permutations_to_inspect
-- -- number_solutions_to_inspect
function SuitablePlacements(grid, shapes, debug)
    -- debug
    debug = debug or {}

    if grid.FreeArea ~= Shapes.area(shapes) then
        return function()
            if debug.print_info then
                print("Areas dont't match: grid.FreeArea = "..grid.FreeArea..", Shapes.area = "..Shapes.area(shapes))
            end
        end
    end

    local grid_copy = DeepCopy(grid)
    grid = DeepCopy(grid)

    if debug.print_info then
        print("Initital grid:")
        Grid.print(grid)
    end

    local length = #shapes
    local search_next_free_block_columnwise = #grid < #grid[1]

    -- to save state between calls to iterator function
    -- and to start from some point in debug mode
    local prev_permutation
    if debug.prev_permutation then
        prev_permutation = Array.copy(debug.prev_permutation)
    end
    local prev_forms
    if debug.prev_forms then
        prev_forms = Array.copy(debug.prev_forms)
    end
    local wrong_shape_max_idx = 0

    -- some stats
    local permutations_visited = 0
    local total_visited = 0
    local solutions_found = 0

    -- to skip some of rotataions when jumping to next permutation
    local prefix_forms = {}

    local function CutPrefixForms(permutation, next_permutation)
        for i = 1,length do
            if permutation[i] ~= next_permutation[i] then
                for j = i, length do
                    prefix_forms[j] = nil
                end
                break
            end
        end
    end

    return function()
        local permutation = prev_permutation or GetInitialPermutation(shapes)
        local forms
        repeat
            if debug.number_permutations_to_inspect and permutations_visited >= debug.number_permutations_to_inspect or
               debug.number_solutions_to_inspect and solutions_found >= debug.number_solutions_to_inspect            or
               debug.stop_permutation and Array.lessThanOrEqual(debug.stop_permutation, permutation)
            then
                break
            end

            -- prepare permuted shapes and forms
            local pshapes = Permute(shapes, permutation)

            local save_prefix_forms = true

            if not forms and prev_forms then
                -- this block is supposed to be run only on the first iteration

                -- jump to next forms
                local resets_cnt = 0
                for i = length,1,-1 do
                    prev_forms[i] = ( (prev_forms[i] + 1) - 1) % pshapes[i].UniqueRotationsCount + 1
                    if prev_forms[i] ~= 1 then
                        break
                    end
                    resets_cnt = resets_cnt + 1
                end
                forms = prev_forms

                -- if as the result forms == {1, 1, ..., 1}
                -- then also jump to next permutation
                if resets_cnt == length then
                    local next_permutation = Array.copy(permutation)
                    if not NextPermutation(next_permutation) then
                        return nil
                    end
                    CutPrefixForms(permutation, next_permutation)
                    permutation = next_permutation
                    wrong_shape_max_idx = 0

                    pshapes = Permute(shapes, permutation)
                else
                    -- so this counter is corrent because i visit the same permutaion which is already counted
                    permutations_visited = permutations_visited - 1
                end

                -- forbid saving prefix forms as we are kind of continuing doing work of previuos call 
                save_prefix_forms = false
            else
                forms = forms or {}
                local i = 1
                while prefix_forms[i] do
                    forms[i] = prefix_forms[i]
                    i = i + 1
                end
                for j = i,length do
                    forms[j] = 1
                end
            end
            
            permutations_visited = permutations_visited + 1

            if debug.print_info then
                print("========================================")
                print("Permutaitons visited: "..permutations_visited)
                print("Dealing with permutaion: "..Array.tostring(permutation))
                print("Shapes:")
                Shapes.printMany(pshapes)
                print("And forms: "..Array.tostring(forms))
                print()
            end

            -- try to place pshapes with different forms
            local cur_shape_idx = 1
            while 0 < cur_shape_idx and cur_shape_idx <= length do
                local could_place = false
                while forms[cur_shape_idx] <= pshapes[cur_shape_idx].UniqueRotationsCount do

                    if debug.print_info then
                        print("Try shape #"..cur_shape_idx.." rotated "..forms[cur_shape_idx].." times")
                    end

                    total_visited = total_visited + 1

                    local shape = pshapes[cur_shape_idx]
                    local form  = forms[cur_shape_idx]
                    local row, col = NextFreeBlock(grid, search_next_free_block_columnwise)
                    row, col = ShiftByOrigin(shape, form, row, col, search_next_free_block_columnwise)
                    assert(row, "There is no place for shape")

                    if debug.print_info then
                        Matrix.print(shape)
                        print("At: ("..row..", "..col..")")
                    end

                    could_place = PlaceShape(grid, shape, form, row, col)
                    if could_place then
                        if debug.print_info then
                            print("Placed shape #"..cur_shape_idx.."; Grid:")
                            Matrix.print(grid)
                        end

                        if save_prefix_forms then
                            prefix_forms[cur_shape_idx] = forms[cur_shape_idx]

                            if debug.print_info then
                                print("Saved to prefix_forms["..cur_shape_idx.."] = "..forms[cur_shape_idx])
                                print()
                            end
                        end

                        break
                    end

                    -- could not place here

                    forms[cur_shape_idx] = forms[cur_shape_idx] + 1

                    if debug.print_info then
                        print("Could not place shape #"..cur_shape_idx)
                        print()
                    end

                end

                if not could_place then
                    save_prefix_forms = false

                    if debug.print_info then
                        print("Stop bure forcing shape #"..cur_shape_idx)
                    end

                    if cur_shape_idx > wrong_shape_max_idx then        
                        -- remember number of shape which we failed to place
                        wrong_shape_max_idx = cur_shape_idx
                    end
                    -- if could not place shape at current index go back and try to switch form one of prev shapes
                    while cur_shape_idx > 0 and pshapes[cur_shape_idx].UniqueRotationsCount - forms[cur_shape_idx] <= 0 --[[-1 or 0]] do
                        forms[cur_shape_idx] = 1
                        cur_shape_idx = cur_shape_idx - 1
                        if cur_shape_idx >= 1 then
                            RemoveLastShape(grid)

                            if debug.print_info then
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

                    forms[cur_shape_idx] = forms[cur_shape_idx] + 1
                else
                    cur_shape_idx = cur_shape_idx + 1
                end
                if 0 < cur_shape_idx and cur_shape_idx <= length then

                    if debug.print_info then
                        print("Moving to shape #"..cur_shape_idx)
                    end

                end
            end

            if debug.print_info then
                print("Done with permutation: "..Array.tostring(permutation))
                print("Having forms: "..Array.tostring(forms))
                print()
            end
         
            grid = DeepCopy(grid_copy)

            if debug.print_info then
                print("Cleaning up")
                Matrix.print(grid)
            end

            if cur_shape_idx > length then
                
                if debug.print_info then
                    print("Returning")
                end

                prev_permutation = permutation
                prev_forms = forms
                solutions_found = solutions_found + 1

                if debug.print_info then
                    print("Found solution #"..solutions_found)
                end

                return Array.copy(permutation), Array.copy(forms)
            end

            local next_permutation = Array.copy(permutation)
            local next_permutation_exists = NextPermutationSkipPrefix(next_permutation, wrong_shape_max_idx)
            if next_permutation_exists then
                CutPrefixForms(permutation, next_permutation)
                permutation = next_permutation
                wrong_shape_max_idx = 0

                if debug.print_info then
                    print("Going to the next permutation, skipping prefix of length "..wrong_shape_max_idx)
                    print("Saving forms: "..Array.tostring(prefix_forms))
                end

            end
        until not next_permutation_exists

        if debug.print_info then
            print("Done")
        end
        
        PrintStatistics(shapes, permutations_visited, total_visited, "=========== SuitablePlacements Statistic ==============")
        
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

function PrintStatistics(shapes, permutations_visited, total_visited, header)
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
                         permutations_visited,
                         permutaitonsCount,
                         permutations_visited / permutaitonsCount * 100,
                         factorial(#shapes),
                         permutations_visited / factorial(#shapes) * 100))

    local rotationsPerPermutaionCount = 1
    for i = 1,#shapes do
        rotationsPerPermutaionCount = rotationsPerPermutaionCount * shapes[i].UniqueRotationsCount
    end
    print(string.format("Total Iterations visited:  %d / %d (%.3f %%) / %d (%.3f %%)",
                         total_visited,
                         permutaitonsCount * rotationsPerPermutaionCount,
                         total_visited / (permutaitonsCount * rotationsPerPermutaionCount) * 100,
                         factorial(#shapes) * rotationsPerPermutaionCount,
                         total_visited / (factorial(#shapes) * rotationsPerPermutaionCount) * 100))
end

-- lua -lSigils -e "for p, r in SuitablePlacements(Grid.create(4, 4), {Shapes.Talos.Z, Shapes.Talos.L, Shapes.Talos.I, Shapes.Talos.J}, {print_info = true}) do end"

function FindAnySolution(grid, shapes, start_permutation, stop_permutaion)
    for p, r in SuitablePlacements(grid, shapes, {prev_permutation = start_permutation, stop_permutaion = stop_permutaion}) do
        return p, r
    end
    return nil
end

function FindRandomSolution(grid, shapes)
    local init_per = GetInitialPermutation(shapes)
    Array.shuffle(init_per)
    p, f = FindAnySolution(grid, shapes, init_per)
    if p then
        return p, f
    end
    return FindAnySolution(grid, shapes, nil, init_per)
end