require "Array"

Matrix = {}

function Matrix.create(rows, cols, value)
    if value == nil then value = 0 end

    mat = {}
    for i = 1,rows do
        mat[i] = {}
        for j = 1, cols do
            mat[i][j] = value
        end
    end
    return mat
end

function Matrix.valid(mat)
    if type(mat) ~= "table" then
        return false, "not a table"
    end

    local len
    for i = 1,#mat do
        if type(mat[i]) ~= "table" then
            return false, "not a table: row "..i
        end
        -- not sure if this is really that important
        if len and #mat[i] ~= len then
            return false, "wrong len: row "..i
        else
            len = #mat[i] -- i is always 1 here
            if len == 0 then
                return false, "zero len"
            end
        end
    end
    return true
end

function Matrix.assertValidArg(arg, func_name, arg_number)
    AssertValidArg(Matrix.valid, arg, func_name, arg_number)
end

function Matrix.inBounds(mat, row, col)
    -- assert(IsTable2D(mat) and IsInteger(row) and IsInteger(col))

    return 1 <= row and row <= #mat and 1 <= col and col <= #(mat[1])
end

function Matrix.tostring(mat)
    -- assert(IsTable2D(mat))

    s = "{"
    for i, row in ipairs(mat) do
        s = s..Array.tostring(row)
        if type((next(mat, i))) == "number" then
            s = s..",\n "
        end
    end
    return s.."}"
end

function Matrix.print(mat)
    -- assert(IsTable2D(mat))

    print(Matrix.tostring(mat))
end

function Matrix.copy(mat)
    -- assert(IsTable2D(mat))

    local new_mat = {}
    for i = 1, #mat do
        new_mat[i] = {}
        for j = 1, #mat[i] do
            new_mat[i][j] = mat[i][j]
        end
    end
    return new_mat
end

function Matrix.equals(mat, other)
    -- assert(IsTable2D(mat) and IsTable2D(other))

    local mat_rows = #mat
    local other_rows = #other

    if mat_rows ~= other_rows   then return false end
    if mat_rows == 0            then return true  end
    if #(mat[1]) ~= #(other[1]) then return false end

    for i, row in ipairs(mat) do
        for j, elem in ipairs(row) do
            if elem ~= other[i][j] then return false end
        end
    end

    return true
end

function Matrix.column(mat, col)
    -- assert(IsTable2D(mat) and IsInteger(col))

    local column = {}
    for i, row in ipairs(mat) do
        column[i] = row[col]
    end
    return column
end

function Matrix.rotate(mat, nrotations)
    -- assert(IsTable2D(mat) and IsInteger(nrotations))

    nrotations = nrotations % 4 -- mathematically correct
    if nrotations == 0 then
        return Matrix.copy(mat)
    end

    local new_mat = {}
    if nrotations == 1 then
        for col = 1, #(mat[1]) do
            --[[
            1 2  --> 3 1
            3 4      4 2

            1st col reversed becomes 1st row
            ]]

            local column = Matrix.column(mat, col)
            Array.reverse(column)
            new_mat[col] = column
        end
    -- same as nrotations == -1
    elseif nrotations == 3 then 
        for col = 1, #(mat[1]) do
            --[[
            1 2  --> 2 4
            3 4      1 3

            1st col becomes last row
            ]]

            local column = Matrix.column(mat, col)
            new_mat[#(mat[1]) - col + 1] = column
            -- table.insert(new_mat, 1, column)
        end
    else -- nrotations == 2
        for i = 1, #mat do
            --[[
            1 2  --> 4 3
            3 4      2 1

            1st row reversed becomes last row
            ]]

            local row = Array.copy(mat[i])
            Array.reverse(row)
            new_mat[#mat - i + 1] = row
            -- table.insert(new_mat, 1, column)
        end
    end

    return new_mat
end

function Matrix.fill(mat, value)
    -- assert(IsTable2D(mat))

    for i = 1,#mat do
        for j = 1,#mat[1] do
            mat[i][j] = value
        end
    end
end

function Matrix.find(mat, value, columnwise)
    -- assert(IsTable2D(mat))

    local rows = #mat
    local cols = #mat[1]

    if not columnwise then
        for i = 1,rows do
            for j = 1,cols do
                if mat[i][j] == value then return i, j end
            end
        end
    else
        for j = 1,cols do
            for i = 1,rows do
                if mat[i][j] == value then return i, j end
            end
        end
    end

    return nil
end

function Matrix.findIf(mat, func, columnwise)
    -- assert(IsTable2D(mat) and IsCallable(func))

    local rows = #mat
    local cols = #mat[1]

    if not columnwise then
        for i = 1,rows do
            for j = 1,cols do
                if func(mat[i][j]) then return i, j end
            end
        end
    else
        for j = 1,cols do
            for i = 1,rows do
                if func(mat[i][j]) then return i, j end
            end
        end
    end

    return nil
end

Matrix.metatable = {__eq = Matrix.equals, print = Matrix.print}

