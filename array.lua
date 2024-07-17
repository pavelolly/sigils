Array = {}

function Array.reverse(array)
    for i = 1, #array / 2 do
        array[i], array[#array - i + 1] = array[#array - i + 1], array[i]
    end
end

function Array.print(array)
    print(table.unpack(array))
end

function Array.copy(array)
    return {table.unpack(array)}
end

function Array.equals(array, other)
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