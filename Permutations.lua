require "Array"

function Permute(array, permutation)
    -- assert(IsTable(array) and IsTable(permutation))

    local new_array = {}
    for i, idx in ipairs(permutation) do
        assert(IsInteger(idx))

        new_array[i] = array[idx]
    end
    return new_array
end

function IsPermutation(array, permutation)
    -- assert(IsTable(array) and IsTable(permutation))

    local elems_count = {}
    for i = 1,#array do
        elems_count[i] = 0
    end

    for i, e in ipairs(array) do
        elems_count[e] = elems_count[e] + 1
    end
    for i, e in ipairs(permutation) do
        elems_count[e] = elems_count[e] - 1
    end

    for i = 1, #array do
        if elems_count[i] ~= 0 then
            return false
        end
    end

    return true
end

--
-- https://ru.wikipedia.org/wiki/Алгоритм_Нарайаны
--
function NextPermutation(prev_per)
    -- assert(IsTable(prev_per))

    local len = #prev_per

    -- find pair prev_per[j] < prev_per[j+1] from the end
    local j
    for i = (len - 1),1,-1 do
        if prev_per[i] < prev_per[i + 1] then
            j = i
            break
        end
    end
    
    -- if no such pair we're done
    if not j then return false end

    -- find largest l > j such that prev_per[l] > prev_per[j]
    local l = j + 1
    for i = j + 2,len do
        if prev_per[i] > prev_per[j] then
            l = i
        end
    end

    -- swap prev_per[j] and prev_per[l]
    prev_per[j], prev_per[l] = prev_per[l], prev_per[j]
    
    -- reverse prev_per[j+1]..prev_per[len]
    for i = 1, (len - j) / 2 do
        prev_per[j + i], prev_per[len - i + 1] = prev_per[len - i + 1], prev_per[j + i]
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
-- if called with prefix_len == #prev_per or prefix_len == #prev_per - 1 acts exactly the same as NextPermutation(p) LOL that algorithm reinvented 
function NextPermutationSkipPrefix(prev_per, prefix_len)
    -- assert(IsTable(prev_per) and IsInteger(prefix_len))

    local len = #prev_per

    if prefix_len > len or prefix_len < 1 then
        return false
    end

    -- for prev_per[prefix_idx] find in prev_per[prefix_idx + 1 : #prefix] item
    -- that is min among those that are bigger than prev_per[prefix_idx]
    --
    -- if no such item found decrement prefix_idx and repeat
    local prefix_idx = prefix_len
    local suffix_min_idx
    while prefix_idx > 0 do
        for i = (prefix_idx + 1),len do
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
    local suffix = Array.sub(prev_per, prefix_idx + 1, len)
    table.sort(suffix)
    table.move(suffix, 1, #suffix, prefix_idx + 1, prev_per)
    return true
end

function GetInitialPermutation(array)
    Array.assertValidArg(array, "GetInitialPermutaion")

    local per = {}
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

function Permutations(array, prev_per)
    Array.assertValidArg(array, "Permutations", 1)

    local init_per = {}
    for i = 1,#array do
        init_per[i] = i
    end
    assert(not prev_per or IsPermutation(prev_per, init_per), "Permutations: prev_per must be permutation of "..Array.tostring(init_per))

    -- save prev_per locally
    if prev_per then prev_per = Array.copy(prev_per) end

    return function()
        if (not prev_per) then
            prev_per = init_per
            return Array.copy(array), Array.copy(prev_per)
        end
        
        if not NextPermutation(prev_per) then return nil end
        
        return Permute(array, prev_per), Array.copy(prev_per)
    end
end

function PermutationsUnique(array, prev_per)
    Array.assertValidArg(array, "PermutationsUnique", 1)

    local init_per = GetInitialPermutation(array)
    assert(not prev_per or IsPermutation(prev_per, init_per), "PermutationsUnique: prev_per must be permutation of "..Array.tostring(init_per))

    -- save prev_per locally
    if prev_per then prev_per = Array.copy(prev_per) end

    return function()
        if (not prev_per) then
            prev_per = init_per
            return Array.copy(array), Array.copy(prev_per)
        end
        
        if not NextPermutation(prev_per) then return nil end

        return Permute(array, prev_per), Array.copy(prev_per)
    end
end

function Factorial(n)
    local res = 1
    for i = 1,n do
        res = res * i
    end
    return res
end

function NumberOfPermutations(array)
    local per = GetInitialPermutation(array)
    local number_permutations = Factorial(#per)
    local seen = {}
    for i, e in ipairs(per) do
        if not Array.find(seen, e) then
            number_permutations = number_permutations / Factorial(Array.count(per, e))
            table.insert(seen, e)
        end
    end
    return math.tointeger(number_permutations)
end

-- returns ordinal number of given permutation in a list of all unique permutations sorted lexicographically
function OrdinalOfPermutation(permutation)
    Array.assertValidArg(permutation, "OrdinalOfPermutation")

    local current_permutation = Array.copy(permutation)
    table.sort(current_permutation)

    local len = #permutation
    local ordinal = 1
    while not Array.equals(current_permutation, permutation) do
        local idx = 0
        local first_different = Array.findIf(permutation, function(e) idx = idx + 1; return e ~= current_permutation[idx] end)
        assert(first_different)

        local suffix = Array.sub(current_permutation, first_different + 1)
        ordinal = ordinal + NumberOfPermutations(suffix)
        NextPermutationSkipPrefix(current_permutation, first_different)
    end
    return ordinal
end

function NextPermutationSkipNumber(permutation, number)
    -- Array.assertValidArg(permutation, "NextPermutationSkipNumber", 1)
    -- assert(IsInteger(number) and number >= 0, "NextPermutationSkipNumber: number must be non-negative integer")

    if number == 0 then
        return true
    end

    local total_permutations  = NumberOfPermutations(permutation)
    local ordinal_permutation = OrdinalOfPermutation(permutation)

    if number > total_permutations - ordinal_permutation then
        return false
    end

    local len = #permutation
    local current_permutation = Array.copy(permutation)

    while number > 0 do
        local prefix_len = len - 1
        
        local permutations_to_skip = 1
        while prefix_len > 1 do
            local suffix = Array.sub(current_permutation, prefix_len)
            local permutations_to_skip_ahead = NumberOfPermutations(suffix) - OrdinalOfPermutation(suffix) + 1

            if permutations_to_skip_ahead > number then
                break
            end

            permutations_to_skip = permutations_to_skip_ahead
            prefix_len = prefix_len - 1
        end

        if not NextPermutationSkipPrefix(current_permutation, prefix_len) then
            return false
        end

        number = number - permutations_to_skip
    end
    
    -- copy result to outside world
    for i = 1,len do
        permutation[i] = current_permutation[i]
    end
    return true
end

-- get permutation by its ordinal in a list of permutation defined by 'permutation' parameter and sorted lexicographically
-- if no such permutation returns nil
function GetPermutationByOrdinal(permutation, ordinal)
    Array.assertValidArg(permutation, "GetPermutaionByOrdinal", 1)
    assert(IsInteger(ordinal) and ordinal > 0, "GetPermutaionByOrdinal: ordinal must be postive integer")

    local init_permutation = Array.copy(permutation)
    table.sort(init_permutation)

    if NextPermutationSkipNumber(init_permutation, ordinal - 1) then
        return init_permutation
    else
        return nil
    end
end

function CutPermutationsSequence(start_permutation, end_permutation, nchunks)
    assert(start_permutation or end_permutation, "CutPermutationsSequence: at least one of start_permutation and end_permutation must be non-nil")

    if start_permutation then
        Array.assertValidArg(start_permutation, "CutPermutationsSequence", 2)
    end
    if end_permutation then
        Array.assertValidArg(end_permutation, "CutPermutationsSequence", 3)
    end
    assert(IsInteger(nchunks) and nchunks > 0, "CutPermutationsSequence: nchunks must be positive integer")

    if not start_permutation then
        start_permutation = Array.copy(end_permutation)
        table.sort(start_permutation)
    end
    if not end_permutation then
        end_permutation = Array.copy(start_permutation)
        table.sort(end_permutation)
        Array.reverse(end_permutation)
    end

    assert(IsPermutation(start_permutation, end_permutation), "CutPermutationSequence: start_permutation is not permutation of end_permutation and vice versa")

    local permutations_range_len = OrdinalOfPermutation(end_permutation) - OrdinalOfPermutation(start_permutation) + 1
    local permutations_chunk_len = permutations_range_len // nchunks

    if permutations_chunk_len < 0 then
        return {}
    end

    if permutations_chunk_len == 0 then
        permutations_chunk_len = 1
        nchunks = #start_permutation
    end

    local ranges = {}
    local p = start_permutation
    for i = 1,nchunks-1 do
        local p2 = Array.copy(p)
        assert(NextPermutationSkipNumber(p, permutations_chunk_len - 1))
        table.insert(ranges, {p2, Array.copy(p)})
        assert(NextPermutation(p))
    end
    table.insert(ranges, {p, end_permutation})

    return ranges
end