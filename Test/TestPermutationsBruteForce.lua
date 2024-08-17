require "Test"

require "Sigils"

function TEST_SuitablePermutationsBruteForce(grid, shapes, expected_permutation, expected_forms)
    Test.Header("SuitablePermutations BruteForce")

    print("    Brute forcing shapes:")
    Shapes.printMany(shapes)
    print(string.format("    Placing into grid %dx%d", #grid, #(grid[1])))
    print("    Expecting permutation "..Array.tostring(expected_permutation).." to fit")
    print("    Expecting forms   "..Array.tostring(expected_forms).." to fit")
    
    local found = {}
    for permutation, pforms in SuitablePermutationsBruteForce(grid, shapes) do
        found[setmetatable(permutation, Array.metatable)] = pforms
        for k,v in pairs(pforms) do
            setmetatable(v, Array.metatable)
        end
    end

    local grid_copy = DeepCopy(grid)
    
    local ip = 1
    for permutaion, pforms in pairs(found) do
        local pshapes = Permute(shapes, permutaion)
        for iform, forms in ipairs(pforms) do
            Test.ExpectTrue(PlaceShapes(grid, pshapes, forms),
                            "Cound not place shapes with permutation #"..ip..": "..Array.tostring(permutaion).."\n\t"..
                            "                            forms   #"..iform..": "..Array.tostring(forms))
            Test.ExpectEqual(0, grid.FreeArea, "Grid is not full for permutation #"..ip..": "..Array.tostring(permutaion).."\n\t"..
                                               "                     forms   #"..iform..": "..Array.tostring(forms))
            grid = DeepCopy(grid_copy)
        end
        ip = ip + 1
    end

    Test.AssertContainsKey(found, expected_permutation, "Could not find expected permutation")

    local pforms
    for k, v in pairs(found) do
        if k == expected_permutation then
            pforms = v
            break
        end
    end

    assert(pforms, "'found' does not have expected key")

    Test.ExpectContains(pforms, expected_forms, "Could not find expected rotations")

    if Test.success then
        print("Final grid:")
        PlaceShapes(grid, Permute(shapes, expected_permutation), expected_forms)
        Matrix.print(grid)
    end

    Test.Footer()
end


grid = Grid.create(4, 4)
expectedGrid = {{"1", "1", "1", "1"},
                {"2", "2", "3", "3"},
                {"4", "2", "2", "3"},
                {"4", "4", "4", "3"}}
shapes = {Shapes.Talos.Z, Shapes.Talos.L, Shapes.Talos.I, Shapes.Talos.J} -- {I, Z, L, J} is right one
expected_permutation = setmetatable({3, 1, 2, 4}, Array.metatable)
expected_forms  = setmetatable({2, 1, 3, 2}, Array.metatable)

TEST_SuitablePermutationsBruteForce(grid, shapes, expected_permutation, expected_forms)

grid = Grid.create(4, 4)
expectedGrid = {{"1", "1", "1", "2"},
                {"1", "3", "2", "2"},
                {"3", "3", "4", "2"},
                {"3", "4", "4", "4"}}
shapes = {Shapes.Talos.T, Shapes.Talos.T, Shapes.Talos.L, Shapes.Talos.Z} -- {L, T, Z, T}
expected_permutation = setmetatable({3, 1, 4, 2}, Array.metatable)
expected_forms = setmetatable({2, 2, 2, 3}, Array.metatable)

TEST_SuitablePermutationsBruteForce(grid, shapes, expected_permutation, expected_forms)

grid = Grid.create(5, 4)
expectedGrid = {{"1", "1", "1", "1"},
                {"2", "3", "3", "3"},
                {"2", "2", "2", "3"},
                {"4", "4", "5", "5"},
                {"4", "4", "5", "5"}}
shapes = {Shapes.Talos.Square, Shapes.Talos.J, Shapes.Talos.I, Shapes.Talos.Square, Shapes.Talos.J} -- {I, J, J, Sq, Sq}
expected_permutation = setmetatable({3, 2, 5, 1, 4}, Array.metatable)
expected_forms = setmetatable({2, 2, 4, 1, 1}, Array.metatable)

TEST_SuitablePermutationsBruteForce(grid, shapes, expected_permutation, expected_forms)