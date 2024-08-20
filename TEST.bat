@echo off


start /B lua -e "dofile 'Solve/SETUP.lua'" Solve/Solve.lua TEST_1 "{1, 2, 3, 4}" "{1, 4, 3, 2}"
start /B lua -e "dofile 'Solve/SETUP.lua'" Solve/Solve.lua TEST_2 "{2, 1, 3, 4}" "{2, 4, 3, 1}"
start /B lua -e "dofile 'Solve/SETUP.lua'" Solve/Solve.lua TEST_3 "{3, 1, 2, 4}" "{3, 4, 2, 1}"
start /B lua -e "dofile 'Solve/SETUP.lua'" Solve/Solve.lua TEST_4 "{4, 1, 2, 3}" "{4, 3, 2, 1}"
