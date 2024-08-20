require "DeepCopy"
require "Assert"

Array = {}

function Array.assertValidArg(arg, func_anme, arg_number)
    AssertValidArg(IsTable, arg, func_anme, arg_number)
end

function Array.reverse(array)
    -- assert(IsTable(array))

    local len = #array
    for i = 1, len / 2 do
        array[i], array[len - i + 1] = array[len - i + 1], array[i]
    end
end

function Array.reversed(array)
    -- assert(IsTable(array))

    local new = {}
    local len = #array
    for i, e in ipairs(array) do
        new[len - i + 1] = e
    end
    return new
end

function Array.tostring(array)
    -- assert(IsTable(array))

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
    -- assert(IsTable(array))

    print(Array.tostring(array))
end

function Array.copy(array)
    -- assert(IsTable(array))

    return setmetatable({table.unpack(array)}, getmetatable(array))
end

function Array.equals(array, other)
    -- assert(IsTable(array) and IsTable(other))

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

function Array.lessThanOrEqual(array, other)
    -- assert(IsTable(array) and IsTable(other))

    local len_array = #array
    local len_other = #other
    local len_min = len_array < len_other and len_array or len_other
    
    for i = 1, len_min do
        if array[i] < other[i] then
            return true
        end
        if array[i] > other[i] then
            return false
        end
    end

    return len_array <= len_other
end

function Array.lessThan(array, other)
    -- assert(IsTable(array) and IsTable(other))

    local len_array = #array
    local len_other = #other
    local len_min = len_array < len_other and len_array or len_other
    
    for i = 1, len_min do
        if array[i] < other[i] then
            return true
        end
        if array[i] > other[i] then
            return false
        end
    end

    return len_array < len_other
end

function Array.sub(array, s, e)
    -- assert(IsTable(array))

    s = s or 1
    e = e or #array

    -- assert(IsInteger(s) and IsInteger(e))

    local i = 1
    local sub_array = {}
    for idx = s,e do
        local e = array[idx]
        if e ~= nil then
            sub_array[i] = e
            i = i + 1
        end
    end
    return sub_array
end

function Array.shuffle(array)
    -- assert(IsTable(array))

    for i = #array,2,-1 do
        j = math.random(i)
        array[i], array[j] = array[j], array[i]
    end
end

function Array.find(array, value)
    -- assert(IsTable(array))

    for i, e in ipairs(array) do
        if e == value then return i end
    end
    return nil
end

function Array.findIf(array, func)
    -- assert(IsTable(array) and IsCallable(func))

    for i, e in ipairs(array) do
        if func(e, i) then return i end
    end
    return nil
end

function Array.count(array, value)
    -- assert(IsTable(array))

    local cnt = 0
    for i, e in ipairs(array) do
        if e == value then cnt = cnt + 1 end
    end
    return cnt
end

Array.metatable = {__eq = Array.equals, __lt = Array.lessThan, __le = Array.lessThanOrEqual, print = Array.print}