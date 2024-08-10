require "DeepCopy"
require "Matrix"
require "Permutations"

Shapes = {
    Talos = {
        L = {
            {1, 0},
            {1, 0},
            {1, 1},

            Area = 4,
            UniqueRotationsCount = 4
        },
        J = {
            {0, 1},
            {0, 1},
            {1, 1},

            Area = 4,
            UniqueRotationsCount = 4
        },
        I = {
            {1},
            {1},
            {1},
            {1},

            Area = 4,
            UniqueRotationsCount = 2
        },
        S = {
            {0, 1, 1},
            {1, 1, 0},

            Area = 4,
            UniqueRotationsCount = 2
        },
        Z = {
            {1, 1, 0},
            {0, 1, 1},

            Area = 4,
            UniqueRotationsCount = 2
        },
        Square = {
            {1, 1},
            {1, 1},

            Area = 4,
            UniqueRotationsCount = 1
        },
        T = {
            {1, 1, 1},
            {0, 1, 0},

            Area = 4,
            UniqueRotationsCount = 4
        }
    },

    Lonpos = {
        Corner = {
            {1, 0},
            {1, 1},

            Area = 3,
            UniqueRotationsCount = 4
        },
        CornerBig = {
            {1, 0, 0},
            {1, 0, 0},
            {1, 1, 1},

            Area = 5,
            UniqueRotationsCount = 4
        },
        Square = {
            {1, 1},
            {1, 1},

            Area = 4,
            UniqueRotationsCount = 1
        },
        I = {
            {1},
            {1},
            {1},
            {1},

            Area = 4,
            UniqueRotationsCount = 2
        },
        L = {
            {1, 0},
            {1, 0},
            {1, 1},

            Area = 4,
            UniqueRotationsCount = 4
        },
        LBig = {
            {1, 0},
            {1, 0},
            {1, 0},
            {1, 1},

            Area = 5,
            UniqueRotationsCount = 4
        },
        X = {
            {0, 1, 0},
            {1, 1, 1},
            {0, 1, 0},

            Area = 5,
            UniqueRotationsCount = 1
        },
        Clip = {
            {1, 1, 1},
            {1, 0, 1},

            Area = 5,
            UniqueRotationsCount = 4
        },
        Zig = {
            {1, 1, 0},
            {0, 1, 1},
            {0, 0, 1},

            Area = 5,
            UniqueRotationsCount = 4
        },
        Snake = {
            {0, 1},
            {1, 1},
            {1, 0},
            {1, 0},

            Area = 5,
            UniqueRotationsCount = 4
        },
        Crane = {
            {0, 1},
            {1, 1},
            {0, 1},
            {0, 1},

            Area = 5,
            UniqueRotationsCount = 4
        },
        Chocolate = {
            {0, 1},
            {1, 1},
            {1, 1},

            Area = 5,
            UniqueRotationsCount = 4
        }
    }
}

function Shapes.print(shape)
    Matrix.print(shape)
    print("UniqueRotationsCount:", shape.UniqueRotationsCount)
    print("Area:", shape.Area)
end

-- pretty
-- 1 1    0 1 1   1 1 1 1    1
-- 1 1    1 1 0              1
--                           1
--                           1
function Shapes.printMany(shapes)
    local cols_numbers = {}
    local max_rows = -1
    for i = 1, #shapes do
        cols_numbers[i] = #(shapes[i][1])
        if #(shapes[i]) > max_rows then max_rows = #(shapes[i]) end
    end

    if not next(cols_numbers) or max_rows == -1 then return end

    for i = 1, max_rows do
        for j = 1, #shapes do
            local row = shapes[j][i]
            if row then
                for i, e in ipairs(row) do
                    io.write(e)
                    if i ~= #row then
                        io.write(" ")
                    end
                end
            else
                for i = 1, cols_numbers[j] do
                    io.write(" ")
                    if i ~= cols_numbers[j] then
                        io.write(" ")
                    end
                end
            end
            
            if j ~= #shapes then
                io.write("    ")
            end
        end
        io.write("\n")
    end
end

function Shapes.rotate(shape, nrotations)
    local mat = Matrix.rotate(shape, nrotations)
    local rshape = DeepCopy(shape)
    local maxlen = (#rshape > #mat) and #rshape or #mat
    for i = 1,maxlen do
        rshape[i] = mat[i]
    end
    return rshape
end

function Shapes.rotateMany(shapes, rotations)
    if #shapes ~= #rotations then error("lengths of shapes and rotations differ") end
    local rshapes = {}
    for i = 1,#shapes do
        rshapes[i] = Shapes.rotate(shapes[i], rotations[i])
    end
    return rshapes
end

function Shapes.area(shapes)
    local val = 0
    for _, shape in ipairs(shapes) do
        if not shape.Area then return nil end
        val = val + shape.Area
    end
    return val
end

-- get row and col of left- and uppermost non-empty block
-- 
--   0 0 0
--   0 0 1  --> 2, 3
--   0 1 1
--   0 1 0
--
function Shapes.getOrigin(shape)
    return Matrix.findIf(shape, function(elem) return elem ~= 0 end)
end


-- returns true if shape1 ans shape2 are the same shape up to rotation meaning:
-- 0 0 1         1 0 
-- 1 1 1   and   1 0   are the same
--               1 1
function Shapes.same(shape1, shape2)
    if shape1.Area ~= shape2.Area or shape1.UniqueRotationsCount ~= shape2.UniqueRotationsCount then
        return false
    end

    -- eternal loop guard
    assert(type(shape2.UniqueRotationsCount) == "number" and shape2.UniqueRotationsCount > 0,
           "bad shape2.UniqueRotationsCount")

    local nrotations = 0
    repeat
        if Matrix.equals(shape1, shape2) then
            return true
        end
        shape1 = Matrix.rotate(shape1, 1)
        nrotations = nrotations + 1
    until nrotations >= shape2.UniqueRotationsCount
    return false
end

for k,v in pairs(Shapes.Talos) do
    setmetatable(v, {__eq = Shapes.same, print = Shapes.print})
end
for k,v in pairs(Shapes.Lonpos) do
    setmetatable(v, {__eq = Shapes.same, print = Shapes.print})
end
