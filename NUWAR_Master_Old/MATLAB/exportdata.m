% function [data] = exportdata(timetheta, dir, excel, pmac)
%
% ExportData uses exportExcel.m and exportPMACprog.m to export timetheta
% data to tab delimited format readable by excel and the PMAC

% Chris Herring, 2013

function exportdata(timetheta, dir, excel, pmac)

direxcel = strcat(dir, '/', excel);
dirpmac = strcat(dir, '/', pmac);
exportExcel(timetheta, direxcel);
exportPMACprog(timetheta, dirpmac);
