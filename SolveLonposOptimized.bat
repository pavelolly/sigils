@echo off

@REM ranges in this script are optimized so that every process finds almost equal number of solutions

start /B lua -e "dofile 'SolveLonposSetup.lua'" Solve.lua SolveLonposOptimized_1 "{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}" "{2, 1, 3, 10, 8, 6, 7, 11, 12, 9, 5, 4}"
start /B lua -e "dofile 'SolveLonposSetup.lua'" Solve.lua SolveLonposOptimized_2 "{2, 1, 3, 10, 8, 6, 7, 12, 4, 5, 9, 11}" "{2, 10, 4, 7, 8, 6, 9, 12, 11, 5, 3, 1}"
start /B lua -e "dofile 'SolveLonposSetup.lua'" Solve.lua SolveLonposOptimized_3 "{2, 10, 4, 7, 8, 6, 11, 1, 3, 5, 9, 12}" "{3, 8, 7, 5, 9, 6, 12, 10, 11, 1, 2, 4}"
start /B lua -e "dofile 'SolveLonposSetup.lua'" Solve.lua SolveLonposOptimized_4 "{3, 8, 7, 5, 9, 6, 12, 10, 11, 1, 4, 2}" "{4, 6, 3, 1, 11, 7, 9, 12, 10, 5, 2, 8}"
start /B lua -e "dofile 'SolveLonposSetup.lua'" Solve.lua SolveLonposOptimized_5 "{4, 6, 3, 1, 11, 7, 9, 12, 10, 5, 8, 2}" "{4, 12, 11, 10, 9, 8, 7, 6, 5, 3, 2, 1}"
start /B lua -e "dofile 'SolveLonposSetup.lua'" Solve.lua SolveLonposOptimized_6 "{5, 1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12}" "{5, 10, 6, 12, 9, 11, 4, 7, 8, 2, 1, 3}"
start /B lua -e "dofile 'SolveLonposSetup.lua'" Solve.lua SolveLonposOptimized_7 "{5, 10, 6, 12, 9, 11, 4, 7, 8, 2, 3, 1}" "{6, 5, 7, 8, 4, 9, 10, 3, 2, 11, 1, 12}"
start /B lua -e "dofile 'SolveLonposSetup.lua'" Solve.lua SolveLonposOptimized_8 "{6, 5, 7, 8, 4, 9, 10, 3, 2, 11, 12, 1}" "{8, 3, 6, 5, 11, 7, 4, 12, 9, 2, 1, 10}"
start /B lua -e "dofile 'SolveLonposSetup.lua'" Solve.lua SolveLonposOptimized_9 "{8, 3, 6, 5, 11, 7, 4, 12, 9, 2, 10, 1}" "{8, 12, 11, 10, 9, 7, 6, 5, 4, 3, 2, 1}"
start /B lua -e "dofile 'SolveLonposSetup.lua'" Solve.lua SolveLonposOptimized_10 "{9, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12}" "{10, 12, 11, 9, 8, 7, 6, 5, 4, 3, 2, 1}"
start /B lua -e "dofile 'SolveLonposSetup.lua'" Solve.lua SolveLonposOptimized_11 "{11, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12}" "{11, 12, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1}"
start /B lua -e "dofile 'SolveLonposSetup.lua'" Solve.lua SolveLonposOptimized_12 "{12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}" "{12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1}"