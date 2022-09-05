@echo off

echo Running NEWAR_Code.exe and parsing angles fileset 

set /p file=Enter file: 
echo Parsing %file%

echo angles.angles format
echo angle1, angle2, angle3, acceleration, speed, time


NEWAR_Code.exe %file%

echo file ended
pause