require "Permutations"
require "Shapes"

ScriptType = {
    Batch = ".bat",
    Bash  = ".sh"
}

function GenereteScript(filename, script_type, setup_lua_filename, start_permutation, end_permutaion, nchunks)
    assert(script_type == ScriptType.Batch or script_type == ScriptType.Bash, "unknown script type")

    -- run setup file to get shapes
    dofile(setup_lua_filename)

    local init_permutation = GetInitialPermutation(shapes)
    if not start_permutation then
        start_permutation = Array.copy(init_permutation)
    end
    if not end_permutation then
        end_permutation = Array.reversed(init_permutation)
    end

    assert(IsPermutation(init_permutation, start_permutation), "GenereteScript: start_permutation is not permutation of init_permutation")
    assert(IsPermutation(init_permutation, end_permutation),   "GenereteScript: end_permutation is not permutation of init_permutation")

    -- Calculate ranges
    local ranges = CutPermutationsSequence(start_permutation, end_permutaion, nchunks)

    -- Write script file
    local script_filename = filename..script_type
    local script_file     = io.open(script_filename, "w+")
    assert(script_file, "Could not open file '"..script_filename.."' for writing")

    if script_type == ScriptType.Batch then
        script_file:write("@echo off\n")
    else
        script_file:write("#!/usr/bin/bash\n")
    end
        
    script_file:write("\n")
    script_file:write("\n")
    for i, range in ipairs(ranges) do
        local s = "nil"
        local e = "nil"
        if range[1] then
            s = Array.tostring(range[1])
        end
        if range[2] then
            e = Array.tostring(range[2])
        end
        local lua_command = "lua -e \"dofile '"..setup_lua_filename.."'\" Solve.lua "..filename.."_"..i.." \""..s.."\" \""..e.."\""
        if script_type == ScriptType.Batch then
            script_file:write("start /B "..lua_command.."\n")
        else
            script_file:write(lua_command.." &\n")
        end
    end

    script_file:close()
end

GenereteScript("SolveLonpos", ScriptType.Bash, "SolveLonposSetup.lua", nil, nil, 12)