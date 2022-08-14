% function [data] = FFTS1exportPMACprog(FFTS1, dest)
%
% exportPMACprog exports joint space trajectory readable directly by a PMAC
% motion program to a specified file.

% Enosh Lam
% 20753711
% 2014
% Based on Chris Herring exportPMACprog(timetheta,dest)

function data = FFTPVTexportPMACprog(FFTPVT, dest)

fileID = fopen(dest, 'w');
FFTPVT = FFTPVT';
data = fprintf(fileID, 'X%.4f:%.4f Y%.4f:%.4f Z%.4f:%.4f A%.4f:%.4f B%.4f:%.4f C%.4f:%.4f\n', FFTPVT(1:12,:));
fclose(fileID);