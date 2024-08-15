require "Test"

require "Sigils"


function TEST_SuitablePlacements_vs_SuitablePermutationsBruteForce(grid, shapes)
    Test.Header("SuitablePlacements vs SuitablePermutationsBruteForce")

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

    local t1 = os.clock()

    local bruteForceOut = setmetatable({}, {__eq = _equals, print = _print})
    for p, rs in SuitablePermutationsUniqueBruteForce(grid, shapes) do
        for i, r in ipairs(rs) do
            table.insert(bruteForceOut, {p, r})
        end
    end

    local t2 = os.clock()

    print("Brute Force done in "..(t2 - t1).." secs")
    print("Found "..#bruteForceOut.." solutions")

    local optimizedOut = {}
    for p, r in SuitablePlacements(grid, shapes) do
        table.insert(optimizedOut, {p, r})
    end

    Test.ExpectEqual(bruteForceOut, optimizedOut, "Results not equal")

    Test.Footer()
end

grid = Grid.create(4, 4)
shapes = {Shapes.Talos.Z, Shapes.Talos.L, Shapes.Talos.I, Shapes.Talos.J}

TEST_SuitablePlacements_vs_SuitablePermutationsBruteForce(grid, shapes)

grid = Grid.create(4, 4)
shapes = {Shapes.Talos.T, Shapes.Talos.T, Shapes.Talos.L, Shapes.Talos.Z}

TEST_SuitablePlacements_vs_SuitablePermutationsBruteForce(grid, shapes)

grid = Grid.create(5, 4)
shapes = {Shapes.Talos.Square, Shapes.Talos.J, Shapes.Talos.I, Shapes.Talos.Square, Shapes.Talos.J}

TEST_SuitablePlacements_vs_SuitablePermutationsBruteForce(grid, shapes)

-- grid = Grid.create(6, 6)
-- shapes = {Shapes.Talos.Square, Shapes.Talos.Z, Shapes.Talos.J, Shapes.Talos.Z, Shapes.Talos.L, Shapes.Talos.L, Shapes.Talos.J, Shapes.Talos.Square, Shapes.Talos.I}
-- TEST_SuitablePlacements_vs_SuitablePermutationsBruteForce(grid, shapes)
--
-- Brute Force done in 3076.015 secs
-- Found 265 solutions