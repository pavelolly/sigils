require "sigils"

-- setup grid
grid = GetNewGrid(4, 4)

-- setup shapes
shapes = {Shapes.I, Shapes.J, Shapes.L, Shapes.Z}

function find()
    print("=======================")
    local t1 = os.clock()
    order, rotations = FindAnyPlacement(grid, shapes)
    local t2 = os.clock()

    if order then
        grid:printInfo()
    else
        print("No placement found")
    end
    io.write(string.format("Time: %fs\n", t2 - t1))
    print("=======================")
end

find()

grid = GetNewGrid(4, 4)
shapes = {Shapes.I, Shapes.J, Shapes.L}

find()

grid = GetNewGrid(4, 7)
shapes = {Shapes.I, Shapes.I, Shapes.T, Shapes.T, Shapes.Z, Shapes.S, Shapes.L}
Array.reverse(shapes)

find()

grid = GetNewGrid(4, 6)
shapes = {Shapes.T, Shapes.Z, Shapes.T, Shapes.L, Shapes.I, Shapes.Square}

find()

-- too long calc
grid = GetNewGrid(5, 8)
-- shapes = {Shapes.L, Shapes.L, Shapes.S, Shapes.S, Shapes.Z, Shapes.Z, Shapes.T, Shapes.T, Shapes.T, Shapes.T}
shapes = {Shapes.J, Shapes.S, Shapes.S, Shapes.T,
          Shapes.T, Shapes.T,
          Shapes.S, Shapes.Z, Shapes.L, Shapes.T,}

find()

grid = GetNewGrid(6, 8)
shapes = {Shapes.L, Shapes.L, Shapes.I,
          Shapes.S, Shapes.L,
          Shapes.Square, Shapes.Square, Shapes.S,
          Shapes.T,
          Shapes.J, Shapes.J,
          Shapes.T}

find()
