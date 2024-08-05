--
-- https://gist.github.com/tylerneylon/81333721109155b2d244
--
function DeepCopy(obj, seen)
    -- Handle non-tables and previously-seen tables.
    if type(obj) ~= "table" then return obj       end
    if seen and seen[obj]   then return seen[obj] end
  
    -- New table; mark it as seen and copy recursively.
    local s = seen or {}
    local res = {}
    s[obj] = res
    for k, v in pairs(obj) do
        res[DeepCopy(k, s)] = DeepCopy(v, s)
    end
    return setmetatable(res, getmetatable(obj))
end