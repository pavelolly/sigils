require "Test"

require "Permutations"


function TEST_CutPermutationSequence(start_permutaion, end_permutaion, nchunks, expected_ranges)
    Test.Header("CutPermutationSequence")

    local function _equals(o1, o2)
        if #o1 ~= #o2 then return false end

        for i, pair in ipairs(o1) do
            if not (Array.equals(pair[1], o2[i][1]) and Array.equals(pair[2], o2[i][2])) then
                print(i)
                return false
            end
        end
        return true
    end

    local function _print(out)
        for i, pair in ipairs(out) do
            print("Permutaion: "..Array.tostring(pair[1]))
            print("Rotations:  "..Array.tostring(pair[2]))
            print()
        end
    end

    local ranges = CutPermutationsSequence(start_permutaion, end_permutaion, nchunks)
    Test.ExpectEqual(setmetatable(expected_ranges, {__eq = _equals, print = _print}), ranges, "Ranges are wrong")

    Test.Footer()
end

TEST_CutPermutationSequence({1, 2, 3}, nil, 3, {
    {{1, 2, 3}, {1, 3, 2}},
    {{2, 1, 3}, {2, 3, 1}},
    {{3, 1, 2}, {3, 2, 1}}    
})

TEST_CutPermutationSequence({1, 2, 3}, nil, 1, {
    {{1, 2, 3}, {3, 2, 1}},   
})

TEST_CutPermutationSequence({1, 2, 3, 4}, nil, 4, {
    {{1, 2, 3, 4}, {1, 4, 3, 2}},
    {{2, 1, 3, 4}, {2, 4, 3, 1}},
    {{3, 1, 2, 4}, {3, 4, 2, 1}},
    {{4, 1, 2, 3}, {4, 3, 2, 1}},
})

TEST_CutPermutationSequence(nil, {3, 1, 4, 2}, 3, {
    {{1, 2, 3, 4}, {1, 3, 4, 2}},
    {{1, 4, 2, 3}, {2, 1, 4, 3}},
    {{2, 3, 1, 4}, {3, 1, 4, 2}},
})

TEST_CutPermutationSequence({2, 3, 1, 4}, nil, 5, {
    {{2, 3, 1, 4}, {2, 4, 1, 3}},
    {{2, 4, 3, 1}, {3, 1, 4, 2}},
    {{3, 2, 1, 4}, {3, 4, 1, 2}},
    {{3, 4, 2, 1}, {4, 1, 3, 2}},
    {{4, 2, 1, 3}, {4, 3, 2, 1}},
})

TEST_CutPermutationSequence({1, 3, 2, 4}, {3, 4, 2, 1}, 3, {
    {{1, 3, 2, 4}, {2, 1, 3, 4}},
    {{2, 1, 4, 3}, {2, 4, 3, 1}},
    {{3, 1, 2, 4}, {3, 4, 2, 1}},
})

TEST_CutPermutationSequence({1, 2}, nil, 7, {
    {{1, 2}, {1, 2}},
    {{2, 1}, {2, 1}},
})

TEST_CutPermutationSequence({1}, nil, 1, {
    {{1}, {1}}
})

TEST_CutPermutationSequence({}, nil, 1, {
    {{}, {}}
})

TEST_CutPermutationSequence({2, 3, 1}, {1, 2, 3}, 3, {})




