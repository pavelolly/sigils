require "Test"

require "Permutations"

Test.exitOnExpectationFailure = true

function TEST_Permutations(PermutationsFunc, array, start, expected, header)
    Test.Header(header)

    local i = 1
    for p in PermutationsFunc(array, start) do
        if not expected[i] then
            Test.ExpectTrue(false, "Permutation #"..i.." is not expected")
            Array.print(p)
            break
        end
        Test.ExpectEqual(setmetatable(expected[i], {__eq = Array.equals, print = Array.print}),
                         setmetatable(p, {print = Array.print}),
                         "Permutation #"..i.." is wrong")
        i = i + 1
    end
    if expected[i] then
        print("Permutation #"..i.." is not reached")
        Array.print(expected[i])
        Test.success = false
    end

    Test.Footer()
end

expectedPermutations = {
    {1, 2, 3},
    {1, 3, 2},
    {2, 1, 3},
    {2, 3, 1},
    {3, 1, 2},
    {3, 2, 1},
}

TEST_Permutations(Permutations, {1, 2, 3}, nil, expectedPermutations, "Permutations -Full -Unique")

expectedPermutations = {
    {2, 3, 1},
    {3, 1, 2},
    {3, 2, 1},
}

TEST_Permutations(Permutations, {1, 2, 3}, {2, 1, 3}, expectedPermutations, "Permutations -Partial -Unique")

expectedPermutations = {
    {1, 1, 2, 2},
    {1, 1, 2, 2},
    {1, 2, 1, 2},
    {1, 2, 2, 1},
    {1, 2, 1, 2},
    {1, 2, 2, 1},
    {1, 1, 2, 2},
    {1, 1, 2, 2},
    {1, 2, 1, 2},
    {1, 2, 2, 1},
    {1, 2, 1, 2},
    {1, 2, 2, 1},
    {2, 1, 1, 2},
    {2, 1, 2, 1},
    {2, 1, 1, 2},
    {2, 1, 2, 1},
    {2, 2, 1, 1},
    {2, 2, 1, 1},
    {2, 1, 1, 2},
    {2, 1, 2, 1},
    {2, 1, 1, 2},
    {2, 1, 2, 1},
    {2, 2, 1, 1},
    {2, 2, 1, 1}
}

TEST_Permutations(Permutations, {1, 1, 2, 2}, nil, expectedPermutations, "Permutations -Full -NotUnique")

expectedPermutations = {
    {1, 2, 3},
    {1, 3, 2},
    {2, 1, 3},
    {2, 3, 1},
    {3, 1, 2},
    {3, 2, 1},
}

TEST_Permutations(PermutationsUnique, {1, 2, 3}, nil, expectedPermutations, "PermutationsUnique -Full -Unique")

expectedPermutations = {
    {2, 3, 1},
    {3, 1, 2},
    {3, 2, 1},
}

TEST_Permutations(PermutationsUnique, {1, 2, 3}, {2, 1, 3}, expectedPermutations, "PermutationsUnique -Partial -Unique")

expectedPermutations = {
    {1, 1, 2, 2},
    {1, 2, 1, 2},
    {1, 2, 2, 1},
    {2, 1, 1, 2},
    {2, 1, 2, 1},
    {2, 2, 1, 1}
}

TEST_Permutations(PermutationsUnique, {1, 1, 2, 2}, nil, expectedPermutations, "PermutationsUnique -Full -NotUnique")

