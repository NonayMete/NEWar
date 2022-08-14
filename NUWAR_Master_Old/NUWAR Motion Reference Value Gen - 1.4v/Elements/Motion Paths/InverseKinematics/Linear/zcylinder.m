% function [X, Y, Z] = zcylinder(radius, n, zmin, zmax)
%
% Generates an n-sided cylinder with the axis centred on the z axis
% running form zmin to zmax

function [X, Y, Z] = zcylinder(radius, n, zmin, zmax)

[X,Y,Z] = cylinder([radius, radius], n);
Z = (Z * (zmax - zmin)) + zmin; %scale to length and offset by zmin

% end of the function
