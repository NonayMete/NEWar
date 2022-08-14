% function [X, Y, Z] = xcylinder(radius, n, xmin, xmax)
%
% Generates an n-sided cylinder with the axis centred on the x axis
% running from xmin to xmax

function [X, Y, Z] = xcylinder(radius, n, xmin, xmax)

[Z, Y, X] = cylinder([radius, radius], n); % Note X, Z swapped to align 
					   % with x axis
X = (X * (xmax - xmin)) + xmin;		   % scale to length and offset by xmin

% end of the function
