require "Sigils"

function FindSolutions(grid, shapes)
    local res = {}
    local debug = {prev_permutation = {1,12,11,10,9,8,7,6,5,4,3,2}, number_permutations_to_inspect = 1}
    start = os.clock()
    for p, r in SuitablePlacements(grid, shapes, debug) do
        table.insert(res, {p, r})
        print("{"..Array.tostring(p)..", "..Array.tostring(r).."}")
        -- break
        -- print("Permutaion: "..Array.tostring(p))
        -- print("Rotations:  "..Array.tostring(r))
        -- print()
        -- os.exit(1)
    end
    end_ = os.clock()
    print("Found "..#res.." solutions")
    print("Time taken: "..(end_ - start).."s")
    return res
end

-- First iteration
-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited: 946/1260 (75.079365079365 %)
-- Total Iterations visited: 54018/2580480 (2.0933314732143 %)
-- Found 24 solutions
-- Time taken: 0.485s
--
-- Second iteration: saving prefix rotations
-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited:      946 / 1260 (75.079 %) / 5040 (18.770 %)
-- Total Iterations visited:  52599 / 2580480 (2.038 %) / 10321920 (0.510 %)
-- Found 24 solutions
-- Time taken: 0.469s
-- ~2% less total iterations
--
-- Third iteration: searching for free blocks columnwise
-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited:      464 / 1260 (36.825 %) / 5040 (9.206 %)
-- Total Iterations visited:  14555 / 2580480 (0.564 %) / 10321920 (0.141 %)
-- Found 24 solutions
-- Time taken: 0.141s
-- ~3 times faster, Around half less permutations checked
--
-- Fourth iteration: all forms of shapes are predefined
-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited:      464 / 1260 (36.825 %) / 5040 (9.206 %)        
-- Total Iterations visited:  14555 / 2580480 (0.564 %) / 10321920 (0.141 %)
-- Found 24 solutions
-- Time taken: 0.047s
-- Faster because you don't rotate shapes over and over: you just take predefined matrices
-- FindSolutions(Grid.create(4, 7), {
--     Shapes.Talos.S,
--     Shapes.Talos.S,
--     Shapes.Talos.T,
--     Shapes.Talos.T,
--     Shapes.Talos.L,
--     Shapes.Talos.J,
--     Shapes.Talos.I
-- })

-- First iteration
-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited: 7169/22680 (31.609347442681 %)
-- Total Iterations visited: 427081/46448640 (0.91946933214837 %)
-- Found 262 solutions
-- Time taken: 3.985s
--
-- Second itertation
-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited:      7160 / 22680 (31.570 %) / 362880 (1.973 %)       
-- Total Iterations visited:  417114 / 46448640 (0.898 %) / 743178240 (0.056 %)
-- Found 262 solutions
-- Time taken: 3.875s
-- ~2.5% less total iterations
--
-- Third iteration
-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited:      7242 / 22680 (31.931 %) / 362880 (1.996 %)       
-- Total Iterations visited:  420488 / 46448640 (0.905 %) / 743178240 (0.057 %)
-- Found 265 solutions
-- Time taken: 4.234s
-- Actually the same (slighlty different because of the bug in the second iteration)
--
-- Fourth itertation
-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited:      7242 / 22680 (31.931 %) / 362880 (1.996 %)       
-- Total Iterations visited:  420488 / 46448640 (0.905 %) / 743178240 (0.057 %)
-- Found 265 solutions
-- Time taken: 1.328s
-- ~3 times faster because of reduction of rotations on each itertaion
-- FindSolutions(Grid.create(6, 6), {
--     Shapes.Talos.Square,
--     Shapes.Talos.Z,
--     Shapes.Talos.J,
--     Shapes.Talos.Z,
--     Shapes.Talos.L,
--     Shapes.Talos.L,
--     Shapes.Talos.J,
--     Shapes.Talos.Square,
--     Shapes.Talos.I,
-- })

-- First Iteration
-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited: 1357907/4989600 (27.21474667308 %)
-- Total Iterations visited: 201042036/653996851200 (0.0307405204828 %)
-- Found 19594 solutions
-- Time taken: 1907.499s --> 31 mins 47 secs
--
-- Second itertation
-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited:      1357907 / 4989600 (27.215 %) / 479001600 (0.283 %)
-- Total Iterations visited:  198712325 / 653996851200 (0.030 %) / 62783697715200 (0.000 %)
-- Found 19594 solutions
-- Time taken: 1806.531s --> 30 mins 6 secs
-- ~1% less total iterations
--
-- Third iteration
-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited:      635947 / 4989600 (12.745 %) / 479001600 (0.133 %)
-- Total Iterations visited:  64042489 / 653996851200 (0.010 %) / 62783697715200 (0.000 %)
-- Found 19635 solutions
-- Time taken: 630.375s ---> 10 mins 30 secs
-- ~3 times faster
--
-- Fourth itaration
-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited:      635947 / 4989600 (12.745 %) / 479001600 (0.133 %)
-- Total Iterations visited:  64042489 / 653996851200 (0.010 %) / 62783697715200 (0.000 %)
-- Found 19635 solutions
-- Time taken: 194.093s --> 3 mins 13 secs
-- FindSolutions(Grid.create(6, 8), {
--     Shapes.Talos.I,
--     Shapes.Talos.T,
--     Shapes.Talos.T,
--     Shapes.Talos.L,
--     Shapes.Talos.Z,
--     Shapes.Talos.L,
--     Shapes.Talos.Z,
--     Shapes.Talos.J,
--     Shapes.Talos.Square,
--     Shapes.Talos.Square,
--     Shapes.Talos.J,
--     Shapes.Talos.J
-- })

-- First itertation
-- probably unwaitable (rough calculations say it should take about 2 days)
--
-- NOTE: total number of itertations possible is 12! * 4 * 4 * 1 * 2 * 4 * 4 * 1 * 4 * 4 * 4 * 4 * 4 = 251,134,790,860,800 
-- which probabaly won't fit in lua's default number representation (double-precision floating-point) without rounding errors,
-- so statistics report will be wrong
-- UPD: i may actually fit if convertions between real (type: double) and integer (type: long long) values take place as it is stated in lua's docs
--      -- https://www.lua.org/manual/5.4/manual.html#2.1
-- UPD: if it still doesn't fit it may be useful to compile lua with real type being long double (16 bytes long version)
--       -- src/luaconf.h has this setting
--
-- Second iteration
-- still unwaitable: if we assume that we reduced number of iterations by 2% (so now it is 98% of what it was)
--                   that is still just 1 hour time reduction which is obviously insignificant
--
-- Third iteration
-- still unwaitable but should take from 8 to 16 hours
-- one solution is found in 3.453 s
--
-- Fourth iteration
-- should take between 2 and 5 hours
-- one solution is found in 0.39s
--
FindSolutions(Grid.create(5, 11), {
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
})

