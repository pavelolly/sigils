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
function NextPermutation(seq)
    -- find pair seq[j] < seq[j+1] from the end
    local j
    for i = (#seq - 1),1,-1 do
        if seq[i] < seq[i + 1] then
            j = i
            break
        end
    end
    
    -- if no such pair we're done
    if not j then return false end

    -- find largest l > j such that seq[l] > seq[j]
    local l = j + 1
    for i = j + 2,#seq do
        if seq[i] > seq[j] then
            l = i
        end
    end

    -- swap seq[j] and seq[l]
    seq[j], seq[l] = seq[l], seq[j]
    
    -- reverse seq[j+1]..seq[#seq]
    for i = 1, (#seq - j) / 2 do
        seq[j + i], seq[#seq - i + 1] = seq[#seq - i + 1], seq[j + i]
    end

    return true
end

function Permutations(array, seq)
    if seq then seq = Array.copy(seq) end
    return function()
        if (not seq) then
            seq = {}
            for i=1,#array do seq[i] = i end
            if (not next(seq)) then return nil end
            return Permute(array, seq)
        end

        if not NextPermutation(seq) then return nil end

        return Permute(array, seq), seq
    end
end