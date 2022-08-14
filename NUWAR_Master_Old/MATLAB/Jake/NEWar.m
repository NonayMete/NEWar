M = readmatrix('coords.coords','FileType','text');
writematrix([], 'Jake/angles.angles','WriteMode','overwrite','FileType','text');
for i=1:size(M,1)
    theta = round(IK([M(i,1),M(i,2),M(i,3)],0),5);
    theta = rot90(theta);
    if size(M,2)>3
        theta(end+1) = M(i,4);
    end
    if size(M,2)>4
        theta(end+1) = M(i,5);
    end
    if size(M,2)>5
        theta(end+1) = M(i,6);
    end
    writematrix(theta,'Jake/angles.angles','WriteMode','append','FileType', ...
        'text');
end


system('NEWAR Code.exe')
%theta = IK([0;0.3;-0.9],0)
%theta = IK([0.1;0.3;-0.5],0);
