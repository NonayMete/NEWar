% function [data] = exportPMACprog(timetheta, dest)
%
% exportPMACprog exports joint space trajectory readable directly by a PMAC
% motion program to a specified file.

% Chris Herring
% 20780784
% 2013

function data = exportPMACprog(timetheta, dest)

fileID = fopen(dest, 'w');
data = fprintf(fileID, 'x%9.4fy%9.4fz%9.4f\n', timetheta(:,2:4));
fclose(fileID);