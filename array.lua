Array = {}

function Array.reverse(array)
    for i = 1, #array / 2 do
        array[i], array[#array - i + 1] = array[#array - i + 1], array[i]
    end
end

function Array.reversed(array)
    local new = {}
    for i, e in ipairs(array) do
        new[#array - i + 1] = e
    end
    return new
end

function Array.print(array)
    if type(array) ~= "table" then
        print(string.format("Not an array (but '%s')", type(mat)))
        return
    end

    print(table.unpack(array))
end

function Array.copy(array)
    return {table.unpack(array)}
end

function Array.equals(array, other)
    -- if type(array) ~= "table" or type(other) ~= "table" then return false end

    if #array ~= #other then
        return false
    end

    for i, v in ipairs(array) do
        if v ~= other[i] then
            return false
        end
    end
    return true
end

function Array.sub(array, s, e)
    s = s or 1
    e = e or #array

    local i = 1
    local sub_array = {}
    for idx = s,e do
        sub_array[i] = array[idx]
        i = i + 1
    end
    return sub_array
end

function Array.shuffle(array)
    for i = #array,2,-1 do
        -- pick an element in x[1:i] with which to exchange x[i]
        j = math.random(i)
        array[i], array[j] = array[j], array[i]
    end
end

function Array.find(array, value)
    for i, e in ipairs(array) do
        if e == value then return i end
    end
    return nil
end

function Array.findIf(array, func)
    if type(func) ~= "function" then return nil end

    for i, e in ipairs(array) do
        if func(e) then return i end
    end
    return nil
end