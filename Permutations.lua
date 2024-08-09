require "Array"

function Permute(array, permutation)
    local new_array = {}
    for i, idx in ipairs(permutation) do
        new_array[i] = array[idx]
    end
    return new_array
end

function GetInitialPermutation(array)
    per = {}
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
            per[i] = idx
        else
            seen[i] = array[i]
            per[i] = i
        end
    end
    return per
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

-- make prev_per to be next permutation with different prefix of length prefix_len
--
-- {|1, 2,| 3, 4}, 2 ---> {|1, 3,| 2, 4}
-- {|3, 2, 5,| 1, 4}, 3 ---> {|3, 4, 1,| 2, 5}
--
-- returns true if such permutaion exists
--
-- if called like NextPermutationSkipPrefix(p, #p) acts exactly the same as NextPermutation(p) LOL that algorithm reinvented 
function NextPermutationSkipPrefix(prev_per, prefix_len)
    if prefix_len > #prev_per or prefix_len < 1 then
        return false
    end

    -- for prev_per[prefix_idx] find in prev_per[prefix_idx + 1 : #prefix] item
    -- that is min among those that are bigger than prev_per[prefix_idx]
    --
    -- if no such item found decrement prefix_idx and repeat
    local prefix_idx = prefix_len
    local suffix_min_idx
    while prefix_idx > 0 do
        for i = (prefix_idx + 1),#prev_per do
            if prev_per[i] > prev_per[prefix_idx] and (not suffix_min_idx or prev_per[i] < (prev_per[suffix_min_idx])) then
                suffix_min_idx = i
            end
        end
        if suffix_min_idx then break end
        prefix_idx = prefix_idx - 1
    end

    -- if item not found then there is no next permutation
    if not suffix_min_idx then
        return false
    end

    -- swap elements
    prev_per[prefix_idx], prev_per[suffix_min_idx] = prev_per[suffix_min_idx], prev_per[prefix_idx]

    -- overwrite suffix with sorted one
    local suffix = Array.sub(prev_per, prefix_idx + 1, #prev_per)
    table.sort(suffix)
    table.move(suffix, 1, #suffix, prefix_idx + 1, prev_per)
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
            prev_per = GetInitialPermutation(array)
            if (not next(prev_per)) then return nil end
            return Array.copy(array), Array.copy(prev_per)
        end
        
        if not NextPermutation(prev_per) then return nil end

        return Permute(array, prev_per),
               Array.copy(prev_per) 
    end
end