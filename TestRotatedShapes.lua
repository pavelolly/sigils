require "Test"

require "Sigils"

I = Shapes.I
L = Shapes.L
shapes = {I, L}

function TEST_RotatedShapes(initialRotations)
    Test.Header("RotatedShapes"..((not initialRotations and "") or " with non-nil initails rotations"))

    local i = 1
    for rshapes, rotations in RotatedShapes({I, L}, initialRotations) do
        if not expectedRotations[i] then
            Test.ExpectTrue(false, "Rotations #"..i.." are not expected")
            Array.print(rotations)
            break
        end

        Test.ExpectEqual(setmetatable(expectedRotations[i], {__eq = Array.equals, print = Array.print}), rotations,
                    "Rotations #"..i.." are wrong")

        Test.ExpectEqual(setmetatable(Shapes.rotateMany(shapes, rotations), {__eq = DeepCopy, print = Shapes.printMany}), rshapes,
                    "Rotated shapes #"..i.." are wrong")
        i = i + 1
    end
    if expectedRotations[i] then
        Test.ExpectTrue(false, "Rotations #"..i.." are not reached")
        Array.print(expectedRotations[i])
    end

    Test.Footer()
end

expectedRotations = {
    {0, 0},
    {0, 1},
    {0, 2},
    {0, 3},
    {1, 0},
    {1, 1},
    {1, 2},
    {1, 3},
}

TEST_RotatedShapes()

expectedRotations = {
    -- {0, 0},
    -- {0, 1},
    -- {0, 2},
    -- {0, 3},
    {1, 0},
    {1, 1},
    {1, 2},
    {1, 3},
}

TEST_RotatedShapes({0, 3})

expectedRotations = {
    -- {0, 0},
    -- {0, 1},
    -- {0, 2},
    -- {0, 3},
    -- {1, 0},
    -- {1, 1},
    -- {1, 2},
    {1, 3},
}

TEST_RotatedShapes({1, 2})

expectedRotations = {
    -- {0, 0},
    -- {0, 1},
    -- {0, 2},
    -- {0, 3},
    -- {1, 0},
    -- {1, 1},
    -- {1, 2},
    -- {1, 3},
}

TEST_RotatedShapes({1, 3})