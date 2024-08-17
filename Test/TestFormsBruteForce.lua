require "Test"

require "Array"
require "Matrix"
require "Sigils"

function TEST_SuitableFormsBruteForce(grid, shapes, expected_forms)
    Test.Header("SuitableForms BruteForce")

    print("    Brute force forms of shapes:")
    Shapes.printMany(shapes)
    print(string.format("    Placing into grid %dx%d", #grid, #(grid[1])))
    print("    Expecting forms "..Array.tostring(expected_forms).." to fit")

    local found = {}
    for forms in SuitableFormsBruteForce(grid, shapes) do
        table.insert(found, setmetatable(forms, Array.metatable))
    end

    local grid_copy = DeepCopy(grid)
    for i, forms in ipairs(found) do
        Test.ExpectTrue(PlaceShapes(grid, shapes, forms),
                        "Could not place forms #"..i..": "..Array.tostring(forms))
        Test.ExpectEqual(0, grid.FreeArea, "Grid is not full for forms #"..i..": "..Array.tostring(forms))
        grid = DeepCopy(grid_copy)
    end

    Test.ExpectContains(found, expected_forms, "Could not find expected forms")

    if Test.success then
        print("Final grid:")
        PlaceShapes(grid, shapes, expected_forms)
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
expected_forms = setmetatable({2, 1, 3, 2}, Array.metatable)

TEST_SuitableFormsBruteForce(grid, shapes, expected_forms, expectedGrid)

grid = Grid.create(4, 4)
expectedGrid = {{"1", "1", "1", "2"},
                {"1", "3", "2", "2"},
                {"3", "3", "4", "2"},
                {"3", "4", "4", "4"}}
shapes = {Shapes.Talos.L, Shapes.Talos.T, Shapes.Talos.Z, Shapes.Talos.T}
expected_forms = setmetatable({2, 2, 2, 3}, Array.metatable)

TEST_SuitableFormsBruteForce(grid, shapes, expected_forms, expectedGrid)

grid = Grid.create(5, 4)
expectedGrid = {{"1", "1", "1", "1"},
                {"2", "3", "3", "3"},
                {"2", "2", "2", "3"},
                {"4", "4", "5", "5"},
                {"4", "4", "5", "5"}}
shapes = {Shapes.Talos.I, Shapes.Talos.J, Shapes.Talos.J, Shapes.Talos.Square, Shapes.Talos.Square}
expected_forms = setmetatable({2, 2, 4, 1, 1}, Array.metatable)

TEST_SuitableFormsBruteForce(grid, shapes, expected_forms, expectedGrid)