@echo off

all soultions
start /B lua SolveLonpos.lua 1  "nil                         " "{1,12,11,10,9,8,7,6,5,4,3,2}"
start /B lua SolveLonpos.lua 2  "{2,1,3,4,5,6,7,8,9,10,11,12}" "{2,12,11,10,9,8,7,6,5,4,3,1}"
start /B lua SolveLonpos.lua 3  "{3,1,2,4,5,6,7,8,9,10,11,12}" "{3,12,11,10,9,8,7,6,5,4,2,1}"
start /B lua SolveLonpos.lua 4  "{4,1,2,3,5,6,7,8,9,10,11,12}" "{4,12,11,10,9,8,7,6,5,3,2,1}"
start /B lua SolveLonpos.lua 5  "{5,1,2,3,4,6,7,8,9,10,11,12}" "{5,12,11,10,9,8,7,6,4,3,2,1}"
start /B lua SolveLonpos.lua 6  "{6,1,2,3,4,5,7,8,9,10,11,12}" "{6,12,11,10,9,8,7,5,4,3,2,1}"
start /B lua SolveLonpos.lua 7  "{7,1,2,3,4,5,6,8,9,10,11,12}" "{7,12,11,10,9,8,6,5,4,3,2,1}"
start /B lua SolveLonpos.lua 8  "{8,1,2,3,4,5,6,7,9,10,11,12}" "{8,12,11,10,9,7,6,5,4,3,2,1}"
start /B lua SolveLonpos.lua 9  "{9,1,2,3,4,5,6,7,8,10,11,12}" "{9,12,11,10,8,7,6,5,4,3,2,1}"
start /B lua SolveLonpos.lua 10 "{10,1,2,3,4,5,6,7,8,9,11,12}" "{10,12,11,9,8,7,6,5,4,3,2,1}"
start /B lua SolveLonpos.lua 11 "{11,1,2,3,4,5,6,7,8,9,10,12}" "{11,12,10,9,8,7,6,5,4,3,2,1}"
start /B lua SolveLonpos.lua 12 "{12,1,2,3,4,5,6,7,8,9,10,11}" "nil"

@REM start /B lua SolveLonpos.lua 12_1  "{12,1,2,3,4,5,6,7,8,9,10,11}" "{12,1,11,10,9,8,7,6,5,4,3,2}"
@REM start /B lua SolveLonpos.lua 12_2  "{12,2,1,3,4,5,6,7,8,9,10,11}" "{12,2,11,10,9,8,7,6,5,4,3,1}"
@REM start /B lua SolveLonpos.lua 12_3  "{12,3,1,2,4,5,6,7,8,9,10,11}" "{12,3,11,10,9,8,7,6,5,4,2,1}"
@REM start /B lua SolveLonpos.lua 12_4  "{12,4,1,2,3,5,6,7,8,9,10,11}" "{12,4,11,10,9,8,7,6,5,3,2,1}"
@REM start /B lua SolveLonpos.lua 12_5  "{12,5,1,2,3,4,6,7,8,9,10,11}" "{12,5,11,10,9,8,7,6,4,3,2,1}"
@REM start /B lua SolveLonpos.lua 12_6  "{12,6,1,2,3,4,5,7,8,9,10,11}" "{12,6,11,10,9,8,7,5,4,3,2,1}"
@REM start /B lua SolveLonpos.lua 12_7  "{12,7,1,2,3,4,5,6,8,9,10,11}" "{12,7,11,10,9,8,6,5,4,3,2,1}"
@REM start /B lua SolveLonpos.lua 12_8  "{12,8,1,2,3,4,5,6,7,9,10,11}" "{12,8,11,10,9,7,6,5,4,3,2,1}"
@REM start /B lua SolveLonpos.lua 12_9  "{12,9,1,2,3,4,5,6,7,8,10,11}" "{12,9,11,10,8,7,6,5,4,3,2,1}"
@REM start /B lua SolveLonpos.lua 12_10 "{12,10,1,2,3,4,5,6,7,8,9,11}" "{12,10,11,9,8,7,6,5,4,3,2,1}"
@REM start /B lua SolveLonpos.lua 12_11 "{12,11,1,2,3,4,5,6,7,8,9,10}" "nil"

