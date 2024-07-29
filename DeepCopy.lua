function DeepCopy(o)
    if type(obj) ~= 'table' then
        return obj
    end
    local copy = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do
        copy[k] = DeepCopy(v)
    end
    return copy
end