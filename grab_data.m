
%Code to obtain syntq attributes from pi af server
%The inputs to the method are (in order): 
%campaign, 
%fileName to save as (filename without extension),
%path to save (Please include slash at end)
clear,clc
asmpath= '\\vertex-3\vertex-3\Continuous Manufacturing\PISynTQ\PIData\DLLs';
asmname='PIData.dll';
asm=NET.addAssembly(fullfile(asmpath,asmname));
cls=PIData.Core.Main;
r=RetrievePiSynTQAttributes(cls,'20170710-24235-01A','20170710-24235-01A','C:\Users\ramanv\Desktop\matlab_scripts\GUI\')

