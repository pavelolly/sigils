require "Sigils"

require "Test"

TEST_ExitOnFail = true

function TEST_Permutations_Full()
    TEST_Header("Permutaitons (Full)")

    local expectedPermutations = {
        {1, 2, 3},
        {1, 3, 2},
        {2, 1, 3},
        {2, 3, 1},
        {3, 1, 2},
        {3, 2, 1}
    }

    local i = 1
    for p in Permutations({1, 2, 3}) do
        ExpectEqual(expectedPermutations[i], p, Array.equals, "Permutation #"..i.." is wrong")
        if not TEST_res then
            TEST_PrintObjects(expectedPermutations[i], p, Array.print)
            break
        end
        i = i + 1
    end

    TEST_Footer()
end

function TEST_Permutations_Partial()
    TEST_Header("Permutaitons (Partial)")

    local expectedPermutations = {
        -- {1, 2, 3},
        -- {1, 3, 2},
        -- {2, 1, 3},
        {2, 3, 1},
        {3, 1, 2},
        {3, 2, 1}
    }

    local i = 1
    for p in Permutations({1, 2, 3}, {2, 1, 3}) do
        ExpectEqual(expectedPermutations[i], p, Array.equals, "Permutation"..i.." is wrong")
        if not TEST_res then
            TEST_PrintObjects(expectedPermutations[i], p, Array.print)
            break
        end
        i = i + 1
    end

    TEST_Footer()
end

function TEST_Matrix_rotate()
    TEST_Header("Matrix.rotate")

    local mat = {{1, 2},
                 {3, 4},
                 {5, 6}}

    local matrot0 = Matrix.rotate(mat, 0)
    local matrot1 = {{5, 3, 1},
                     {6, 4, 2}}
    local matrot2 = {{6, 5},
                     {4, 3},
                     {2, 1}}
    local matrot3 = {{2, 4, 6},
                     {1, 3, 5}}

    ExpectEqual(matrot0, mat, Matrix.equals, "Rotation 0 failed")
    ExpectNotSame(matrot0, mat, "Rotation 0 does not create new matrix")
    ExpectEqual(matrot1, Matrix.rotate(mat, 1), Matrix.equals, "Rotation 1 failed")
    ExpectEqual(matrot2, Matrix.rotate(mat, 2), Matrix.equals, "Rotation 2 failed")
    ExpectEqual(matrot3, Matrix.rotate(mat, 3), Matrix.equals, "Rotation 3(-1) failed")

    if not TEST_res then
        TEST_PrintObjects(matrot0, mat, Matrix.print)
        TEST_PrintObjects(matrot1, Matrix.rotate(mat, 1), Matrix.print)
        TEST_PrintObjects(matrot2, Matrix.rotate(mat, 2), Matrix.print)
        TEST_PrintObjects(matrot3, Matrix.rotate(mat, 3), Matrix.print)
    end

    TEST_Footer()
end

function TEST_Shapes_rotate()
    TEST_Header("Shapes.rotate")

    local I = Shapes.rotate(Shapes.I, 1)
    local Z = Shapes.Z
    local L = Shapes.rotate(Shapes.L, 2)
    local J = Shapes.rotate(Shapes.J, 1)
    local T = Shapes.rotate(Shapes.T, 1)

    ExpectEqual(I, {{1, 1, 1, 1}}, Matrix.equals, "I rotation wrong")
    ExpectEqual(Z, Shapes.Z, Matrix.equals, "Z rotation wrong")
    ExpectEqual(L, {{1, 1},
                    {0, 1},
                    {0, 1}}, Matrix.equals, "L rotation wrong")
    ExpectEqual(J, {{1, 0, 0},
                    {1, 1, 1}}, Matrix.equals, "J rotation wrong")
    ExpectEqual(T, {{0, 1},
                    {1, 1},
                    {0, 1}}, Matrix.equals, "T rotation wrong")

    ExpectEqual(Matrix.rotate(Shapes.T, 3), Matrix.rotate(Shapes.T, -1), Matrix.equals, "Rotation 3 and rotation -1 are not the same rotations")

    local function hasFields(shape)
        for _, key in ipairs({"Area", "UniqueRotationsCount"}) do
            if shape[key] == nil then return false end
        end
        return true
    end

    ExpectTrue(hasFields(I) and hasFields(Z) and hasFields(L) and hasFields(J), "Some shape does not have all needed fields")

    if not TEST_res then
        TEST_PrintObjects({{1, 1, 1, 1}}, I, Matrix.print)
        TEST_PrintObjects(Shapes.Z, Z, Matrix.print)
        TEST_PrintObjects({{1, 1},
                           {0, 1},
                           {0, 1}}, L, Matrix.print)
        TEST_PrintObjects({{1, 0, 0},
                           {1, 1, 1}}, J, Matrix.print)
        TEST_PrintObjects({{0, 1},
                           {1, 1},
                           {0, 1}}, T, Matrix.print)
        TEST_PrintObjects(Matrix.rotate(Shapes.T, 3), Matrix.rotate(Shapes.T, -1), Matrix.print)
    end


    TEST_Footer()
end


function TEST_Shapes_getOrigin()
    TEST_Header("Shapes.getOriginorigin")

    local rows1, cols1 = Shapes.getOrigin(Shapes.rotate(Shapes.L, -1))
    local rows2, cols2 = Shapes.getOrigin(Shapes.rotate(Shapes.Z, 1))
    local rows3, cols3 = Shapes.getOrigin(Shapes.I)
    local rows4, cols4 = Shapes.getOrigin(Shapes.rotate(Shapes.T, 1))
    local rows5, cols5 = Shapes.getOrigin({{0, 0, 0},
                                           {0, 0, 1},
                                           {1, 1, 0}})

    ExpectTrue(rows1 == 1 and cols1 == 3, "(L, -1) origin wrong")
    ExpectTrue(rows2 == 1 and cols2 == 2, "(Z, 1) origin wrong")
    ExpectTrue(rows3 == 1 and cols3 == 1, "(I, 0) origin wrong")
    ExpectTrue(rows4 == 1 and cols4 == 2, "(T, 1) origin wrong")
    ExpectTrue(rows5 == 2 and cols5 == 3, "made-up shape origin wrong")

    if not TEST_res then
        print("rows1, cols1", rows1, cols1, "expected: ", 1, 3)
        print("rows2, cols2", rows2, cols2, "expected: ", 1, 2)
        print("rows3, cols3", rows3, cols3, "expected: ", 1, 1)
        print("rows4, cols4", rows4, cols4, "expected: ", 1, 2)
        print("rows5, cols5", rows5, cols5, "expected: ", 2, 3)
    end

    TEST_Footer()
end


GRID_4x4_SUCCESS_1 = {{"1", "1", "1", "1"},
                      {"2", "2", "3", "3"},
                      {"4", "2", "2", "3"},
                      {"4", "4", "4", "3"}}

function TEST_PlaceShape_Success_1()
    TEST_Header("Place Shapes Manually")

    local grid = Grid.create(4, 4)

    local I = Shapes.rotate(Shapes.I, 1)
    local Z = Shapes.Z
    local L = Shapes.rotate(Shapes.L, 2)
    local J = Shapes.rotate(Shapes.J, 1)

    ExpectTrue(PlaceShape(grid, I, 1, 1), "Could not place I")
    ExpectTrue(PlaceShape(grid, Z, 2, 1), "Could not place Z")
    ExpectTrue(PlaceShape(grid, L, 2, 3), "Could not place L")
    ExpectTrue(PlaceShape(grid, J, 3, 1), "Could not place J")
    ExpectEqual(grid, GRID_4x4_SUCCESS_1, Matrix.equals, "Grid comparison failed")
    
    if not TEST_res then
        TEST_PrintObjects(GRID_4x4_SUCCESS_1, grid, Matrix.print)
    end

    TEST_Footer()
end

function TEST_PlaceShapes_Success_1()
    TEST_Header("Place Shapes Automatically (1)")

    local grid = Grid.create(4, 4)

    local I = Shapes.rotate(Shapes.I, 1)
    local Z = Shapes.Z
    local L = Shapes.rotate(Shapes.L, 2)
    local J = Shapes.rotate(Shapes.J, 1)

    ExpectTrue(PlaceShapes(grid, {I, Z, L, J}), "Could not place shapes")
    ExpectEqual(grid, GRID_4x4_SUCCESS_1, Matrix.equals, "Grid comparison failed")
    
    if not TEST_res then
        TEST_PrintObjects(GRID_4x4_SUCCESS_1, grid, Matrix.print)
    end

    TEST_Footer()
end

GRID_4x4_SUCCESS_2 = {{"1", "1", "1", "2"},
                      {"1", "3", "2", "2"},
                      {"3", "3", "4", "2"},
                      {"3", "4", "4", "4"}}

function TEST_PlaceShapes_Success_2()
    TEST_Header("Place Shapes Automatically (2)")

    local grid = Grid.create(4, 4)

    local L = Shapes.rotate(Shapes.L, 1)
    local T1 = Shapes.rotate(Shapes.T, 1)
    local Z = Shapes.rotate(Shapes.Z, 1)
    local T2 = Shapes.rotate(Shapes.T, 2)

    ExpectTrue(PlaceShapes(grid, {L, T1, Z, T2}), "Could not place shapes")
    ExpectEqual(grid, GRID_4x4_SUCCESS_2, Matrix.equals, "Grid comparison failed")
    
    if not TEST_res then
        TEST_PrintObjects(GRID_4x4_SUCCESS_2, grid, Matrix.print)
    end

    TEST_Footer()
end

function TEST_RotateAndPlaceShapes_Success_1()
    TEST_Header("RotateAndPlaceShapes (1)")

    local grid = Grid.create(4, 4)

    local I = Shapes.I
    local Z = Shapes.Z
    local L = Shapes.L
    local J = Shapes.J

    ExpectTrue(PlaceShapes(grid, Shapes.rotateMany({I, Z, L, J}, {1, 0, 2, 1})), "Could not place shapes")
    ExpectEqual(grid, GRID_4x4_SUCCESS_1, Matrix.equals, "Grid comparison failed")
    
    if not TEST_res then
        TEST_PrintObjects(GRID_4x4_SUCCESS_1, grid, Matrix.print)
    end

    TEST_Footer()
end

function TEST_RotateAndPlaceShapes_Success_2()
    TEST_Header("RotateAndPlaceShapes (2)")

    local grid = Grid.create(4, 4)

    local L  = Shapes.L
    local T1 = Shapes.T
    local Z  = Shapes.Z
    local T2 = Shapes.T

    ExpectTrue(PlaceShapes(grid, Shapes.rotateMany({L, T1, Z, T2}, {1, 1, 1, 2})), "Could not place shapes")
    ExpectEqual(grid, GRID_4x4_SUCCESS_2, Matrix.equals, "Grid comparison failed")

    if not TEST_res then
        TEST_PrintObjects(GRID_4x4_SUCCESS_2, grid, Matrix.print)
    end

    TEST_Footer()
end

function TEST_RotateShapes_Rotations()
    TEST_Header("RotateShapes (Rotations)")

    local I = Shapes.I
    local L = Shapes.L

    local expectedRotations = {
        {0, 0},
        {0, 1},
        {0, 2},
        {0, 3},
        {1, 0},
        {1, 1},
        {1, 2},
        {1, 3},
    }

    local i = 1
    for rshapes, rotations in RotatedShapes({I, L}) do
        ExpectEqual(rotations, expectedRotations[i], Array.equals, "Rotation #"..i.." is wrong")
        if not TEST_res then
            TEST_PrintObjects(expectedRotations[i], rotations, Array.print)
            break
        end
        i = i + 1
    end

    TEST_Footer()
end

function TEST_RotateShapes_Rotated_Shapes()
    TEST_Header("RotateShapes (Rotated Shapes)")

    local I = Shapes.I
    local L = Shapes.L

    local expectedRotations = {
        {0, 0},
        {0, 1},
        {0, 2},
        {0, 3},
        {1, 0},
        {1, 1},
        {1, 2},
        {1, 3},
    }

    local expectedRotatedShapes = {}
    for i = 1,#expectedRotations do
        expectedRotatedShapes[i] = Shapes.rotateMany({I, L}, expectedRotations[i])
    end

    local i = 1
    for rshapes, rotations in RotatedShapes({I, L}) do
        ExpectEqual(rshapes, expectedRotatedShapes[i],
                    function (shapes1, shapes2)
                        if #shapes1 ~= #shapes2 then return false end
                        for i = 1,#shapes1 do
                            if not Matrix.equals(shapes1[i], shapes2[i]) then return false end
                        end
                        return true
                    end,
                    "Rotation #"..i.." is wrong")
        if not TEST_res then
            print("\nRotations:")
            TEST_PrintObjects(expectedRotations[i], rotations, Array.print)
            print("\nShapes:")
            TEST_PrintObjects(expectedRotatedShapes[i], rshapes, Shapes.printMany)
            break
        end
        i = i + 1
    end

    TEST_Footer()
end

function TEST_RotateShapes_NonEmptyInitialRotations()
    TEST_Header("RotateShapes (non-empty initial rotations)")

    local I = Shapes.I
    local L = Shapes.L

    local expectedRotations = {
        -- {0, 0},
        -- {0, 1},
        -- {0, 2},
        {0, 3},
        {1, 0},
        {1, 1},
        {1, 2},
        {1, 3},
    }

    local i = 1
    -- need AssertTrue here
    for rshapes, rotations in RotatedShapes({I, L}, {0, 2}) do
        ExpectEqual(rotations, expectedRotations[i], Array.equals, "Rotation #"..i.." is wrong")
        if not TEST_res then
            TEST_PrintObjects(expectedRotations[i], rotations, Array.print)
            break
        end
        i = i + 1
    end

    TEST_Footer()
end

function TEST_SuitableRotations_1()
    TEST_Header("SuitableRotations (1)")

    local grid = Grid.create(4, 4)

    local I = Shapes.I
    local Z = Shapes.Z
    local L = Shapes.L
    local J = Shapes.J

    local suitableRotations = {}
    for rotations in SuitableRotations(grid, {I, Z, L, J}) do
        table.insert(suitableRotations, rotations)
    end

    print("\nFound rotations:")
    for _, rotations in ipairs(suitableRotations) do
        Array.print(rotations)
    end

    ExpectTrue(Array.findIf(suitableRotations, function(elem) return Array.equals(elem, {1, 0, 2, 1}) end), "Could not find rotation")

    for i, rotations in ipairs(suitableRotations) do
        ExpectTrue(PlaceShapes(grid, Shapes.rotateMany({I, Z, L, J}, rotations)), "Failed to place rotation #"..i)
        if not TEST_res then
            TEST_PrintObjects(GRID_4x4_SUCCESS_1, grid, Matrix.print)
        end
        Grid.clear(grid)
    end

    if not TEST_res then
        print("Expected to find:")
        Array.print({1, 0, 2, 1})
    end

    TEST_Footer()
end

function TEST_SuitableRotations_2()
    TEST_Header("SuitableRotations (2)")

    local grid = Grid.create(4, 4)

    local L  = Shapes.L
    local T1 = Shapes.T
    local Z  = Shapes.Z
    local T2 = Shapes.T

    local suitableRotations = {}
    for rotations in SuitableRotations(grid, {L, T1, Z, T2}) do
        table.insert(suitableRotations, rotations)
    end

    print("\nFound rotations:")
    for _, rotations in ipairs(suitableRotations) do
        Array.print(rotations)
    end

    ExpectTrue(Array.findIf(suitableRotations, function(elem) return Array.equals(elem, {1, 1, 1, 2}) end), "Could not find rotation")

    for i, rotations in ipairs(suitableRotations) do
        ExpectTrue(PlaceShapes(grid, Shapes.rotateMany({L, T1, Z, T2}, rotations)), "Failed to place rotation #"..i)
    end

    if not TEST_res then
        print("Expected to find:")
        Array.print({1, 1, 1, 2})
        TEST_PrintObjects(grid, GRID_4x4_SUCCESS_1, Matrix.print)
    end

    TEST_Footer()
end

function TEST_SuitablePermutations_1()
    TEST_Header("SuitablePermutations (1)")

    local grid = Grid.create(4, 4)

    local I = Shapes.I
    local Z = Shapes.Z
    local L = Shapes.L
    local J = Shapes.J

    local shapes = {Z, L, I, J} -- random

    local permutations = {}
    for permutation, permutationRotations in SuitablePermutations(grid, shapes) do
        permutations[permutation] = permutationRotations
    end

    print("\nFound:")
    for p, rs in pairs(permutations) do
        print("Permutation:")
        Array.print(p)
        print("Rotations:")
        for _, r in ipairs(rs) do
            Array.print(r)
        end
        print("-------------------------")
    end

    local expectedPermutation = {3, 1, 2, 4}
    local expectedRotations   = {1, 0, 2, 1}

    for p, rs in pairs(permutations) do
        if Array.equals(p, expectedPermutation) then
            for _, r in ipairs(rs) do
                if Array.equals(r, expectedRotations) then goto found end
            end
        end
    end
    ExpectTrue(false, "")
    print("Falied to find permutaion with rotation")
    print("Expected permutation: ")
    Array.print(expectedPermutation)
    print("Expected rotations: ")
    Array.print(expectedRotations)

::found::
    for p, rs in pairs(permutations) do
        for i, r in ipairs(rs) do
            rp = Shapes.rotateMany(Permute(shapes, p), r)
            if not PlaceShapes(grid, rp) then
                io.write("Permutaion: "); Array.print(p)
                io.write("Rotation: "); Array.print(r)
                Shapes.printMany(rp)
                io.write("\n")
                io.write("does not fit into grid")
                ExpectTrue(false, "found permutaion does not actually fit into grid")
                Grid.print(grid)
                goto footer
            end
            Grid.clear(grid)
        end
    end

::footer::
    TEST_Footer()
end

function TEST_SuitablePermutations_2()
    TEST_Header("SuitablePermutations (2)")

    local grid = Grid.create(4, 4)

    local L  = Shapes.L
    local T1 = Shapes.T
    local Z  = Shapes.Z
    local T2 = Shapes.T

    local shapes = {Z, T2, T1, L} -- random

    local permutations = {}
    for permutation, permutationRotations in SuitablePermutations(grid, shapes) do
        permutations[permutation] = permutationRotations
    end

    print("\nFound:")
    for p, rs in pairs(permutations) do
        print("Permutation:")
        Array.print(p)
        print("Rotations:")
        for _, r in ipairs(rs) do
            Array.print(r)
        end
        print("-------------------------")
    end

    local expectedPermutation = {4, 2, 1, 3}
    local expectedRotations   = {1, 1, 1, 2}

    for p, rs in pairs(permutations) do
        if Array.equals(p, expectedPermutation) then
            for _, r in ipairs(rs) do
                if Array.equals(r, expectedRotations) then goto found end
            end
        end
    end
    ExpectTrue(false, "")
    print("Falied to find permutaion with rotation")
    print("Expected permutation: ")
    Array.print(expectedPermutation)
    print("Expected rotations: ")
    Array.print(expectedRotations)

::found::
    for p, rs in pairs(permutations) do
        for i, r in ipairs(rs) do
            rp = Shapes.rotateMany(Permute(shapes, p), r)
            if not PlaceShapes(grid, rp) then
                io.write("Permutaion: "); Array.print(p)
                io.write("Rotation: "); Array.print(rs)
                Shapes.printMany(rp)
                io.write("\n")
                io.write("does not fit into grid")
                ExpectedTrue(false, "found permutaion does not actually fir into grid")
                goto footer
            end
            Grid.clear(grid)
        end
    end

::footer::

    TEST_Footer()
end

TEST_Permutations_Full()
TEST_Permutations_Partial()

TEST_Matrix_rotate()
TEST_Shapes_rotate()

TEST_Shapes_getOrigin()

TEST_PlaceShape_Success_1()
TEST_PlaceShapes_Success_1()
TEST_PlaceShapes_Success_2()

TEST_RotateAndPlaceShapes_Success_1()
TEST_RotateAndPlaceShapes_Success_2()

TEST_RotateShapes_Rotations()
TEST_RotateShapes_Rotated_Shapes()
TEST_RotateShapes_NonEmptyInitialRotations()

TEST_SuitableRotations_1()
TEST_SuitableRotations_2()

TEST_SuitablePermutations_1()
TEST_SuitablePermutations_2()