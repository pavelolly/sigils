require "DeepCopy"
require "Matrix"
require "Permutations"

Shapes = {
    Talos = {
        L = {
            Forms = {
                {{1, 0},
                 {1, 0},
                 {1, 1}},
                
                {{1, 1, 1},
                 {1, 0, 0}},
    
                {{1, 1},
                 {0, 1},
                 {0, 1}},
    
                {{0, 0, 1},
                 {1, 1, 1}},
            },

            Area = 4,
            UniqueRotationsCount = 4
        },
        J = {
            Forms = {
                {{0, 1},
                 {0, 1},
                 {1, 1}},
    
                {{1, 0, 0},
                 {1, 1, 1}},
    
                {{1, 1},
                 {1, 0},
                 {1, 0}},
                
                {{1, 1, 1},
                 {0, 0, 1}},
            },

            Area = 4,
            UniqueRotationsCount = 4
        },
        I = {
            Forms = {
                {{1},
                 {1},
                 {1},
                 {1}},
                
                {{1, 1, 1, 1}},
            },

            Area = 4,
            UniqueRotationsCount = 2
        },
        S = {
            Forms = {
                {{0, 1, 1},
                 {1, 1, 0}},
    
                {{1, 0},
                 {1, 1},
                 {0, 1}},
            },

            Area = 4,
            UniqueRotationsCount = 2
        },
        Z = {
            Forms = {
                {{1, 1, 0},
                 {0, 1, 1}},
    
                {{0, 1},
                 {1, 1},
                 {1, 0}},
            },

            Area = 4,
            UniqueRotationsCount = 2
        },
        Square = {
            Forms = {
                {{1, 1},
                 {1, 1}},
            },

            Area = 4,
            UniqueRotationsCount = 1
        },
        T = {
            Forms = {
                {{1, 1, 1},
                 {0, 1, 0}},
    
                {{0, 1},
                 {1, 1},
                 {0, 1}},
    
                {{0, 1, 0},
                 {1, 1, 1}},
    
                {{1, 0},
                 {1, 1},
                 {1, 0}},
            },
            
            Area = 4,
            UniqueRotationsCount = 4
        }
    },

    Lonpos = {
        Corner = {
            Forms = {
                {{1, 0},
                 {1, 1}},
                
                {{1, 1},
                 {1, 0}},
                
                {{1, 1},
                 {0, 1}},
    
                {{0, 1},
                 {1, 1}},
            },

            Area = 3,
            UniqueRotationsCount = 4
        },
        CornerBig = {
            Forms = {
                {{1, 0, 0},
                 {1, 0, 0},
                 {1, 1, 1}},
                
                {{1, 1, 1},
                 {1, 0, 0},
                 {1, 0, 0}},
                
                {{1, 1, 1},
                 {0, 0, 1},
                 {0, 0, 1}},
                
                {{0, 0, 1},
                 {0, 0, 1},
                 {1, 1, 1}},
            },

            Area = 5,
            UniqueRotationsCount = 4
        },
        Square = {
            Forms = {
                {{1, 1},
                 {1, 1}},
            },

            Area = 4,
            UniqueRotationsCount = 1
        },
        I = {
            Forms = {
                {{1},
                 {1},
                 {1},
                 {1}},
    
                {{1, 1, 1, 1}},
            },

            Area = 4,
            UniqueRotationsCount = 2
        },
        L = {
            Forms = {
                {{1, 0},
                 {1, 0},
                 {1, 1}},
                
                {{1, 1, 1},
                 {1, 0, 0}},
    
                {{1, 1},
                 {0, 1},
                 {0, 1}},
    
                {{0, 0, 1},
                 {1, 1, 1}},
    
                {{0, 1},
                 {0, 1},
                 {1, 1}},
    
                {{1, 0, 0},
                 {1, 1, 1}},
    
                {{1, 1},
                 {1, 0},
                 {1, 0}},
                
                {{1, 1, 1},
                 {0, 0, 1}},
            },

            Area = 4,
            UniqueRotationsCount = 8
        },
        LBig = {
            Forms = {
                {{1, 0},
                 {1, 0},
                 {1, 0},
                 {1, 1}},
                
                {{1, 1, 1, 1},
                 {1, 0, 0, 0}},
    
                {{1, 1},
                 {0, 1},
                 {0, 1},
                 {0, 1}},
    
                {{0, 0, 0, 1},
                 {1, 1, 1, 1}},
    
                {{0, 1},
                 {0, 1},
                 {0, 1},
                 {1, 1}},
    
                {{1, 0, 0, 0},
                 {1, 1, 1, 1}},
    
                {{1, 1},
                 {1, 0},
                 {1, 0},
                 {1, 0}},
                
                {{1, 1, 1, 1},
                 {0, 0, 0, 1}},
            },

            Area = 5,
            UniqueRotationsCount = 8
        },
        X = {
            Forms = {
                {{0, 1, 0},
                 {1, 1, 1},
                 {0, 1, 0}},
            },

            Area = 5,
            UniqueRotationsCount = 1
        },
        Clip = {
            Forms = {
                {{1, 1, 1},
                 {1, 0, 1}},
    
                {{1, 1},
                 {0, 1},
                 {1, 1}},
    
                {{1, 0, 1},
                 {1, 1, 1}},
    
                {{1, 1},
                 {1, 0},
                 {1, 1}},
            },

            Area = 5,
            UniqueRotationsCount = 4
        },
        Zig = {
            Forms = {
                {{1, 1, 0},
                 {0, 1, 1},
                 {0, 0, 1}},
    
                {{0, 0, 1},
                 {0, 1, 1},
                 {1, 1, 0}},
    
                {{1, 0, 0},
                 {1, 1, 0},
                 {0, 1, 1}},
    
                {{0, 1, 1},
                 {1, 1, 0},
                 {1, 0, 0}},
            },
            
            Area = 5,
            UniqueRotationsCount = 4
        },
        Snake = {
            Forms = {
                {{0, 1},
                 {1, 1},
                 {1, 0},
                 {1, 0}},
    
                {{1, 1, 1, 0},
                 {0, 0, 1, 1}},
    
                {{0, 1},
                 {0, 1},
                 {1, 1},
                 {1, 0}},
    
                {{1, 1, 0, 0},
                 {0, 1, 1, 1}},
    
                {{1, 0},
                 {1, 1},
                 {0, 1},
                 {0, 1}},
    
                {{0, 0, 1, 1},
                 {1, 1, 1, 0}},
    
                {{1, 0},
                 {1, 0},
                 {1, 1},
                 {0, 1}},
    
                {{0, 1, 1, 1},
                 {1, 1, 0, 0}},
            },

            Area = 5,
            UniqueRotationsCount = 8
        },
        Crane = {
            Forms = {
                {{0, 1},
                 {1, 1},
                 {0, 1},
                 {0, 1}},
    
                {{0, 0, 1, 0},
                 {1, 1, 1, 1}},
    
                {{1, 0},
                 {1, 0},
                 {1, 1},
                 {1, 0}},
    
                {{1, 1, 1, 1},
                 {0, 1, 0, 0}},
    
                {{1, 0},
                 {1, 1},
                 {1, 0},
                 {1, 0}},
    
                {{1, 1, 1, 1},
                 {0, 0, 1, 0}},
    
                {{0, 1},
                 {0, 1},
                 {1, 1},
                 {0, 1}},
    
                {{0, 1, 0, 0},
                 {1, 1, 1, 1}},
            },

            Area = 5,
            UniqueRotationsCount = 8
        },
        Chocolate = {
            Forms = {
                {{0, 1},
                 {1, 1},
                 {1, 1}},

                {{1, 1, 0},
                 {1, 1, 1}},

                {{1, 1},
                 {1, 1},
                 {1, 0}},

                {{1, 1, 1},
                 {0, 1, 1}},

                {{1, 0},
                 {1, 1},
                 {1, 1}},

                {{1, 1, 1},
                 {1, 1, 0}},

                {{1, 1},
                 {1, 1},
                 {0, 1}},

                {{0, 1, 1},
                 {1, 1, 1}},
            },

            Area = 5,
            UniqueRotationsCount = 8
        }
    }
}

function Shapes.print(shape, form)
    Matrix.print(Shapes.getForm(shape, form))
    print("UniqueRotationsCount:", shape.UniqueRotationsCount)
    print("Area:", shape.Area)
end

-- returns matrix of shape's form
function Shapes.getForm(shape, form)
    local idx = ((form or 1) - 1) % shape.UniqueRotationsCount + 1
    return shape.Forms[idx]
end

-- pretty
-- 1 1    0 1 1   1 1 1 1    1
-- 1 1    1 1 0              1
--                           1
--                           1
function Shapes.printMany(shapes, forms)
    forms = forms or {}

    local cols_numbers = {}
    local max_rows = -1
    for i = 1, #shapes do
        local shape_mat = Shapes.getForm(shapes[i], forms[i])
        cols_numbers[i] = #(shape_mat[1])
        if #shape_mat > max_rows then max_rows = #shape_mat end
    end

    if not next(cols_numbers) or max_rows == -1 then return end

    for i = 1, max_rows do
        for j = 1, #shapes do
            local shape_mat = Shapes.getForm(shapes[j], forms[j])
            local row = shape_mat[i]
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
--   0 0 1  --> 2, 3 (3, 1 if columnwise == true)
--   1 1 1             
--   0 1 0              
--
function Shapes.getOrigin(shape, form, columnwise)
    return Matrix.findIf(Shapes.getForm(shape, form), function(elem) return elem ~= 0 end, columnwise)
end

function Shapes.equals(shape1, shape2)
    if shape1.Area ~= shape2.Area or shape1.UniqueRotationsCount ~= shape2.UniqueRotationsCount then
        return false
    end

    return Matrix.equals(shape1.Forms[1], shape2.Forms[1])
end

for k,v in pairs(Shapes.Talos) do
    setmetatable(v, {__eq = Shapes.equals, print = Shapes.print})
end
for k,v in pairs(Shapes.Lonpos) do
    setmetatable(v, {__eq = Shapes.equals, print = Shapes.print})
end
