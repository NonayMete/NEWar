% function [data] = exportPMACprog(timetheta, dest)
%
% exportPMACprog exports joint space trajectory readable directly by a PMAC
% motion program to a specified file.

% Chris Herring
% 20780784
% 2013

function data = exportPMACprog(timetheta, dest)

fileID = fopen(dest, 'w');
timetheta = timetheta';
data = fprintf(fileID, 'X%.4f Y%.4f Z%.4f\n', timetheta(2:4,:));
fclose(fileID);