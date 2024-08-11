@echo off

lua -e "package.path = package.path..';./Test/?.lua;../?.lua'..';./Test/?;../?'" %*