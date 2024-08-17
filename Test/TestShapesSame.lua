require "Test"

require "Shapes"

function TEST_ShapesSame()
    Test.Header("Shapes.same")

    -- Shapes have __eq = Shapes.same
    Test.ExpectEqual(Shapes.Talos.I, Shapes.Talos.I,  "Shapes.Talos.I and Shapes.Talos.I are not equal")
    Test.ExpectEqual(Shapes.Talos.I, Shapes.Lonpos.I, "Shapes.Talos.I and Shapes.Lonpos.I are not equal")

    Test.ExpectNotEqual(Shapes.Talos.I, Shapes.Talos.Square, "Shapes.Talos.I, 0 and Shapes.Talos.Square are equal")
    Test.ExpectNotEqual(Shapes.Talos.L, Shapes.Talos.J,      "Shapes.Talos.L, 0 and Shapes.Talos.J are equal")
    Test.ExpectNotEqual(Shapes.Talos.L, Shapes.Lonpos.L,     "Shapes.Talos.L, 0 and Shapes.Lonpos.L are equal")

    Test.Footer()
end

TEST_ShapesSame()