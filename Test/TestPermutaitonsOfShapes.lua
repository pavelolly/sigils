require "Test"

require "Permutations"
require "Shapes"

require "TestPermutations"

-- Same tests that are in "TestPermutations" but with
-- 1 replaced with Shapes.TalosI
-- 2 replaced with Shapes.TalosS
-- 3 replaced with Shapes.TalosT

expectedPermutations = {
    {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.T},
    {Shapes.Talos.I, Shapes.Talos.T, Shapes.Talos.S},
    {Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.T},
    {Shapes.Talos.S, Shapes.Talos.T, Shapes.Talos.I},
    {Shapes.Talos.T, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.T, Shapes.Talos.S, Shapes.Talos.I},
}

TEST_Permutations(Permutations, {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.T}, nil, expectedPermutations, "Permutations -Full -Unique")

expectedPermutations = {
    {Shapes.Talos.S, Shapes.Talos.T, Shapes.Talos.I},
    {Shapes.Talos.T, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.T, Shapes.Talos.S, Shapes.Talos.I},
}

TEST_Permutations(Permutations, {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.T}, {2, 1, 3}, expectedPermutations, "Permutations -Partial -Unique")

expectedPermutations = {
    {Shapes.Talos.I, Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.S},
    {Shapes.Talos.I, Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.S},
    {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.S, Shapes.Talos.I},
    {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.S, Shapes.Talos.I},
    {Shapes.Talos.I, Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.S},
    {Shapes.Talos.I, Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.S},
    {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.S, Shapes.Talos.I},
    {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.S, Shapes.Talos.I},
    {Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.I},
    {Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.I},
    {Shapes.Talos.S, Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.I},
    {Shapes.Talos.S, Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.I},
    {Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.I},
    {Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.I},
    {Shapes.Talos.S, Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.I},
    {Shapes.Talos.S, Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.I}
}

TEST_Permutations(Permutations, {Shapes.Talos.I, Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.S}, nil, expectedPermutations, "Permutations -Full -NotUnique")

expectedPermutations = {
    {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.T},
    {Shapes.Talos.I, Shapes.Talos.T, Shapes.Talos.S},
    {Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.T},
    {Shapes.Talos.S, Shapes.Talos.T, Shapes.Talos.I},
    {Shapes.Talos.T, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.T, Shapes.Talos.S, Shapes.Talos.I},
}

TEST_Permutations(PermutationsUnique, {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.T}, nil, expectedPermutations, "PermutationsUnique -Full -Unique")

expectedPermutations = {
    {Shapes.Talos.S, Shapes.Talos.T, Shapes.Talos.I},
    {Shapes.Talos.T, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.T, Shapes.Talos.S, Shapes.Talos.I},
}

TEST_Permutations(PermutationsUnique, {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.T}, {2, 1, 3}, expectedPermutations, "PermutationsUnique -Partial -Unique")

expectedPermutations = {
    {Shapes.Talos.I, Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.S},
    {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.S, Shapes.Talos.I},
    {Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.I, Shapes.Talos.S},
    {Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.I},
    {Shapes.Talos.S, Shapes.Talos.S, Shapes.Talos.I, Shapes.Talos.I}
}

TEST_Permutations(PermutationsUnique, {Shapes.Talos.I, Shapes.Talos.I, Shapes.Talos.S, Shapes.Talos.S}, nil, expectedPermutations, "PermutationsUnique -Full -NotUnique")