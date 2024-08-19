function DeepCopy(obj)
    if type(obj) ~= "table" then return obj end
  
    local res = {}
    for k, v in pairs(obj) do
        res[DeepCopy(k)] = DeepCopy(v)
    end
    return setmetatable(res, getmetatable(obj))
end