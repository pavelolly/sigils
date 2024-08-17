require "Test"

require "Shapes"

function TEST_Shapes_getOrigin()
    Test.Header("Shapes.getOriginorigin: columnwise = false")

    local rows1, cols1 = Shapes.getOrigin(Shapes.Talos.L, 4)
    local rows2, cols2 = Shapes.getOrigin(Shapes.Talos.Z, 2)
    local rows3, cols3 = Shapes.getOrigin(Shapes.Talos.I)
    local rows4, cols4 = Shapes.getOrigin(Shapes.Talos.T, 2)
    local rows5, cols5 = Shapes.getOrigin({Forms = {
                                                    {{0, 0, 0},
                                                     {0, 0, 1},
                                                     {1, 1, 0}}
                                                    },
                                           UniqueRotationsCount = 1})

    Test.ExpectEqual(rows1, 1, "(L, -1) origin row wrong")
    Test.ExpectEqual(cols1, 3, "(L, -1) origin col wrong")

    Test.ExpectEqual(rows2, 1, "(Z, 1) origin row wrong")
    Test.ExpectEqual(cols2, 2, "(Z, 1) origin col wrong")

    Test.ExpectEqual(rows3, 1, "(I, 0) origin row wrong")
    Test.ExpectEqual(cols3, 1, "(I, 0) origin col wrong")

    Test.ExpectEqual(rows4, 1, "(T, 1) origin row wrong")
    Test.ExpectEqual(cols4, 2, "(T, 1) origin col wrong")

    Test.ExpectEqual(rows5, 2, "made-up shape origin row wrong")
    Test.ExpectEqual(cols5, 3, "made-up shape origin col wrong")
    
    Test.Footer()
end

function TEST_Shapes_getOrigin_columnwise()
    Test.Header("Shapes.getOriginorigin: columnwise = true")

    local rows1, cols1 = Shapes.getOrigin(Shapes.Talos.L, 4, true)
    local rows2, cols2 = Shapes.getOrigin(Shapes.Talos.Z, 2, true)
    local rows3, cols3 = Shapes.getOrigin(Shapes.Talos.I, 1, true)
    local rows4, cols4 = Shapes.getOrigin(Shapes.Talos.T, 2, true)
    local rows5, cols5 = Shapes.getOrigin({Forms = {
                                                    {{0, 0, 0},
                                                     {0, 0, 1},
                                                     {1, 1, 0}}
                                                    },
                                           UniqueRotationsCount = 1}, 1, true)

    Test.ExpectEqual(rows1, 2, "(L, -1) origin row wrong")
    Test.ExpectEqual(cols1, 1, "(L, -1) origin col wrong")

    Test.ExpectEqual(rows2, 2, "(Z, 1) origin row wrong")
    Test.ExpectEqual(cols2, 1, "(Z, 1) origin col wrong")

    Test.ExpectEqual(rows3, 1, "(I, 0) origin row wrong")
    Test.ExpectEqual(cols3, 1, "(I, 0) origin col wrong")

    Test.ExpectEqual(rows4, 2, "(T, 1) origin row wrong")
    Test.ExpectEqual(cols4, 1, "(T, 1) origin col wrong")

    Test.ExpectEqual(rows5, 3, "made-up shape origin row wrong")
    Test.ExpectEqual(cols5, 1, "made-up shape origin col wrong")
    
    Test.Footer()
end

TEST_Shapes_getOrigin()
TEST_Shapes_getOrigin_columnwise()