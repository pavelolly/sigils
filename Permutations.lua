require "Array"

function Permute(array, permutation)
    local new_array = {}
    for i, idx in ipairs(permutation) do
        new_array[i] = array[idx]
    end
    return new_array
end

--
-- https://ru.wikipedia.org/wiki/Алгоритм_Нарайаны
--
function NextPermutation(prev_per)
    -- find pair prev_per[j] < prev_per[j+1] from the end
    local j
    for i = (#prev_per - 1),1,-1 do
        if prev_per[i] < prev_per[i + 1] then
            j = i
            break
        end
    end
    
    -- if no such pair we're done
    if not j then return false end

    -- find largest l > j such that prev_per[l] > prev_per[j]
    local l = j + 1
    for i = j + 2,#prev_per do
        if prev_per[i] > prev_per[j] then
            l = i
        end
    end

    -- swap prev_per[j] and prev_per[l]
    prev_per[j], prev_per[l] = prev_per[l], prev_per[j]
    
    -- reverse prev_per[j+1]..prev_per[#prev_per]
    for i = 1, (#prev_per - j) / 2 do
        prev_per[j + i], prev_per[#prev_per - i + 1] = prev_per[#prev_per - i + 1], prev_per[j + i]
    end

    return true
end

function Permutations(array, prev_per)
    -- save prev_per locally
    if prev_per then prev_per = Array.copy(prev_per) end

    return function()
        if (not prev_per) then
            prev_per = {}
            for i=1,#array do prev_per[i] = i end
            if (not next(prev_per)) then return nil end
            return Array.copy(array), Array.copy(prev_per)
        end
        
        if not NextPermutation(prev_per) then return nil end
        
        return Permute(array, prev_per),
               Array.copy(prev_per) -- return copy here to prevent affecting the iteration by modifying this value
    end
end

function PermutationsUnique(array, prev_per)
    -- save prev_per locally
    if prev_per then prev_per = Array.copy(prev_per) end

    return function()
        if (not prev_per) then
            prev_per = {}
            local seen = {}

            for i = 1,#array do
                -- find object in seen table
                local idx
                for k, v in pairs(seen) do
                    if v == array[i] then
                        idx = k
                        break
                    end
                end

                -- if found set first met index for that object
                -- else create new entry in seen table and set new index
                if idx then
                    prev_per[i] = idx
                else
                    seen[i] = array[i]
                    prev_per[i] = i
                end
            end

            if (not next(prev_per)) then return nil end
            return Array.copy(array), Array.copy(prev_per)
        end
        
        if not NextPermutation(prev_per) then return nil end

        return Permute(array, prev_per),
               Array.copy(prev_per) 
    end
end