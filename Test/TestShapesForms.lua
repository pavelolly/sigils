require "Test"

require "Sigils"

I = Shapes.Talos.I
L = Shapes.Talos.L
shapes = {I, L}

function TEST_ShapesForms(initialRotations)
    Test.Header("ShapesForms"..((not initialRotations and "") or " with non-nil initails forms"))

    local i = 1
    for forms in ShapesForms({I, L}, initialRotations) do
        if not expected_forms[i] then
            Test.ExpectTrue(false, "Forms #"..i.." are not expected")
            Array.print(forms)
            break
        end

        Test.ExpectEqual(setmetatable(expected_forms[i], {__eq = Array.equals, print = Array.print}), forms,
                    "Forms #"..i.." are wrong")

        i = i + 1
    end
    if expected_forms[i] then
        Test.ExpectTrue(false, "Forms #"..i.." are not reached")
        Array.print(expected_forms[i])
    end

    Test.Footer()
end

expected_forms = {
    {1, 1},
    {1, 2},
    {1, 3},
    {1, 4},
    {2, 1},
    {2, 2},
    {2, 3},
    {2, 4},
}

TEST_ShapesForms()

expected_forms = {
    -- {1, 1},
    -- {1, 2},
    -- {1, 3},
    -- {1, 4},
    {2, 1},
    {2, 2},
    {2, 3},
    {2, 4},
}

TEST_ShapesForms({1, 4})

expected_forms = {
    -- {1, 1},
    -- {1, 2},
    -- {1, 3},
    -- {1, 4},
    -- {2, 1},
    -- {2, 2},
    -- {2, 3},
    {2, 4},
}

TEST_ShapesForms({2, 3})

expected_forms = {
    -- {1, 1},
    -- {1, 2},
    -- {1, 3},
    -- {1, 4},
    -- {2, 1},
    -- {2, 2},
    -- {2, 3},
    -- {2, 4},
}

TEST_ShapesForms({2, 4})