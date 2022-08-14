% function [data] = FFTS1exportPMACprog(FFTS1, dest)
%
% exportPMACprog exports joint space trajectory readable directly by a PMAC
% motion program to a specified file.

% Enosh Lam
% 20753711
% 2014
% Based on Chris Herring exportPMACprog(timetheta,dest)

function data = FFTS1exportPMACprog(FFTS1, dest)

fileID = fopen(dest, 'w');
FFTS1 = FFTS1';
data = fprintf(fileID, 'X%.4f Y%.4f Z%.4f A%.4f B%.4f C%.4f\n', FFTS1(1:6,:));
fclose(fileID);