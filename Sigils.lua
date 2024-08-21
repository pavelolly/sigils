require "DeepCopy"
require "Matrix"
require "Permutations"

require "Grid"
require "Shapes"

function PlaceShape(grid, shape, form, row, col)
    form = form or 1
    row  = row  or 1
    col  = col  or 1

    -- assert(IsTable2D(grid) and IsTable(shape) and IsInteger(form) and IsInteger(row) and IsInteger(col))

    if shape.Area > grid.FreeArea then
        return false
    end

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

    local blocks_cnt = #blocks
    if blocks_cnt > 0 then
        grid:nextLabel()
        grid.FreeArea = grid.FreeArea - blocks_cnt
        return true
    end
    
    return false
end

function RemoveLastShape(grid)
    -- assert(IsTable2D(grid))

    if grid.CurrentLabel == grid.InitialLabel then
        return
    end

    grid:prevLabel()

    local blocks_removed = 0
    for i, row in ipairs(grid) do
        for j, e in ipairs(row) do
            if grid[i][j] == grid.CurrentLabel then
                grid[i][j] = grid.DefaultLabel
                blocks_removed = blocks_removed + 1
            end
        end
    end
    grid.FreeArea = grid.FreeArea + blocks_removed
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
    -- assert(IsTable(shapes) and IsTable(forms))

    if Shapes.area(shapes) ~= grid.FreeArea then return false end

    if columnwise == nil then
        columnwise = #grid < #grid[1]
    end

    for i, shape in ipairs(shapes) do
        local row, col
        row, col = NextFreeBlock(grid, columnwise)
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
    assert(not prev_forms or Shapes.validForms(shapes, prev_forms), "ShapesForms: prev_forms are not valid forms sequence for given shapes")

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
    Grid.assertValidArg(grid, "SuitableFromsBruteForce", 1)
    Array.assertValidArg(shapes, "SuitableFromsBruteForce", 2)

    if Shapes.area(shapes) ~= grid.FreeArea then
        return function() return nil end
    end

    grid            = DeepCopy(grid)
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
    Grid.assertValidArg(grid, "SuitablePermutationsBruteForce", 1)
    Array.assertValidArg(shapes, "SuitablePermutationsBruteForce", 2)

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
    Grid.assertValidArg(grid, "SuitablePermutationsUniqueBruteForce", 1)
    Array.assertValidArg(shapes, "SuitablePermutationsUniqueBruteForce", 2)

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
-- options can have:
-- -- print_debug_info
-- -- prev_permutation
-- -- stop_permutation
-- -- prev_forms
-- NOTE: combination if prev_permutation and prev_forms is skipped (if prev_form is nil then execution starts from inspecting prev_permutaions and {1, 1, ..., 1})
--       execution stops as soon as currnent visisted inspected permutation is bigger or equal lexicographically than stop_permutation 
--
-- -- number_permutations_to_inspect
-- -- number_solutions_to_inspect
function SuitablePlacements(grid, shapes, options)
    Grid.assertValidArg(grid, "SuitablePlacements", 1)
    Array.assertValidArg(shapes, "SuitablePlacements", 2)

    local init_per = GetInitialPermutation(shapes)

    options = options or {}
    assert(IsTable(options), "SuitablePlacements: options is not a table")
    assert(not options.prev_permutation or IsPermutation(options.prev_permutation, init_per),
           "SuitablePlacements: options.prev_premutation is not permutation of initial permutation of shapes which is: "..Array.tostring(init_per))
    assert(not options.stop_permutation or IsPermutation(options.stop_permutation, init_per),
           "SuitablePlacements: options.stop_permutation is not permutation of initial permutation of shapes which is: "..Array.tostring(init_per))
    assert(not options.prev_forms or Shapes.validForms(Permute(shapes, options.prev_permutation or init_per), options.prev_forms),
           "SuitablePlacements: options.prev_forms are not forms for given shapes with given permutation")
    assert(not options.number_permutations_to_inspect or type(options.number_permutations_to_inspect) == "number",
           "SuitablePLacements: options.number_permutations_to_inspect must be number")
    assert(not options.number_solutions_to_inspect or type(options.number_solutions_to_inspect) == "number",
           "SuitablePLacements: options.number_solutions_to_inspect must be number")

    -- Main body

    if grid.FreeArea ~= Shapes.area(shapes) then
        return function()
            if options.print_debug_info then
                print("Areas dont't match: grid.FreeArea = "..grid.FreeArea..", Shapes.area = "..Shapes.area(shapes))
            end
        end
    end

    local grid_copy = DeepCopy(grid)
    grid            = DeepCopy(grid)

    if options.print_debug_info then
        print("Initital grid:")
        Grid.print(grid)
    end

    local len = #shapes
    local search_next_free_block_columnwise = #grid < #grid[1]

    -- to save state between calls to iterator function
    -- and to start from some point in options mode
    local prev_permutation
    if options.prev_permutation then
        prev_permutation = Array.copy(options.prev_permutation)
    end
    local prev_forms
    if options.prev_forms then
        prev_forms = Array.copy(options.prev_forms)
    end
    local wrong_shape_max_idx = 0

    -- to skip some of rotataions when jumping to next permutation
    local prefix_forms = {}

    -- some stats
    local permutations_visited = 0
    local total_visited        = 0
    local solutions_found      = 0

    local function CutPrefixForms(permutation, next_permutation)
        for i = 1,len do
            if permutation[i] ~= next_permutation[i] then
                for j = i, len do
                    prefix_forms[j] = nil
                end
                break
            end
        end
    end

    return function()
        local permutation = prev_permutation or init_per
        local forms
        repeat
            if options.number_permutations_to_inspect and permutations_visited >= options.number_permutations_to_inspect or
               options.number_solutions_to_inspect    and solutions_found >= options.number_solutions_to_inspect         or
               options.stop_permutation               and Array.lessThan(options.stop_permutation, permutation)
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
                for i = len,1,-1 do
                    prev_forms[i] = ( (prev_forms[i] + 1) - 1) % pshapes[i].UniqueRotationsCount + 1
                    if prev_forms[i] ~= 1 then
                        break
                    end
                    resets_cnt = resets_cnt + 1
                end
                forms = prev_forms

                -- if as the result forms == {1, 1, ..., 1}
                -- then also jump to next permutation
                if resets_cnt == len then
                    local next_permutation = Array.copy(permutation)
                    if not NextPermutation(next_permutation) then
                        return nil
                    end
                    CutPrefixForms(permutation, next_permutation)
                    permutation = next_permutation
                    wrong_shape_max_idx = 0

                    pshapes = Permute(shapes, permutation)
                else
                    -- so this counter is corrent because of visiting the permutaion which is already counted
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
                for j = i,len do
                    forms[j] = 1
                end
            end
            
            permutations_visited = permutations_visited + 1

            if options.print_debug_info then
                print("========================================")
                print("Permutaitons visited: "..permutations_visited)
                print("Dealing with permutaion: "..Array.tostring(permutation))
                print("Shapes:")
                Shapes.printMany(pshapes)
                print("And forms: "..Array.tostring(forms))
                print()
            end

            -- main loop where shapes are placed
            local cur_shape_idx = 1
            while 0 < cur_shape_idx and cur_shape_idx <= len do
                local could_place = false
                while forms[cur_shape_idx] <= pshapes[cur_shape_idx].UniqueRotationsCount do

                    if options.print_debug_info then
                        print("Try shape #"..cur_shape_idx.." with form "..forms[cur_shape_idx])
                    end

                    total_visited = total_visited + 1

                    local shape = pshapes[cur_shape_idx]
                    local form  = forms[cur_shape_idx]
                    local row, col
                    row, col = NextFreeBlock(grid, search_next_free_block_columnwise)
                    row, col = ShiftByOrigin(shape, form, row, col, search_next_free_block_columnwise)
                    assert(row, "There is no place for shape")

                    if options.print_debug_info then
                        Matrix.print(shape)
                        print("At: ("..row..", "..col..")")
                    end

                    could_place = PlaceShape(grid, shape, form, row, col)
                    if could_place then
                        if options.print_debug_info then
                            print("Placed shape #"..cur_shape_idx.."; Grid:")
                            Matrix.print(grid)
                        end

                        if save_prefix_forms then
                            prefix_forms[cur_shape_idx] = forms[cur_shape_idx]

                            if options.print_debug_info then
                                print("Saved to prefix_forms["..cur_shape_idx.."] = "..forms[cur_shape_idx])
                                print()
                            end
                        end

                        break
                    end

                    -- could not place here

                    forms[cur_shape_idx] = forms[cur_shape_idx] + 1

                    if options.print_debug_info then
                        print("Could not place shape #"..cur_shape_idx)
                        print()
                    end

                end

                if not could_place then
                    save_prefix_forms = false

                    if options.print_debug_info then
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

                            if options.print_debug_info then
                                print("Removed shape #"..cur_shape_idx.."; Grid:")
                                Matrix.print(grid)
                            end

                        end
                    end

                    if cur_shape_idx <= 0 then
                        -- goto next permutation
                        break
                    end

                    forms[cur_shape_idx] = forms[cur_shape_idx] + 1
                else
                    cur_shape_idx = cur_shape_idx + 1
                end
                if 0 < cur_shape_idx and cur_shape_idx <= len then

                    if options.print_debug_info then
                        print("Moving to shape #"..cur_shape_idx)
                    end

                end
            end

            if options.print_debug_info then
                print("Done with permutation: "..Array.tostring(permutation))
                print("Having forms: "..Array.tostring(forms))
                print()
            end
         
            grid = DeepCopy(grid_copy)

            if options.print_debug_info then
                print("Cleaning up")
                Matrix.print(grid)
            end

            if cur_shape_idx > len then
                
                if options.print_debug_info then
                    print("Returning")
                end

                prev_permutation = permutation
                prev_forms = forms
                solutions_found = solutions_found + 1

                if options.print_debug_info then
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

                if options.print_debug_info then
                    print("Going to the next permutation, skipping prefix of len "..wrong_shape_max_idx)
                    print("Saving forms: "..Array.tostring(prefix_forms))
                end

            end
        until not next_permutation_exists

        if options.print_debug_info then
            print("Done")
        end
        
        PrintOptions(options, "=========== Options Settings Used ===========")
        PrintStatistics(shapes, permutations_visited, total_visited, "=========== SuitablePlacements Statistic ==============")
        
        return nil
    end
end

-- -- print_debug_info
-- -- prev_permutation
-- -- stop_permutation
-- -- prev_forms
-- -- number_permutations_to_inspect
-- -- number_solutions_to_inspect
function PrintOptions(options, header)
    if not options or not next(options) then return end
    if header then io.write(header) io.write("\n") end

    if options.prev_permutation then print("prev_permutation: "..Array.tostring(options.prev_permutation)) end
    if options.stop_permutation then print("stop_permutation: "..Array.tostring(options.stop_permutation)) end
    if options.prev_forms       then print("prev_forms: "..Array.tostring(options.prev_forms))             end
    if options.number_permutations_to_inspect then print("number_permutations_to_inspect: "..number_permutations_to_inspect) end
    if options.number_solutions_to_inspect    then print("number_solutions_to_inspect: "..number_solutions_to_inspect)       end
end

function PrintStatistics(shapes, permutations_visited, total_visited, header)
    if header then io.write(header) io.write("\n") end

    local permutations_count = NumberOfPermutations(shapes)
    local w = 4
    print(string.format("Permutaitons visited:      %d / %d (%."..w.."f %%) / %d (%."..w.."f %%)",
                         permutations_visited,
                         permutations_count,
                         permutations_visited / permutations_count * 100,
                         Factorial(#shapes),
                         permutations_visited / Factorial(#shapes) * 100))

    local forms_per_permutations = 1
    for i = 1,#shapes do
        forms_per_permutations = forms_per_permutations * shapes[i].UniqueRotationsCount
    end
    print(string.format("Total Iterations visited:  %d / %d (%."..w.."f %%) / %d (%."..w.."f %%)",
                         total_visited,
                         permutations_count * forms_per_permutations,
                         total_visited / (permutations_count * forms_per_permutations) * 100,
                         Factorial(#shapes) * forms_per_permutations,
                         total_visited / (Factorial(#shapes) * forms_per_permutations) * 100))
end

-- lua -lSigils -e "for p, r in SuitablePlacements(Grid.create(4, 4), {Shapes.Talos.Z, Shapes.Talos.L, Shapes.Talos.I, Shapes.Talos.J}, {print_debug_info = true}) do end"

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