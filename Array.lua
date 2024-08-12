require "DeepCopy"

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

function Array.tostring(array)
    s = "{"
    for i, e in ipairs(array) do
        s = s..tostring(e)
        next_number = next(array, i)
        if type(next_number) == "number" and next_number == i + 1 then
            s = s..", "
        end
    end
    return s.."}"
end

function Array.print(array)
    if type(array) ~= "table" then
        print(string.format("Not an array (but '%s')", type(mat)))
        return
    end

    print(Array.tostring(array))
end

function Array.copy(array)
    return {table.unpack(array)}
end

function Array.deepCopy(array)
    local new_array = {}
    for i, e in ipairs(array) do
        new_array[i] = DeepCopy(e)
    end
    return new_array
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
    for i, e in ipairs(array) do
        if func(e) then return i end
    end
    return nil
end

function Array.count(array, value)
    local cnt = 0
    for i, e in ipairs(array) do
        if e == value then cnt = cnt + 1 end
    end
    return cnt
end

Array.metatable = {__eq = Array.equals, print = Array.print}