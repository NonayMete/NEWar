%function [errorval, tau2, A1, A2, R1, R2] = ASC_Solve(tau1, alphaSC, d1, d2)
%
%This function is used firstly by the clothoid function, using Matlab's 'fzero' function
%to find (by numerical methods) the solution for tau1, with the given parameters,
%for the Asymmetric Summit Clothoid.
%Then it is used to return tau2, A1 and A2 to the clothoid function.
%Note: alphaSC, tau1, and tau2 are in radians.
%
% eg: Finding the parameters of solution clothoids:
% alphaSC = 130*pi/180;
% d1 = 1.5;
% d2 = 1;
% tau1 = fzero('ASC_Solve(x, P1, P2, P3)', [eps*alphaSC (1-eps)*alphaSC], [], [], alphaSC, d1, d2)
% [errorval, tau2, A1, A2, R1, R2] = ASC_Solve(tau1, alphaSC, d1, d2)
%

% Author: Stephen LePage
% March 1999

function [errorval, tau2, A1, A2, R1, R2] = ASC_Solve(tau1, alphaSC, d1, d2)

%define:
tau2 = alphaSC-tau1;

% Find W1 and W2 (the unscaled location of P2)in terms of each clothoid's origin.
% W1 and W2 define the gradients of rays cast from the clothoid's origins, 
% which intersect at the point P2
[W1x W1y] = ClothoidAT(1,tau1);
[W2x W2y] = ClothoidAT(1,tau2);

%establish transformation matrix to map between reference frames
mirrorx = [-1 0 0 0; 
            0 1 0 0; 
            0 0 1 0; 
            0 0 0 1];
T31 = trans(d1,0,0)*rotz(alphaSC)*trans(d2,0,0)*mirrorx;

% map P3 and W2 into P1's reference frame
P3itoP1 = T31*[0;0;0;1];      %P3 in terms of P1's reference frame
W2itoP1 = T31*[W2x;W2y;0;1];  %W2 in terms of P1's reference frame

% extract co-ordinates of the transformed points, for convenience
P3tx=P3itoP1(1);  
P3ty=P3itoP1(2);
W2tx=W2itoP1(1);
W2ty=W2itoP1(2);

% calculate A1 and A2
A2 = (P3ty*W1x - P3tx*W1y) / ( W1y*(W2tx-P3tx) - W1x*(W2ty-P3ty) );
A1      = (A2*(W2tx-P3tx) + P3tx) / W1x;
%A1check = (A2*(W2ty-P3ty) + P3ty) / W1y;   % verifying equations --> ok

% check if chosen tau1 is correct, by comparing radii of curvature of the clothoids 
% at connection P2
R1 = abs(A1)/((2*tau1)^0.5);
R2 = abs(A2)/((2*tau2)^0.5);

%return the difference, for use by Matlab's 'fzero' function in finding tau1.
errorval = R1-R2;

%debugging:
if isreal(errorval)==0
   tau1
   tau1DEG=tau1*180/pi
   alphaSC
   alphaSCDEG=alphaSC*180/pi
   d1
   d2
   A1
   A2
   R1
   R2
   errorval
   error('SolveASC: imaginary parts - investigation required.  Now quitting.');   
end



