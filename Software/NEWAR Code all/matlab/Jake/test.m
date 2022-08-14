%coords = FK([83;85;86],0)

%[timetheta, timepos] = Cycloid([2,0,1,0,4,0],'SineonRamp', 0, 1, 0.05, [-0.3;0;-0.55], [0.3;0;-0.55], 0, 1)
[timetheta, timepos] = Cycloid(0,'SineonRamp', 0, 3, 0.05, [-0.3;0;-0.7], [0.3;0;-0.7], 0, 1)
%[timetheta, timepos] = Ellipse([3,0,1,0,1,0],'SineonRamp',0,1,0.05,[-0.3;0;-0.5],[0.3;0;-0.5],[0;0;-0.4],1.5,-35.26,60,0)
%[timetheta] = Linear([2,0,1,0,4,0],'SineonRamp',0,2,0.05,[-0.3;0;-0.55],[0.3;0;-0.55],0,1)
saveData(timetheta, 'angles.angles');

system('"C:\Users\jakel\OneDrive\Lorkin Consulting\NEWAR Parallel Robot\Software\NEWAR Code\x64\Release\NEWAR_Code.exe" angles.angles')