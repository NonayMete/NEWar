% function data = exportExcel(timetheta, dest)
%
% exportExcel exports joint space trajectory readable my excel

% Chris Herring
% 20780784
% 2013
function data = exportExcel(timetheta, dest)


fileID = fopen(dest, 'w');
timetheta = timetheta';
fprintf(fileID, 'Time (s)\tMotor1\tMotor2\tMotor3\n');
data = fprintf(fileID, '0\t%.4f\t%.4f\t%.4f\n', timetheta(2:4,:));
fclose(fileID);
