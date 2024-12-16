require "Solve/ScriptGen"

GenerateScript(
    "Lonpos505",             -- script name without file extension
    ScriptType.Bash,          -- script type (ScriptType.Bat or ScriptType.Bash)
    "Solve/LonposSetup.lua", -- setup file name
    nil, nil,                -- optional permutations boundaries (nils mean to search all of them)
    12                       -- number of processes
)