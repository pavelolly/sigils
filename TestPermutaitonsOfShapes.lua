require "Test"

require "Permutations"
require "Shapes"

require "TestPermutations"

-- Same tests that are in "TestPermutations" but with
-- 1 replaced with Shapes.I
-- 2 replaced with Shapes.S
-- 3 replaced with Shapes.T

expectedPermutations = {
    {Shapes.I, Shapes.S, Shapes.T},
    {Shapes.I, Shapes.T, Shapes.S},
    {Shapes.S, Shapes.I, Shapes.T},
    {Shapes.S, Shapes.T, Shapes.I},
    {Shapes.T, Shapes.I, Shapes.S},
    {Shapes.T, Shapes.S, Shapes.I},
}

TEST_Permutations(Permutations, {Shapes.I, Shapes.S, Shapes.T}, nil, expectedPermutations, "Permutations -Full -Unique")

expectedPermutations = {
    {Shapes.S, Shapes.T, Shapes.I},
    {Shapes.T, Shapes.I, Shapes.S},
    {Shapes.T, Shapes.S, Shapes.I},
}

TEST_Permutations(Permutations, {Shapes.I, Shapes.S, Shapes.T}, {2, 1, 3}, expectedPermutations, "Permutations -Partial -Unique")

expectedPermutations = {
    {Shapes.I, Shapes.I, Shapes.S, Shapes.S},
    {Shapes.I, Shapes.I, Shapes.S, Shapes.S},
    {Shapes.I, Shapes.S, Shapes.I, Shapes.S},
    {Shapes.I, Shapes.S, Shapes.S, Shapes.I},
    {Shapes.I, Shapes.S, Shapes.I, Shapes.S},
    {Shapes.I, Shapes.S, Shapes.S, Shapes.I},
    {Shapes.I, Shapes.I, Shapes.S, Shapes.S},
    {Shapes.I, Shapes.I, Shapes.S, Shapes.S},
    {Shapes.I, Shapes.S, Shapes.I, Shapes.S},
    {Shapes.I, Shapes.S, Shapes.S, Shapes.I},
    {Shapes.I, Shapes.S, Shapes.I, Shapes.S},
    {Shapes.I, Shapes.S, Shapes.S, Shapes.I},
    {Shapes.S, Shapes.I, Shapes.I, Shapes.S},
    {Shapes.S, Shapes.I, Shapes.S, Shapes.I},
    {Shapes.S, Shapes.I, Shapes.I, Shapes.S},
    {Shapes.S, Shapes.I, Shapes.S, Shapes.I},
    {Shapes.S, Shapes.S, Shapes.I, Shapes.I},
    {Shapes.S, Shapes.S, Shapes.I, Shapes.I},
    {Shapes.S, Shapes.I, Shapes.I, Shapes.S},
    {Shapes.S, Shapes.I, Shapes.S, Shapes.I},
    {Shapes.S, Shapes.I, Shapes.I, Shapes.S},
    {Shapes.S, Shapes.I, Shapes.S, Shapes.I},
    {Shapes.S, Shapes.S, Shapes.I, Shapes.I},
    {Shapes.S, Shapes.S, Shapes.I, Shapes.I}
}

TEST_Permutations(Permutations, {Shapes.I, Shapes.I, Shapes.S, Shapes.S}, nil, expectedPermutations, "Permutations -Full -NotUnique")

expectedPermutations = {
    {Shapes.I, Shapes.S, Shapes.T},
    {Shapes.I, Shapes.T, Shapes.S},
    {Shapes.S, Shapes.I, Shapes.T},
    {Shapes.S, Shapes.T, Shapes.I},
    {Shapes.T, Shapes.I, Shapes.S},
    {Shapes.T, Shapes.S, Shapes.I},
}

TEST_Permutations(PermutationsUnique, {Shapes.I, Shapes.S, Shapes.T}, nil, expectedPermutations, "PermutationsUnique -Full -Unique")

expectedPermutations = {
    {Shapes.S, Shapes.T, Shapes.I},
    {Shapes.T, Shapes.I, Shapes.S},
    {Shapes.T, Shapes.S, Shapes.I},
}

TEST_Permutations(PermutationsUnique, {Shapes.I, Shapes.S, Shapes.T}, {2, 1, 3}, expectedPermutations, "PermutationsUnique -Partial -Unique")

expectedPermutations = {
    {Shapes.I, Shapes.I, Shapes.S, Shapes.S},
    {Shapes.I, Shapes.S, Shapes.I, Shapes.S},
    {Shapes.I, Shapes.S, Shapes.S, Shapes.I},
    {Shapes.S, Shapes.I, Shapes.I, Shapes.S},
    {Shapes.S, Shapes.I, Shapes.S, Shapes.I},
    {Shapes.S, Shapes.S, Shapes.I, Shapes.I}
}

TEST_Permutations(PermutationsUnique, {Shapes.I, Shapes.I, Shapes.S, Shapes.S}, nil, expectedPermutations, "PermutationsUnique -Full -NotUnique")