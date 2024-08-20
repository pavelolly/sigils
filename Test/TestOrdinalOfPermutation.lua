require "Test"

require "Permutations"


function TEST_OridinalOfPermutation(permutation, expected_ordinal)
    Test.Header("OrdinalOfPermutaion")
    Test.ExpectEqual(expected_ordinal, OrdinalOfPermutation(permutation), "Ordinal is not what expected")
    Test.Footer()
end

TEST_OridinalOfPermutation({1, 2, 3}, 1)
TEST_OridinalOfPermutation({3, 2, 1}, 6)
TEST_OridinalOfPermutation({1, 2, 4, 3}, 2)
TEST_OridinalOfPermutation({1, 2, 2, 1}, 3)
TEST_OridinalOfPermutation({4, 2, 1, 3}, 21)
TEST_OridinalOfPermutation({4, 6, 3, 5, 1, 2}, 473)
TEST_OridinalOfPermutation({1, 2, 3, 3, 3, 2}, 4)
TEST_OridinalOfPermutation({}, 1)