require "Test"

require "Permutations"

Test.exitOnExpectationFailure = true

function TEST_Permutations_Full()
    Test.Header("Permutaitons (Full)")

    local expectedPermutations = {
        {1, 2, 3},
        {1, 3, 2},
        {2, 1, 3},
        {2, 3, 1},
        {3, 1, 2},
        {3, 2, 1},
    }

    local i = 1
    for p in Permutations({1, 2, 3}) do
        if not expectedPermutations[i] then
            Test.ExpectTrue(false, "Permutation #"..i.." is not expected")
            Array.print(p)
            break
        end
        Test.ExpectEqual(setmetatable(expectedPermutations[i], {__eq = Array.equals, print = Array.print}),
                         setmetatable(p, {print = Array.print}),
                         "Permutation #"..i.." is wrong")
        i = i + 1
    end
    if expectedPermutations[i] then
        Test.ExpectTrue(false, "Permutation #"..i.." is not reached")
        Array.print(expectedPermutations[i])
    end

    Test.Footer()
end

function TEST_Permutations_Partial()
    Test.Header("Permutaitons (Partial)")

    local expectedPermutations = {
        -- {1, 2, 3},
        -- {1, 3, 2},
        -- {2, 1, 3},
        {2, 3, 1},
        {3, 1, 2},
        {3, 2, 1},
    }

    local i = 1
    for p in Permutations({1, 2, 3}, {2, 1, 3}) do
        if not expectedPermutations[i] then
            Test.ExpectTrue(false, "Permutation #"..i.." is not expected")
            Array.print(p)
            break
        end
        Test.ExpectEqual(setmetatable(expectedPermutations[i], {__eq = Array.equals, print = Array.print}),
                         setmetatable(p, {print = Array.print}),
                         "Permutation #"..i.." is wrong")
        i = i + 1
    end
    if expectedPermutations[i] then
        print("Permutation #"..i.." is not reached")
        Array.print(expectedPermutations[i])
        Test.success = false
    end

    Test.Footer()
end


TEST_Permutations_Full()
TEST_Permutations_Partial()