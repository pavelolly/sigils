require "Test"

require "Matrix"
require "Shapes"

function TEST_Matrix_rotate()
    Test.Header("Matrix.rotate")

    local mat = {{1, 2},
                 {3, 4},
                 {5, 6}}

    local matrot0 = setmetatable(Matrix.rotate(mat, 0), Matrix.metatable)
    local matrot1 = setmetatable({{5, 3, 1},
                                  {6, 4, 2}}, Matrix.metatable)
    local matrot2 = setmetatable({{6, 5},
                                  {4, 3},
                                  {2, 1}}, Matrix.metatable)
    local matrot3 = setmetatable({{2, 4, 6},
                                  {1, 3, 5}}, Matrix.metatable)

    Test.ExpectFalse(rawequal(matrot0, mat), "Rotation 0 does not create new matrix")
    Test.ExpectEqual(matrot0, mat, "Rotation 0 failed")
    Test.ExpectEqual(matrot1, Matrix.rotate(mat, 1), "Rotation 1 failed")
    Test.ExpectEqual(matrot2, Matrix.rotate(mat, 2), "Rotation 2 failed")
    Test.ExpectEqual(matrot3, Matrix.rotate(mat, 3), "Rotation 3(-1) failed")
    Test.ExpectEqual(matrot3, Matrix.rotate(mat, -1), "Rotations -1 and rotation 3 are not equal")

    Test.Footer()
end

TEST_Matrix_rotate()