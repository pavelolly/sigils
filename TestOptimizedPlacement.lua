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

    local bruteForceOut = setmetatable({}, {__eq = _equals, print = _print})
    for p, rs in SuitablePermutationsUniqueBruteForce(grid, shapes) do
        for i, r in ipairs(rs) do
            table.insert(bruteForceOut, {p, r})
        end
    end

    local optimizedOut = {}
    for p, r in SuitablePlacements(grid, shapes) do
        table.insert(optimizedOut, {p, r})
    end

    Test.ExpectEqual(bruteForceOut, optimizedOut, "Results not equal")

    Test.Footer()
end

grid = Grid.create(4, 4)
shapes = {Shapes.Z, Shapes.L, Shapes.I, Shapes.J}

TEST_SuitablePlacements_vs_SuitablePermutationsBruteForce(grid, shapes)

grid = Grid.create(4, 4)
shapes = {Shapes.T, Shapes.T, Shapes.L, Shapes.Z}

TEST_SuitablePlacements_vs_SuitablePermutationsBruteForce(grid, shapes)

grid = Grid.create(5, 4)
shapes = {Shapes.Square, Shapes.J, Shapes.I, Shapes.Square, Shapes.J}

TEST_SuitablePlacements_vs_SuitablePermutationsBruteForce(grid, shapes)