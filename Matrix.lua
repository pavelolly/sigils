require "Array"

Matrix = {}

function Matrix.create(rows, cols, value)
    value = value or 0
    mat = {}
    for i = 1,rows do
        mat[i] = {}
        for j = 1, cols do
            mat[i][j] = value
        end
    end
    return mat
end

function Matrix.inBounds(mat, row, col) 
    return 1 <= row and row <= #mat and 1 <= col and col <= #(mat[1])
end

function Matrix.print(mat)
    if type(mat) ~= "table" then
        print(string.format("Not a matrix (but '%s')", type(mat)))
    end

    for i, row in ipairs(mat) do
        -- should check type(row) == "table"
        for j, elem in ipairs(row) do
            io.write(elem .. " ")
        end
        io.write("\n")
    end
end

function Matrix.copy(mat)
    return Array.deepCopy(mat)
end

function Matrix.equals(mat1, mat2)
    -- if type(mat1) ~= "table" or type(mat2) ~= "table" then return false end

    if #mat1 ~= #mat2 then return false end
    if #mat1 == 0 then return true end
    if #(mat1[1]) ~= #(mat2[1]) then return false end

    for i, row in ipairs(mat1) do
        for j, elem in ipairs(row) do
            if elem ~= mat2[i][j] then return false end
        end
    end

    return true
end

function Matrix.column(mat, col)
    local column = {}
    for i, row in ipairs(mat) do
        column[i] = row[col]
    end
    return column
end

function Matrix.rotate(mat, nrotations)
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
    for i = 1,#mat do
        for j = 1,#mat[1] do
            mat[i][j] = value
        end
    end
end

function Matrix.find(mat, value)
    for i = 1,#mat do
        for j = 1,#mat[1] do
            if mat[i][j] == value then return i, j end
        end
    end
    return nil
end

function Matrix.findIf(mat, func)
    if type(func) ~= "function" then return nil end

    for i = 1,#mat do
        for j = 1,#mat[1] do
            if func(mat[i][j]) then return i, j end
        end
    end
    return nil
end

