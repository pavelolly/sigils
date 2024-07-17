require "sigils"


local function ReportExpectationFailed(msg)
    print("Expectaion falied:")
    print("\t"..msg)
    -- print()
end

local function DeepEquals(obj1, obj2)
    if not (type(obj1) == "table" and type(obj2) == "table") then
        return obj1 == obj2
    end

    if rawlen(obj1) ~= rawlen(obj2) then
        return false
    end

    for k, v in next, obj1 do
        if not DeepEquals(v, obj2[k]) then return false end
    end
    return true
end

local function ExpectTrue(condition, msg)
    msg = msg or 'Condition is false'

    if not condition then
        ReportExpectationFailed(msg)
        return false
    end

    return true
end

local function ExpectDeepEquals(obj1, obj2, msg)
    msg = msg or "objects are not deeply equal"
    return ExpectTrue(DeepEquals(obj1, obj2), msg)
end

local function PrintNextTestNumber()
    test_number = test_number or 1
    io.write(string.format("Test %d: ", test_number))
    test_number = test_number + 1
end

local function TEST_FillEntireFieldManually()
    PrintNextTestNumber()

    local grid = GetNewGrid(4, 4)
    local shapes = {Matrix.rotate(Shapes.I, 1),
                    Matrix.rotate(Shapes.Z, 0),
                    Matrix.rotate(Shapes.L, 2),
                    Matrix.rotate(Shapes.J, 1)}
    local res = ExpectTrue(PlaceShape(grid, shapes[1]), "Could not place I")
    res = ExpectTrue(PlaceShape(grid, shapes[2], 2, 1), "Could not place Z")
    res = ExpectTrue(PlaceShape(grid, shapes[3], 2, 3), "Could not place L")
    res = ExpectTrue(PlaceShape(grid, shapes[4], 3, 1), "Could not place J")

    local expectedgrid = {
        {1, 1, 1, 1},
        {2, 2, 3, 3},
        {4, 2, 2, 3},
        {4, 4, 4, 3}
    }
    res = ExpectTrue(Matrix.equals(grid, expectedgrid), "Grid is not what expected")

    if not res then
        print("Expected grid:")
        Matrix.print(expectedgrid)
        print("But got:")
        grid:printInfo()
    else
        print("Passed")
    end
end

local function TEST_CannotPlaceThirdShapeManually()
    PrintNextTestNumber()

    local grid = GetNewGrid(4, 4)
    local shapes = {Matrix.rotate(Shapes.I, 1),
                    Matrix.rotate(Shapes.Z, 0),
                    Matrix.rotate(Shapes.L, 2),
                    Matrix.rotate(Shapes.J, 1)}

    local res = ExpectTrue(PlaceShape(grid, shapes[1]), "Could not place I")
    res = ExpectTrue(PlaceShape(grid, shapes[2], 2, 1), "Could not place Z")
    res = ExpectTrue(not PlaceShape(grid, shapes[3], 2, 2), "Could place L")
    res = ExpectTrue(PlaceShape(grid, shapes[4], 3, 1), "Could not place J")

    local expectedgrid = {
        {1, 1, 1, 1},
        {2, 2, 0, 0},
        {3, 2, 2, 0},
        {3, 3, 3, 0}
    }
    res = ExpectTrue(Matrix.equals(grid, expectedgrid), "Grid is not what expected")

    if not res then
        print("Expected grid:")
        Matrix.print(expectedgrid)
        print("But got:")
        grid:printInfo()
    else
        print("Passed")
    end
end

local function TEST_FillEntireFieldAutomatically()
    PrintNextTestNumber()

    local grid = GetNewGrid(4, 4)
    local shapes = {Matrix.rotate(Shapes.I, 1),
                    Matrix.rotate(Shapes.Z, 0),
                    Matrix.rotate(Shapes.L, 2),
                    Matrix.rotate(Shapes.J, 1)}
    res = ExpectTrue(PlaceShapes(grid, shapes), "Could not place shapes automatically")

    local expectedgrid = {
        {1, 1, 1, 1},
        {2, 2, 3, 3},
        {4, 2, 2, 3},
        {4, 4, 4, 3}
    }
    if not res then
        print("Expected grid:")
        Matrix.print(expectedgrid)
        print("But got:")
        grid:printInfo()
    else
        print("Passed")
    end
end

local function TEST_CannotPlaceThirdShapeAutomatically()
    PrintNextTestNumber()

    local grid = GetNewGrid(4, 4)
    local shapes = {Matrix.rotate(Shapes.I, 1),
                    Matrix.rotate(Shapes.Z, 0),
                    Matrix.rotate(Shapes.L, 0),
                    Matrix.rotate(Shapes.J, 1)}
    
    local res = ExpectTrue(not PlaceShapes(grid, shapes), "Could place shapes automatically")

    local expectedgrid = {
        {1, 1, 1, 1},
        {2, 2, 0, 0},
        {0, 2, 2, 0},
        {0, 0, 0, 0}
    }
    res = ExpectTrue(Matrix.equals(grid, expectedgrid), "Grid is not what expected")

    if not res then
        print("Expected grid:")
        Matrix.print(expectedgrid)
        print("But got:")
        grid:printInfo()
    else
        print("Passed")
    end
end

local function TEST_FindProperRotation()
    PrintNextTestNumber()

    local grid = GetNewGrid(4, 4)
    local shapes = {Shapes.I,
                    Shapes.Z,
                    Shapes.L,
                    Shapes.J}

    local rotations = FindAnyRotation(grid, shapes)

    local expectedRotations = {1, 0, 2, 1}
    local expectedgrid = {
        {1, 1, 1, 1},
        {2, 2, 3, 3},
        {4, 2, 2, 3},
        {4, 4, 4, 3}
    }

    local res = ExpectTrue(Array.equals(rotations, expectedRotations), "Rotations are not what expected")    
    res = ExpectTrue(Matrix.equals(grid, expectedgrid), "Grid is not what expected")

    if not res then
        io.write("Expected rotations: "); Array.print(expectedRotations)
        print("Expected grid: ")
        Matrix.print(expectedgrid)
        print("But got: ")
        io.write("rotations: "); Array.print(rotations)
        print("grid: ")
        grid:printInfo()
    else
        print("Passed")
    end
end

-- TEST_FillEntireFieldManually()
-- TEST_CannotPlaceThirdShapeManually()
-- TEST_FillEntireFieldAutomatically()
-- TEST_CannotPlaceThirdShapeAutomatically()
-- TEST_FindProperRotation()
-- TEST_FindProperPermutation()