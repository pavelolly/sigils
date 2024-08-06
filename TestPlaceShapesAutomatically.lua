require "Test"

require "Sigils"

GRID_4x4_1 = {{"1", "1", "1", "1"},
              {"2", "2", "3", "3"},
              {"4", "2", "2", "3"},
              {"4", "4", "4", "3"}}

function TEST_PlaceShapes_Automatically_Success_1()
    Test.Header("Place Shapes Automatically (1)")

    local grid = Grid.create(4, 4)

    local I = Shapes.rotate(Shapes.I, 1)
    local Z = Shapes.Z
    local L = Shapes.rotate(Shapes.L, 2)
    local J = Shapes.rotate(Shapes.J, 1)

    Test.ExpectTrue(PlaceShapes(grid, {I, Z, L, J}), "Could not place shapes")
    Test.ExpectEqual(grid, GRID_4x4_1, "Grid is not what expected")

    Test.Footer()
end

GRID_4x4_2 = {{"1", "1", "1", "2"},
              {"1", "3", "2", "2"},
              {"3", "3", "4", "2"},
              {"3", "4", "4", "4"}}

function TEST_PlaceShapes_Automatically_Success_2()
    Test.Header("Place Shapes Automatically (2)")

    local grid = Grid.create(4, 4)

    local L = Shapes.rotate(Shapes.L, 1)
    local T = Shapes.rotate(Shapes.T, 1)
    local Z = Shapes.rotate(Shapes.Z, 1)
    local T2 = Shapes.rotate(Shapes.T, 2)

    Test.ExpectTrue(PlaceShapes(grid, {L, T, Z, T2}), "Could not place shapes")
    Test.ExpectEqual(grid, GRID_4x4_2, "Grid is not what expected")

    Test.Footer()
end

GRID_5x4_1 = {{"1", "1", "1", "1"},
              {"2", "3", "3", "3"},
              {"2", "2", "2", "3"},
              {"4", "4", "5", "5"},
              {"4", "4", "5", "5"}}

function TEST_PlaceShapes_Automatically_Success_3()
    Test.Header("Place Shapes Automatically (3)")

    local grid = Grid.create(5, 4)

    local I = Shapes.rotate(Shapes.I, 1)
    local J = Shapes.rotate(Shapes.J, 1)
    local J2 = Shapes.rotate(Shapes.J, -1)
    local Sq = Shapes.Square
    local Sq2 = Shapes.Square

    Test.ExpectTrue(PlaceShapes(grid, {I, J, J2, Sq, Sq2}), "Could not place shapes")
    Test.ExpectEqual(grid, GRID_5x4_1, "Grid is not what expected")

    Test.Footer()
end

TEST_PlaceShapes_Automatically_Success_1()
TEST_PlaceShapes_Automatically_Success_2()
TEST_PlaceShapes_Automatically_Success_3()