function AssertValidArg(valid_func, arg, func_name, arg_number)
    local res, msg = valid_func(arg)

    -- faster than assert() because string are built only when error actually occur
    if not res then
        func_name   = func_name or "<not-specified>"
        local arg_number_str
        if arg_number then
            arg_number_str = " #"..arg_number
        else
            arg_number_str = ""
        end
        error(func_name..": invalid argument"..arg_number_str..": "..(msg or ""))
    end
end

local TABLE    = "table"
local INTEGER  = "integer"
local NUMBER   = "number"
local FUNCTION = "function"

function IsTable(t)
    return type(t) == TABLE
end

function IsTable2D(t)
    return type(t) == TABLE and type(t[1]) == TABLE
end

function IsInteger(n)
    return math.type(n) == INTEGER
end

function IsNumber(n)
    return type(n) == NUMBER
end

function IsCallable(c)
    return type(c) == FUNCTION or (getmetatable(c) or {}).__call
end