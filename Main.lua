require "Sigils"

function FindSolutions(grid, shapes)
    local res = {}
    start = os.clock()
    for p, r in SuitablePlacements(grid, shapes) do
        table.insert(res, {p, r})
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

-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited: 946/1260 (75.079365079365 %)
-- Total Iterations visited: 54018/2580480 (2.0933314732143 %)
-- Found 24 solutions
-- Time taken: 0.485s
-- FindSolutions(Grid.create(4, 7), {
--     Shapes.Talos.S,
--     Shapes.Talos.S,
--     Shapes.Talos.T,
--     Shapes.Talos.T,
--     Shapes.Talos.L,
--     Shapes.Talos.J,
--     Shapes.Talos.I
-- })

-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited: 7169/22680 (31.609347442681 %)
-- Total Iterations visited: 427081/46448640 (0.91946933214837 %)
-- Found 262 solutions
-- Time taken: 3.985s
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

-- =========== SuitablePlacements Statistic ==============
-- Permutaitons visited: 1357907/4989600 (27.21474667308 %)
-- Total Iterations visited: 201042036/653996851200 (0.0307405204828 %)
-- Found 19594 solutions
-- Time taken: 1907.499s --> 31 mins 47 secs
FindSolutions(Grid.create(6, 8), {
    Shapes.Talos.I,
    Shapes.Talos.T,
    Shapes.Talos.T,
    Shapes.Talos.L,
    Shapes.Talos.Z,
    Shapes.Talos.L,
    Shapes.Talos.Z,
    Shapes.Talos.J,
    Shapes.Talos.Square,
    Shapes.Talos.Square,
    Shapes.Talos.J,
    Shapes.Talos.J
})

-- probably unwaitable (rough calculations say it should take about 2 days)
--
-- also total number of itertations possible is 12! * 4 * 4 * 1 * 2 * 4 * 4 * 1 * 4 * 4 * 4 * 4 * 4 = 251,134,790,860,800 
-- which probabaly won't fit in lua's default number representation (double-precision floating-point) without rounding errors,
-- so statistics report will be wrong
-- UPD: i may actually fit if convertions between real (type: double) and integer (type: long long) values take place as it is stated in lua's docs
--      -- https://www.lua.org/manual/5.4/manual.html#2.1
-- NOTE: if it still doesn't fit it may be useful to compile lua with real type being long double (16 bytes long version)
--       -- src/luaconf.h has this setting
-- 
-- FindSolutions(Grid.create(5, 11), {
--     Shapes.Lonpos.Corner,
--     Shapes.Lonpos.CornerBig,
--     Shapes.Lonpos.Square,
--     Shapes.Lonpos.I,
--     Shapes.Lonpos.L,
--     Shapes.Lonpos.LBig,
--     Shapes.Lonpos.X,
--     Shapes.Lonpos.Clip,
--     Shapes.Lonpos.Zig,
--     Shapes.Lonpos.Snake,
--     Shapes.Lonpos.Crane,
--     Shapes.Lonpos.Chocolate
-- })


