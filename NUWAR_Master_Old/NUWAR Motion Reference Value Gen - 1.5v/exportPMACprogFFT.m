% function [data] = exportPMACprogFFT(FFT, dest)
%
% exportPMACprog exports joint space trajectory readable directly by a PMAC
% motion program to a specified file.

% Enosh Lam
% 20753711
% 2014
% Based on Chris Herring exportPMACprog(timetheta,dest)
function data = exportPMACprogFFT(FFT, dest)

fileID = fopen(dest, 'w');
FFT = FFT';
data = fprintf(fileID,'X%.4f:%.4f Y%.4f:%.4f Z%.4f:%.4f\n', FFT(1:6,:));
fclose(fileID);
