require "Test"

require "Sigils"

GRID_4x4_1 = {{"1", "1", "1", "1"},
              {"2", "2", "3", "3"},
              {"4", "2", "2", "3"},
              {"4", "4", "4", "3"}}

function TEST_Rotate_And_Place_Shapes_1()
    Test.Header("Rotate and place shapes (1)")

    local grid = Grid.create(4, 4)

    local I = Shapes.Talos.I
    local Z = Shapes.Talos.Z
    local L = Shapes.Talos.L
    local J = Shapes.Talos.J

    local rshapes = Shapes.rotateMany({I, Z, L, J}, {1, 0, 2, 1})
    Test.ExpectTrue(PlaceShapes(grid, rshapes), "Could not place shapes")
    Test.ExpectEqual(grid, GRID_4x4_1, "Grid is not what expected")

    Test.Footer()
end

GRID_4x4_2 = {{"1", "1", "1", "2"},
              {"1", "3", "2", "2"},
              {"3", "3", "4", "2"},
              {"3", "4", "4", "4"}}

function TEST_Rotate_And_Place_Shapes_2()
    Test.Header("Rotate and place shapes (2)")

    local grid = Grid.create(4, 4)

    local L  = Shapes.Talos.L
    local T  = Shapes.Talos.T
    local Z  = Shapes.Talos.Z
    local T2 = Shapes.Talos.T

    local rshapes = Shapes.rotateMany({L, T, Z, T2}, {1, 1, 1, 2})
    Test.ExpectTrue(PlaceShapes(grid, rshapes), "Could not place shapes")
    Test.ExpectEqual(grid, GRID_4x4_2, "Grid is not what expected")

    Test.Footer()
end

GRID_5x4_1 = {{"1", "1", "1", "1"},
              {"2", "3", "3", "3"},
              {"2", "2", "2", "3"},
              {"4", "4", "5", "5"},
              {"4", "4", "5", "5"}}

function TEST_Rotate_And_Place_Shapes_3()
    Test.Header("Rotate and place shapes (3)")

    local grid = Grid.create(5, 4)

    local I   = Shapes.Talos.I
    local J   = Shapes.Talos.J
    local J2  = Shapes.Talos.J
    local Sq  = Shapes.Talos.Square
    local Sq2 = Shapes.Talos.Square

    local rshapes = Shapes.rotateMany({I, J, J2, Sq, Sq2}, {1, 1, 3, 0, 0})
    Test.ExpectTrue(PlaceShapes(grid, rshapes), "Could not place shapes")
    Test.ExpectEqual(grid, GRID_5x4_1, "Grid is not what expected")

    Test.Footer()
end

TEST_Rotate_And_Place_Shapes_1()
TEST_Rotate_And_Place_Shapes_2()
TEST_Rotate_And_Place_Shapes_3()