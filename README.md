# Description

Sigils is a Lua program that solves shape-placement puzzles on rectangular grids.

For example, suppose you have four Tetris shapes: I, L, J, and Z - and want to fit them onto a 4×4 grid like so

<img src=".github/images/talos-example-.jpg" width="30%" height="30%"></img>

The image above shows a puzzle from [The Talos Principle](https://store.steampowered.com/app/257510/The_Talos_Principle/) by [Croteam](https://www.croteam.com) which inspired this project. In the game, these Tetris-like shapes are called "sigils" - hence the name of this program.

The program finds all possible ways to arrange them by using a "smart" brute-force search:
instead of checking every possible combination, it skips impossible placements early, making the search faster.

# Quick Start

Example to solve problem from the above example

```Lua
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
```

To run the script just use

`lua FindSolutionExample.lua`

Possible output

```
Solution for grid 4x4
Permutation: {2, 4, 3, 1}       
Forms:       {1, 3, 2, 2}       

1 1 0    1 1    1 0 0    1 1 1 1
0 1 1    0 1    1 1 1
         0 1

{{1, 1, 2, 2},
 {3, 1, 1, 2},
 {3, 3, 3, 2},
 {4, 4, 4, 4}}
```

Note: To optimize the brute-force search, shapes are placed in different orders depending on grid dimensions:

If rows < columns: shapes are placed top-to-bottom, left-to-right

Otherwise: shapes are placed left-to-right, top-to-bottom

# Script for parallel computation

If you want to find all solutions for a big grid with many shapes you may want to use several threads
(it want help that much though: brute forcing O(n!*4^n) is going to be slow anyway)

You can generate shell script that starts several lua processes to compute things in parallel

You start by defining setup file with information about grid and shapes you want to use

```Lua
require "Sigils"

grid = Grid.create(5, 11)
shapes = {
    Shapes.Lonpos.Corner,    
    Shapes.Lonpos.CornerBig,
    Shapes.Lonpos.Square,
    Shapes.Lonpos.I,
    Shapes.Lonpos.L,
    Shapes.Lonpos.LBig,
    Shapes.Lonpos.X,
    Shapes.Lonpos.Clip,
    Shapes.Lonpos.Zig,
    Shapes.Lonpos.Snake,
    Shapes.Lonpos.Crane,
    Shapes.Lonpos.Chocolate
}
```

Then you call GenerateScript function in a separate script

```Lua
require "Solve/ScriptGen"

GenerateScript(
    "Lonpos505",             -- script name without file extension
    ScriptType.Bat,          -- script type (ScriptType.Bat or ScriptType.Bash)
    "Solve/LonposSetup.lua", -- setup file name
    nil, nil,                -- optional permutations boundaries (nils mean to search all of them)
    12                       -- number of processes
)
```

Those scripts will run several processes that run Solve/Solve.lua script and defines the grid, shapes and boundaries to brute force. Each process will write solutions to a files with names `<script_name>_<process_number>.txt`

Examples of script file

.sh:
```Bash
#!/usr/bin/bash

preexec="dofile 'Solve/LonposSetup.lua'; package.path = package.path..';../?.lua;../?'"

lua -e $preexec Solve/Solve.lua Lonpos505_1 "{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}" "{1, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2}" &
lua -e $preexec Solve/Solve.lua Lonpos505_2 "{2, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}" "{2, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 1}" &
lua -e $preexec Solve/Solve.lua Lonpos505_3 "{3, 1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12}" "{3, 12, 11, 10, 9, 8, 7, 6, 5, 4, 2, 1}" &
lua -e $preexec Solve/Solve.lua Lonpos505_4 "{4, 1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12}" "{4, 12, 11, 10, 9, 8, 7, 6, 5, 3, 2, 1}" &
lua -e $preexec Solve/Solve.lua Lonpos505_5 "{5, 1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12}" "{5, 12, 11, 10, 9, 8, 7, 6, 4, 3, 2, 1}" &
lua -e $preexec Solve/Solve.lua Lonpos505_6 "{6, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12}" "{6, 12, 11, 10, 9, 8, 7, 5, 4, 3, 2, 1}" &
lua -e $preexec Solve/Solve.lua Lonpos505_7 "{7, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12}" "{7, 12, 11, 10, 9, 8, 6, 5, 4, 3, 2, 1}" &
lua -e $preexec Solve/Solve.lua Lonpos505_8 "{8, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12}" "{8, 12, 11, 10, 9, 7, 6, 5, 4, 3, 2, 1}" &
lua -e $preexec Solve/Solve.lua Lonpos505_9 "{9, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12}" "{9, 12, 11, 10, 8, 7, 6, 5, 4, 3, 2, 1}" &
lua -e $preexec Solve/Solve.lua Lonpos505_10 "{10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12}" "{10, 12, 11, 9, 8, 7, 6, 5, 4, 3, 2, 1}" &
lua -e $preexec Solve/Solve.lua Lonpos505_11 "{11, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12}" "{11, 12, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1}" &
lua -e $preexec Solve/Solve.lua Lonpos505_12 "{12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}" "{12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1}" &
```

Note: This way of splitting permutation ranges is very naive and far from the most efficient for parallel processing. For example, process 7 will finish instantly because it quickly finds no solutions starting with shape 7. Meanwhile, Process 11 will take the longest since most solutions fall in that range.
`Solve/LonposOptimizedScript.bat` has manually tweaked ranges for the above exmaple and works slightly better.
