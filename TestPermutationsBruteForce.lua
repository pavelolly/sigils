require "Test"

require "Sigils"

function TEST_SuitablePermutationsBruteForce(grid, shapes, expectedPermutation, expectedRotations)
    Test.Header("SuitablePermutations BruteForce")

    print("    Rotating shapes:")
    Shapes.printMany(shapes)
    print(string.format("    Placing into grid %dx%d", #grid, #(grid[1])))
    print("    Expecting permutation "..Array.tostring(expectedPermutation).." to fit")
    print("    Expecting rotations   "..Array.tostring(expectedRotations).." to fit")
    
    local found = {}
    for permutation, protations in SuitablePermutationsBruteForce(grid, shapes) do
        found[setmetatable(permutation, Array.metatable)] = protations
        for k,v in pairs(protations) do
            setmetatable(v, Array.metatable)
        end
    end

    local grid_copy = DeepCopy(grid)
    
    local ip = 1
    for permutaion, protations in pairs(found) do
        local pshapes = Permute(shapes, permutaion)
        for ir, rotations in ipairs(protations) do
            local rshapes = Shapes.rotateMany(pshapes, rotations)
            Test.ExpectTrue(PlaceShapes(grid, rshapes),
                            "Cound not place shapes with permutation #"..ip..": "..Array.tostring(permutaion).."\n\t"..
                            "                            rotations   #"..ir..": "..Array.tostring(rotations))
            Test.ExpectEqual(0, grid.FreeArea, "Grid is not full for permutation #"..ip..": "..Array.tostring(permutaion).."\n\t"..
                                               "                     rotations   #"..ir..": "..Array.tostring(rotations))
            grid = DeepCopy(grid_copy)
        end
        ip = ip + 1
    end

    Test.AssertContainsKey(found, expectedPermutation, "Could not find expected permutation")

    local protations
    for k, v in pairs(found) do
        if k == expectedPermutation then
            protations = v
            break
        end
    end

    assert(protations, "'found' does not have expected key")

    Test.ExpectContains(protations, expectedRotations, "Could not find expected rotations")

    if Test.success then
        print("Final grid:")
        PlaceShapes(grid, Shapes.rotateMany(Permute(shapes, expectedPermutation), expectedRotations))
        Matrix.print(grid)
    end

    Test.Footer()
end


grid = Grid.create(4, 4)
expectedGrid = {{"1", "1", "1", "1"},
                {"2", "2", "3", "3"},
                {"4", "2", "2", "3"},
                {"4", "4", "4", "3"}}
shapes = {Shapes.Z, Shapes.L, Shapes.I, Shapes.J} -- {I, Z, L, J} is right one
expectedPermutation = setmetatable({3, 1, 2, 4}, Array.metatable)
expectedRotations  = setmetatable({1, 0, 2, 1}, Array.metatable)

TEST_SuitablePermutationsBruteForce(grid, shapes, expectedPermutation, expectedRotations)

grid = Grid.create(4, 4)
expectedGrid = {{"1", "1", "1", "2"},
                {"1", "3", "2", "2"},
                {"3", "3", "4", "2"},
                {"3", "4", "4", "4"}}
shapes = {Shapes.T, Shapes.T, Shapes.L, Shapes.Z} -- {L, T, Z, T}
expectedPermutation = setmetatable({3, 1, 4, 2}, Array.metatable)
expectedRotations = setmetatable({1, 1, 1, 2}, Array.metatable)

TEST_SuitablePermutationsBruteForce(grid, shapes, expectedPermutation, expectedRotations)

grid = Grid.create(5, 4)
expectedGrid = {{"1", "1", "1", "1"},
                {"2", "3", "3", "3"},
                {"2", "2", "2", "3"},
                {"4", "4", "5", "5"},
                {"4", "4", "5", "5"}}
shapes = {Shapes.Square, Shapes.J, Shapes.I, Shapes.Square, Shapes.J} -- {I, J, J, Sq, Sq}
expectedPermutation = setmetatable({3, 2, 5, 1, 4}, Array.metatable)
expectedRotations = setmetatable({1, 1, 3, 0, 0}, Array.metatable)

TEST_SuitablePermutationsBruteForce(grid, shapes, expectedPermutation, expectedRotations)