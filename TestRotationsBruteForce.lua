require "Test"

require "Array"
require "Matrix"
require "Sigils"

function TEST_SuitableRotationsBruteForce(grid, shapes, expectedRotations)
    Test.Header("SuitableRotations BruteForce")

    print("    Rotating shapes:")
    Shapes.printMany(shapes)
    print(string.format("    Placing into grid %dx%d", #grid, #(grid[1])))
    print("    Expecting rotations "..Array.tostring(expectedRotations).." to fit")

    local found = {}
    for rotations in SuitableRotationsBruteForce(grid, shapes) do
        table.insert(found, setmetatable(rotations, Array.metatable))
    end

    local grid_copy = DeepCopy(grid)
    for i, rotations in ipairs(found) do
        Test.ExpectTrue(PlaceShapes(grid, Shapes.rotateMany(shapes, rotations)),
                        "Could not place rotation #"..i..": "..Array.tostring(rotations))
        Test.ExpectEqual(0, grid.FreeArea, "Grid is not full for rotations #"..i..": "..Array.tostring(rotations))
        grid = DeepCopy(grid_copy)
    end

    Test.ExpectContains(found, expectedRotations, "Could not find expected rotations")

    if Test.success then
        print("Final grid:")
        PlaceShapes(grid, Shapes.rotateMany(shapes, expectedRotations))
        Matrix.print(grid)
    end

    Test.Footer()
end

grid = Grid.create(4, 4)
expectedGrid = {{"1", "1", "1", "1"},
                {"2", "2", "3", "3"},
                {"4", "2", "2", "3"},
                {"4", "4", "4", "3"}}
shapes = {Shapes.Talos.I, Shapes.Talos.Z, Shapes.Talos.L, Shapes.Talos.J}
expectedRotations = setmetatable({1, 0, 2, 1}, Array.metatable)

TEST_SuitableRotationsBruteForce(grid, shapes, expectedRotations, expectedGrid)

grid = Grid.create(4, 4)
expectedGrid = {{"1", "1", "1", "2"},
                {"1", "3", "2", "2"},
                {"3", "3", "4", "2"},
                {"3", "4", "4", "4"}}
shapes = {Shapes.Talos.L, Shapes.Talos.T, Shapes.Talos.Z, Shapes.Talos.T}
expectedRotations = setmetatable({1, 1, 1, 2}, Array.metatable)

TEST_SuitableRotationsBruteForce(grid, shapes, expectedRotations, expectedGrid)

grid = Grid.create(5, 4)
expectedGrid = {{"1", "1", "1", "1"},
                {"2", "3", "3", "3"},
                {"2", "2", "2", "3"},
                {"4", "4", "5", "5"},
                {"4", "4", "5", "5"}}
shapes = {Shapes.Talos.I, Shapes.Talos.J, Shapes.Talos.J, Shapes.Talos.Square, Shapes.Talos.Square}
expectedRotations = setmetatable({1, 1, 3, 0, 0}, Array.metatable)

TEST_SuitableRotationsBruteForce(grid, shapes, expectedRotations, expectedGrid)