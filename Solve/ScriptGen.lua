require "Permutations"
require "Shapes"

ScriptType = {
    Bat  = ".bat",
    Bash = ".sh"
}

-- script_filename - name of output script without an extension 
-- script_type - type of the script (ScriptType.Bat or ScriptType.Bash)
-- setup_lua_filename - name if the file with problem setup information (grid and shapes)
-- start_permutation, end_permutaion - bounds in which to look for solutions (set both to nil if you want to find all of the solutions)
-- number_processes - number of processes that will run to solve the problem
function GenereteScript(script_filename, script_type, setup_lua_filename, start_permutation, end_permutaion, number_processes)
    assert(script_type == ScriptType.Bat or script_type == ScriptType.Bash, "unknown script type")

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
    local ranges = CutPermutationsSequence(start_permutation, end_permutaion, number_processes)

    -- Write script file
    local script_filename_full = script_filename..script_type
    local script_file          = io.open(script_filename_full, "w+")
    assert(script_file, "Could not open file '"..script_filename_full.."' for writing")

    local lua_preexecute = "\"dofile '"..setup_lua_filename.."'; package.path = package.path..';../?.lua;../?'\""
    if script_type == ScriptType.Bat then
        script_file:write("@echo off\n")
        script_file:write("\n")
        script_file:write("set preexec="..lua_preexecute.."\n")
        script_file:write("\n")
    else
        script_file:write("#!/usr/bin/bash\n")
        script_file:write("\n")
        script_file:write("preexec="..lua_preexecute.."\n")
        script_file:write("\n")
    end

    for i, range in ipairs(ranges) do
        local s = "nil"
        local e = "nil"
        if range[1] then
            s = Array.tostring(range[1])
        end
        if range[2] then
            e = Array.tostring(range[2])
        end

        if script_type == ScriptType.Bat then
            local lua_command = "lua -e %preexec% Solve\\Solve.lua "..script_filename.."_"..i.." \""..s.."\" \""..e.."\""
            script_file:write("start /B "..lua_command.."\n")
        else
            local lua_command = "lua -e $preexec Solve/Solve.lua "..script_filename.."_"..i.." \""..s.."\" \""..e.."\""
            script_file:write(lua_command.." &\n")
        end
    end

    print("Successfully generated '"..script_filename_full.."'")

    script_file:close()
end

GenereteScript("Lonpos", ScriptType.Bat, "Solve/LonposSetup.lua", nil, nil, 12)