require "matrix"

Shapes = {
    Area = 4;

    L = {
        {1, 0},
        {1, 0},
        {1, 1},

        nrotations = 4
    },
    J = {
        {0, 1},
        {0, 1},
        {1, 1},
         
        nrotations = 4
    },
    I = {
        {1},
        {1},
        {1},
        {1},

        nrotations = 2
    },
    S = {
        {0, 1, 1},
        {1, 1, 0},
        
        nrotations = 2
    },
    Z = {
        {1, 1, 0},
        {0, 1, 1},

        nrotations = 2
    },
    Square = {
        {1, 1},
        {1, 1},

        nrotations = 1
    },
    T = {
        {1, 1, 1},
        {0, 1, 0},

        nrotations = 4
    }
}

function ShapeCopy(shape)
    local copy = Matrix.copy(shape)
    copy.nrotations = shape.nrotations
    return copy
end
