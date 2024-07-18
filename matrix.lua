require "array"

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
    for i, row in ipairs(mat) do
        for j, elem in ipairs(row) do
            io.write(elem .. " ")
        end
        io.write("\n")
    end
end

function Matrix.copy(mat)
    local copy = {}
    for i, row in ipairs(mat) do
        copy[i] = {}
        for j, elem in ipairs(row) do
            copy[i][j] = elem
        end
    end
    return copy
end

function Matrix.equals(mat1, mat2)
    if #mat1 ~= #mat2 then return false end
    if #mat1 == 0 then return true end
    if #(mat1[1]) ~= #(mat1[2]) then return false end

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
    nrotations = nrotations % 4
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
    -- smae as nrotations == -1
    elseif nrotations == 3 then
            --[[
            1 2  --> 2 4
            3 4      1 3

            1st col becomes last row
            ]]
        for col = 1, #(mat[1]) do
            local column = Matrix.column(mat, col)
            new_mat[#mat - col + 1] = column
        end
    else -- nrotations == 2
        --[[
            1 2  --> 4 3
            3 4      2 1

            1st row reversed becomes last row
        ]]
        for i = 1, #mat[1] do
            local row = Array.copy(mat[i])
            Array.reverse(row)
            new_mat[#mat - i + 1] = row
        end
    end

    return new_mat
end

function Matrix.fill(mat, value)
    value = value or 0

    for i = 1,#mat do
        for j = 1,#mat[1] do
            mat[i][j] = value
        end
    end
end

