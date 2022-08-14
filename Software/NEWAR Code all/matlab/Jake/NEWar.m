
%function [timetheta, timepos, M] = Cycloid(drawmode, TimeRampType, Tst, Tfin, Tsamp, startpt, endpt, sheared, m, alpha, beta)
writematrix([], 'angles.angles','WriteMode','overwrite','FileType','text');
fid = fopen('gerryx.coords');
textLine = fgets(fid); % Read first line.
lineCounter = 1;
ca = {};
while ischar(textLine)
  numbers = sscanf(textLine, '%f,');
  for k = 1 : length(numbers)
    ca{lineCounter, k} = numbers(k);
  end
    textLine = fgets(fid);
  lineCounter = lineCounter + 1;
end
fclose(fid);

for i=1:size(ca,1)
    theta = round(IK([ca{i,1},ca{i,2},ca{i,3}],[2 0 1 0 1 0]),5);
    theta = rot90(theta);
    if ca{i,4} ~= 0
        theta(end+1) = ca{i,4};
    end
    if ca{i,5} ~= 0
        theta(end+1) = ca{i,5};
    end
    if ca{i,6} ~= 0
        theta(end+1) = ca{i,6};
    end
    writematrix(theta,'angles.angles','WriteMode','append','FileType', ...
        'text');
end



system('"C:\Users\Public\NEWAR Parallel Robot\Software\NEWAR Code\x64\Release\NEWAR_Code.exe" angles.angles')

%theta = IK([0;0.3;-0.9],0)
%theta = IK([0.1;0.3;-0.5],0);
