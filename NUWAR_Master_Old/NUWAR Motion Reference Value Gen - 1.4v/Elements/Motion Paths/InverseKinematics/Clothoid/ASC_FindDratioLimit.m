% function [Dratio] = ASC_FindDratioLimit(alphaSC,usepolyapprox)
%
% This function returns the limiting d-ratio for a given alphaSC.
%
% Input parameters:
%      AlphaSC    is angle between the two tangent lines for the Summit Clothoid.
%                 It is specified in radians, and must by between 0 and pi.
%      usepolyapprox  = 0 means search for solution by numerical methods.
%                         This method takes between 2.7 and 3.7 seconds to find Dratio.
%                         (or between 144,000 and 388,000 flops in MATLAB notation)
%                     = 1 means use a polynomial approximation, for speed. (63 flops)
% Outputs:
%      Dratio     is the upper bound for both d1/d2 and d2/d1 for a summit clothoid
%                 having the specified alphaSC.
%
% eg: Dratio = ASC_FindDratioLimit(60*pi/180,0)

% Author: Stephen LePage
% March 1999

function [Dratio] = ASC_FindDratioLimit(alphaSC,usepolyapprox)

if nargin < 2
   usepolyapprox=0;
end

%find the maximum of the graph of tau1(Dratio) as a function of alphaSC --
if usepolyapprox ~= 0   % -- from tight 9 degree polynomial fit, alphaSC in degrees.
   P= [2.449834718748614e-022;    % <-- the polynomial coefficients
      -1.625361854599876e-019;    % Data obtained by the following procedure:
       4.990676143298261e-017;    %
      -9.258489519842860e-015;    % [Dratio, AlphaSC] = ASC_PlotAlphaSCDratio([0.1 10:10:170 179.9],0);
       9.498733633619346e-013;    % [P,S] = POLYFIT(AlphaSC,Dratio,9)
      -1.975993966336344e-010;    %
       2.703628121966064e-009;    % Analysis:
      -2.617522974523614e-005;    % [Y, DELTA]= polyval(P, [0.1 ,10:10:170 179.9], S)
       7.909890991501301e-007;    % max DELTA (error) value was 7.477582691903168e-008
       1.999996540390676e+000];
   Dratio = polyval(P,alphaSC*180/pi);   
else                    % -- by a search using numerical methods
   %Dratio = fmin('1-fzero(''ASC_Solve(x, P1, P2, 1)'', [eps*100*P1 (1-eps*100)*P1], [], [1], P1, x)',...
   %1,2,[1 1e-9],alphaSC);
   
   %Dratio = fmin('1-fzero(''ASC_Solve(x, P1, P2, 1)'', [eps*10*P1 (1-eps*10)*P1], eps*10, [1], P1, x)',...
   %1,2,[1 1e-9],alphaSC);
   
   Dratio = fmin('1-fzero(''ASC_Solve(x, P1, P2, 1)'', [eps*P1 (1-eps)*P1], 1e-9, [0], P1, x)',...
   1,2,[0 1e-9],alphaSC);
end


% Note context:
%
% X = FZERO('F',[lowx,highx], TOL, TRACE, P1, P2, ...)
% X =  FMIN('F',lowx, highx, [TRACE TOL], P1, P2, ...)
%
% fzero trails tau1 values in ASC_Solve(tau1, alphaSC, d1, d2) to find tau1(Dratio,alphaSC)
%
% tau1 = fzero('ASC_Solve(x, P1, P2, 1)', [eps*P1 (1-eps)*P1], [1e-9], [], alphaSC, DRatio)
%
% where:      [errorval, tau2, A1, A2] = solveASC(tau1, alphaSC, d1, d2)
%
% fmin then searches for the value of Dratio which 'maximises' tau1(Dratio,alphaSC).


% other previous attempts which fail with particular input values...
%
%Dratio = fmin('1-fzero(''ASC_Solve(x, P1, P2, P3)'', [0.000000001*P1 0.999999999*P1], [], [], P1, x, 1)',1.3,2,[],alphaSC);
%
%myeps = 0.01;  % resolves a technical bug - fzero trying invalid inputs to solveASC.
% - can test this bug with alpha = 130 degrees.
%Dratio = fmin('1-fzero(''ASC_Solve(x, P1, P2, P3)'', [P2 P1-P2], [], [1], P1, x, 1)',1.5,2,[1],alphaSC, myeps);
%
%Dratio = fmin('1-fzero(''ASC_Solve(x, P1, P2, P3)'', P1/2, [], [], P1, x, 1)',1.5,2,[],alphaSC);
%Dratio = fmin('1-fzero(''ASC_Solve(x, P1, P2, P3)'', [eps P1-eps], [], [], P1, x, 1)',1.5,2,[],alphaSC);

