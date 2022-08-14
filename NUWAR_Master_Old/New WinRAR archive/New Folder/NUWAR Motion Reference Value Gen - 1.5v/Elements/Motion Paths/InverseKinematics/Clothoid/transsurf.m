% function [Xt, Yt, Zt] = transsurf(T, X, Y, Z)
%
% Function transforms X Y Z matrices defining a parametric surface
% according to the homogeneous transformation T.

function [Xt, Yt, Zt] = transsurf(T,X,Y,Z)

[rows, cols] = size(X);
rc = rows * cols;


X = reshape(X, rc, 1); % reshape X Y & Z into long column vectors
Y = reshape(Y, rc, 1);
Z = reshape(Z, rc, 1);
one = ones(rc, 1);  % A long column vector of ones

PTS = [X Y Z one]'; % Put column vectors together and then transpose matrix
					% to form positions in homogeneous coordinates.

PTS = T * PTS; 		% Transform the points

Xt = reshape(PTS(1,:),rows,cols); % Extract the separate coordinates and
Yt = reshape(PTS(2,:),rows,cols); % reshape them back to their original matrix
Zt = reshape(PTS(3,:),rows,cols); % dimensions.

% end of the function
