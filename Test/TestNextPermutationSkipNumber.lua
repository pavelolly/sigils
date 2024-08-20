require "Test"

require "Permutations"


function TEST_NextPermutaionSkipNumber(permutation, number, expected_permutation)
    Test.Header("NextPermutaionSkipPrefix")

    local permutation_copy = Array.copy(permutation)
    local res = NextPermutationSkipNumber(permutation_copy, number)

    if not res then
        Test.ExpectTrue(rawequal(expected_permutation, nil), "Expected to get some permutation, but result is nil")
    else
        Test.ExpectEqual(setmetatable(expected_permutation, Array.metatable), permutation_copy, "Permutation is wrong")
        Test.ExpectEqual(number, OrdinalOfPermutation(permutation_copy) - OrdinalOfPermutation(permutation), "Wrong number of permutaions was skipped")
    end

    Test.Footer()
end


TEST_NextPermutaionSkipNumber({1, 2, 3}, 3, {2, 3, 1})
TEST_NextPermutaionSkipNumber({1, 2, 3}, 6, nil)
TEST_NextPermutaionSkipNumber({3, 2, 1}, 2, nil)
TEST_NextPermutaionSkipNumber({2, 3, 1}, 2, {3, 2, 1})
TEST_NextPermutaionSkipNumber({1, 3, 2}, 3, {3, 1, 2})

TEST_NextPermutaionSkipNumber({1, 2, 3, 4}, 15, {3, 2, 4, 1})
TEST_NextPermutaionSkipNumber({1, 2, 2, 1}, 2, {2, 1, 2, 1})

TEST_NextPermutaionSkipNumber({1, 2, 3, 4, 5, 6}, 120, {2, 1, 3, 4, 5, 6})
TEST_NextPermutaionSkipNumber({1, 2, 3, 4, 5, 6}, 720, nil)