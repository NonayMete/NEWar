% function [data] = exportPMACprogPVT(pvt, dest)
%
% exportPMACprog exports joint space trajectory readable directly by a PMAC
% motion program to a specified file.

% Enosh Lam
% 20753711
% 2014
% Based on Chris Herring exportPMACprog(timetheta,dest)

function data = exportPMACprogPVT(pvt, dest)

fileID = fopen(dest, 'w');
pvt = pvt';
data = fprintf(fileID,'X%.4f:%.4f Y%.4f:%.4f Z%.4f:%.4f\n', pvt(1:6,:));
fclose(fileID);


