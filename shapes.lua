require "Matrix"

Shapes = {
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

function Shapes.copy(shape)
    return {UniqueRotationsCount = shape.UniqueRotationsCount, Area = shape.Area; table.unpack(Matrix.copy(shape))}
end

function Shapes.rotate(shape, nrotations)
    return {UniqueRotationsCount = shape.UniqueRotationsCount, Area = shape.Area; table.unpack(Matrix.rotate(shape, nrotations))}
end

function Shapes.rotateMany(shapes, rotations)
    if #shapes ~= #rotations then error("lengths of shapes and rotations differ") end
    local rshapes = {}
    for i = 1,#shapes do
        rshapes[i] = Shapes.rotate(Shapes.copy(shapes[i]), rotations[i])
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
