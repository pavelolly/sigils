#!usr/bin/bash

lua -e "package.path = package.path..';./Test/?.lua;../?.lua'..';./Test/?;../?'" $*