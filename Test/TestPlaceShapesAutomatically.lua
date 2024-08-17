require "Test"

require "Sigils"

function TEST_PlaceShapes_Automatically(grid, shapes, forms, expectedGrid)
    Test.Header("Place Shapes Automatically")

    Test.ExpectTrue(PlaceShapes(grid, shapes, forms), "Could not place shapes")
    Test.ExpectEqual(grid, expectedGrid, "Grid is not what expected")

    Test.Footer()
end

grid = Grid.create(4, 4)
shapes = {
    Shapes.Talos.I,
    Shapes.Talos.Z,
    Shapes.Talos.L,
    Shapes.Talos.J
}
forms = {2, 1, 3, 2}
expectedGrid = {{"1", "1", "1", "1"},
                {"2", "2", "3", "3"},
                {"4", "2", "2", "3"},
                {"4", "4", "4", "3"}}

TEST_PlaceShapes_Automatically(grid, shapes, forms, expectedGrid)

grid = Grid.create(4, 4)
shapes = {
    Shapes.Talos.L,
    Shapes.Talos.T,
    Shapes.Talos.Z,
    Shapes.Talos.T
}
forms = {2, 2, 2, 3}
expectedGrid = {{"1", "1", "1", "2"},
                {"1", "3", "2", "2"},
                {"3", "3", "4", "2"},
                {"3", "4", "4", "4"}}

TEST_PlaceShapes_Automatically(grid, shapes, forms, expectedGrid)

grid = Grid.create(5, 4)
shapes = {
    Shapes.Talos.I,
    Shapes.Talos.J,
    Shapes.Talos.J,
    Shapes.Talos.Square,
    Shapes.Talos.Square,
}
forms = {2, 2, 0, 1, 1}
expectedGrid = {{"1", "1", "1", "1"},
                {"2", "3", "3", "3"},
                {"2", "2", "2", "3"},
                {"4", "4", "5", "5"},
                {"4", "4", "5", "5"}}

TEST_PlaceShapes_Automatically(grid, shapes, forms, expectedGrid)