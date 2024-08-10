require "Test"

require "Sigils"

local function PlaceShapes_Manually_Helper(grid, shapes, blocks, expectedGrid)
    for i, shape in ipairs(shapes) do
        Test.ExpectTrue(PlaceShape(grid, shape, table.unpack(blocks[i])), "Could not place shape #"..i)
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

    local I = Shapes.rotate(Shapes.Talos.I, 1)
    local Z = Shapes.Talos.Z
    local L = Shapes.rotate(Shapes.Talos.L, 2)
    local J = Shapes.rotate(Shapes.Talos.J, 1)

    PlaceShapes_Manually_Helper(grid, {I, Z, L, J}, {{1, 1}, {2, 1}, {2, 3}, {3, 1}}, GRID_4x4_1)

    Test.Footer()
end

GRID_4x4_2 = {{"1", "1", "1", "2"},
              {"1", "3", "2", "2"},
              {"3", "3", "4", "2"},
              {"3", "4", "4", "4"}}

function TEST_PlaceShapes_Manually_Success_2()
    Test.Header("Place Shapes Manually (2)")

    local grid = Grid.create(4, 4)

    local L  = Shapes.rotate(Shapes.Talos.L, 1)
    local T  = Shapes.rotate(Shapes.Talos.T, 1)
    local Z  = Shapes.rotate(Shapes.Talos.Z, 1)
    local T2 = Shapes.rotate(Shapes.Talos.T, 2)

    PlaceShapes_Manually_Helper(grid, {L, T, Z, T2}, {{1, 1}, {1, 3}, {2, 1}, {3, 2}}, GRID_4x4_2)

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

    local I   = Shapes.rotate(Shapes.Talos.I, 1)
    local J   = Shapes.rotate(Shapes.Talos.J, 1)
    local J2  = Shapes.rotate(Shapes.Talos.J, -1)
    local Sq  = Shapes.Talos.Square
    local Sq2 = Shapes.Talos.Square

    PlaceShapes_Manually_Helper(grid, {I, J, J2, Sq, Sq2}, {{1, 1}, {2, 1}, {2, 2}, {4, 1}, {4, 3}}, GRID_5x4_1)

    Test.Footer()
end

TEST_PlaceShapes_Manually_Success_1()
TEST_PlaceShapes_Manually_Success_2()
TEST_PlaceShapes_Manually_Success_3()
