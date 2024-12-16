require "Array"
require "Matrix"
require "Shapes"
require "Sigils" -- this one is actually enough

-- create grid 4x4
grid = Grid.create(4, 4)

-- define shapes
shapes = { Shapes.Talos.I, Shapes.Talos.Z, Shapes.Talos.J, Shapes.Talos.L }

-- 1
-- find solution brute forcing everything staring from initial permutation (1, 2, 3, ...)
permutation, forms = FindFirstSolution(grid, shapes)

-- 2
-- find random solution (brute force starts from random permutation)
permutation, forms = FindRandomSolution(grid, shapes)

-- 3
-- iterate over all solutions (can take a while if grid is big)
for permutation, forms in SuitablePlacements(grid, shapes) do
   -- ...
end

assert(permutation ~= nil, "no solutions found")

print("Solution for grid 4x4")
print("Permutation: "..Array.tostring(permutation))
print("Forms:       "..Array.tostring(forms))
print()
Shapes.printMany(Permute(shapes, permutation), forms)
print()

-- verify the solution
assert(PlaceShapes(grid, Permute(shapes, permutation), forms), "not a solution")

print(Matrix.tostring(grid))


