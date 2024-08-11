require "Test"

require "Sigils"


GRID_5x4_1 = {{"1", "1", "1", "1"},
              {"2", "3", "3", "3"},
              {"2", "2", "2", "3"},
              {"4", "4", "5", "5"},
              {"4", "4", "5", "5"}}

function TEST_PlaceShapes_Automatically_Success_3()
    Test.Header("Place Shapes Automatically (3)")

    local grid = Grid.create(5, 4)

    local I   = Shapes.rotate(Shapes.Talos.I, 1)
    local J   = Shapes.rotate(Shapes.Talos.J, 1)
    local J2  = Shapes.rotate(Shapes.Talos.J, -1)
    local Sq  = Shapes.Talos.Square
    local Sq2 = Shapes.Talos.Square

    Test.ExpectTrue(PlaceShapes(grid, {I, J, J2, Sq, Sq2}), "Could not place shapes")
    Test.ExpectEqual(grid, GRID_5x4_1, "Grid is not what expected")

    Test.Footer()
end

function TEST_PlaceShapes_Automatically(grid, shapes, expectedGrid)
    Test.Header("Place Shapes Automatically")

    Test.ExpectTrue(PlaceShapes(grid, shapes), "Could not place shapes")
    Test.ExpectEqual(grid, expectedGrid, "Grid is not what expected")

    Test.Footer()
end

grid = Grid.create(4, 4)
shapes = {
    Shapes.rotate(Shapes.Talos.I, 1),
    Shapes.Talos.Z,
    Shapes.rotate(Shapes.Talos.L, 2),
    Shapes.rotate(Shapes.Talos.J, 1),
}
expectedGrid = {{"1", "1", "1", "1"},
                {"2", "2", "3", "3"},
                {"4", "2", "2", "3"},
                {"4", "4", "4", "3"}}

TEST_PlaceShapes_Automatically(grid, shapes, expectedGrid)

grid = Grid.create(4, 4)
shapes = {
    Shapes.rotate(Shapes.Talos.L, 1),
    Shapes.rotate(Shapes.Talos.T, 1),
    Shapes.rotate(Shapes.Talos.Z, 1),
    Shapes.rotate(Shapes.Talos.T, 2),
}
expectedGrid = {{"1", "1", "1", "2"},
                {"1", "3", "2", "2"},
                {"3", "3", "4", "2"},
                {"3", "4", "4", "4"}}

TEST_PlaceShapes_Automatically(grid, shapes, expectedGrid)

grid = Grid.create(5, 4)
shapes = {
    Shapes.rotate(Shapes.Talos.I, 1),
    Shapes.rotate(Shapes.Talos.J, 1),
    Shapes.rotate(Shapes.Talos.J, -1),
    Shapes.Talos.Square,
    Shapes.Talos.Square,
}

expectedGrid = {{"1", "1", "1", "1"},
                {"2", "3", "3", "3"},
                {"2", "2", "2", "3"},
                {"4", "4", "5", "5"},
                {"4", "4", "5", "5"}}

TEST_PlaceShapes_Automatically(grid, shapes, expectedGrid)