require "Test"

require "Sigils"

local function PlaceShapes_Manually_Helper(grid, shapes, forms, blocks, expectedGrid)
    for i, shape in ipairs(shapes) do
        Test.ExpectTrue(PlaceShape(grid, shape, forms[i], table.unpack(blocks[i])), "Could not place shape #"..i)
    end
    Test.ExpectEqual(expectedGrid, grid, "Grid is not what expected")
end

GRID_4x4_1 = {{"1", "1", "1", "1"},
              {"2", "2", "3", "3"},
              {"4", "2", "2", "3"},
              {"4", "4", "4", "3"}}

function TEST_PlaceShapes_Manually_Success_1()
    Test.Header("Place Shapes Manually (1)")

    local grid = Grid.create(4, 4)

    local I = Shapes.Talos.I
    local Z = Shapes.Talos.Z
    local L = Shapes.Talos.L
    local J = Shapes.Talos.J

    PlaceShapes_Manually_Helper(grid, {I, Z, L, J}, {2, 1, 3, 2}, {{1, 1}, {2, 1}, {2, 3}, {3, 1}}, GRID_4x4_1)

    Test.Footer()
end

GRID_4x4_2 = {{"1", "1", "1", "2"},
              {"1", "3", "2", "2"},
              {"3", "3", "4", "2"},
              {"3", "4", "4", "4"}}

function TEST_PlaceShapes_Manually_Success_2()
    Test.Header("Place Shapes Manually (2)")

    local grid = Grid.create(4, 4)

    local L  = Shapes.Talos.L
    local T  = Shapes.Talos.T
    local Z  = Shapes.Talos.Z
    local T2 = Shapes.Talos.T

    PlaceShapes_Manually_Helper(grid, {L, T, Z, T2}, {2, 2, 2, 3},  {{1, 1}, {1, 3}, {2, 1}, {3, 2}}, GRID_4x4_2)

    Test.Footer()
end

GRID_5x4_1 = {{"1", "1", "1", "1"},
              {"2", "3", "3", "3"},
              {"2", "2", "2", "3"},
              {"4", "4", "5", "5"},
              {"4", "4", "5", "5"}}

function TEST_PlaceShapes_Manually_Success_3()
    Test.Header("Place Shapes Manually (3)")

    local grid = Grid.create(5, 4)

    local I   = Shapes.Talos.I
    local J   = Shapes.Talos.J
    local J2  = Shapes.Talos.J
    local Sq  = Shapes.Talos.Square
    local Sq2 = Shapes.Talos.Square

    PlaceShapes_Manually_Helper(grid, {I, J, J2, Sq, Sq2}, {2, 2, 0, 1, 1}, {{1, 1}, {2, 1}, {2, 2}, {4, 1}, {4, 3}}, GRID_5x4_1)

    Test.Footer()
end

TEST_PlaceShapes_Manually_Success_1()
TEST_PlaceShapes_Manually_Success_2()
TEST_PlaceShapes_Manually_Success_3()
