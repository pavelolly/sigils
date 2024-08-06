require "Test"

require "Shapes"

function TEST_ShapesSame()
    Test.Header("Shapes.same")

    -- Shapes have __eq = Shapes.same
    Test.ExpectEqual(Shapes.I,                   Shapes.I,                    "(Shapes.I, 0) and (Shapes.I, 0) are not equal")
    Test.ExpectEqual(Shapes.rotate(Shapes.I, 1), Shapes.I,                    "(Shapes.I, 1) and (Shapes.I, 0) are not equal")
    Test.ExpectEqual(Shapes.rotate(Shapes.I, 2), Shapes.rotate(Shapes.I, 3),  "(Shapes.I, 2) and (Shapes.I, 3) are not equal")
    Test.ExpectEqual(Shapes.rotate(Shapes.Z, 2), Shapes.rotate(Shapes.Z, -1), "(Shapes.Z, 2) and (Shapes.Z, -1) are not equal")
    Test.ExpectEqual(Shapes.rotate(Shapes.T, 2), Shapes.rotate(Shapes.T, 0), "(Shapes.T, 2) and (Shapes.T, 0) are not equal")

    Test.ExpectNotEqual(Shapes.I,                   Shapes.Square,              "(Shapes.I, 0) and (Shapes.Square, 0) are equal")
    Test.ExpectNotEqual(Shapes.L,                   Shapes.J,                   "(Shapes.L, 0) and (Shapes.J, 0) are equal")
    Test.ExpectNotEqual(Shapes.rotate(Shapes.S, 1), Shapes.rotate(Shapes.Z, 3), "(Shapes.S, 1) and (Shapes.Z, 3) are equal")

    Test.Footer()
end

TEST_ShapesSame()