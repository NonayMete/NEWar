% function [X, Y] = ClothoidAT(A, tau);
% function [X, Y, n, Xterms, Yterms] = ClothoidAT(A, tau, termslimit, plotterms);
%
% ClothoideAT calculates the position of a point on a clothoid with factor of proportionality
% A, where the clothoid tangent is at an angle of tau (radians) with the x axis.
%
% Calculation of X and Y is achieved by using a series approximation to the 
% clothoid function.  An increase in the number of terms used effects the resolution
% of the answers, and allows for points to be calculated further around the clothoid.
% By default, as many terms are calculated as required to achieve a certain nominal
% resolution, but an upper bound can be specified.
% 
% To observe the sensitivity of the result to the number of terms used, the terms 
% used in the calculation can also be plotted.
% 
% Input parameters:
%      A          is the factor of proportionality for the Clothoid
%      tau        is the angle of the tangent at the point P, in radians.
%                    (limited to 11*pi for numerical stability)
%      termslimit is any whole number starting from 2, limiting the number of terms used 
%                 in the summation.  Set to Inf for no limit.  Default = Inf.
%      plotterms  is a boolean value, requesting a plot of the terms.  Default = 0.
% Outputs:
%      X, Y       the coordinates of the point along the clothoid.
%      n          is the number of terms actually used.
%      Xterms     is the array of the terms used in the summation to find X.
%      Yterms     is the array of the terms used in the summation to find Y.
%
% eg:  Normal use - x and y for a specified A and tau, with unlimited iterations:
%      [X, Y] = ClothoidAT(1,5);
%
% eg:  Limiting the number of terms calculated for the summation, returning n, the 
%      iterations used, and the arrays of X and Y terms:
%      [X, Y, n, Xterms, Yterms] = ClothoidAT(1, 5*pi, 20);
%
% eg:  Plotting a clothoid, up to angle tau, with the number of terms limited to 20:
%      clear X Y;for i=1:180,[X(i) Y(i)]=ClothoidAT(1,(i-1)*pi/32, 20);end;
%      plot(X,Y,'g.',X,Y,'b');axis equal;
%      See the function  'DrawClothoid'
%
% eg:  Plotting the terms used for calculation
%      ClothoidAT(1, 5*pi, Inf, 1);
%      See the function 'ClothoidATTermsMovie'
%
% Note: to plot the terms, with no specified limit to the number of terms, 
%       set termslimit to Inf

% Author: Stephen LePage
% March 1999

function [X, Y, n, Xterms, Yterms] = ClothoidAT(A, tau, termslimit, plotterms)

if nargin < 2
   warning('ClothoidAT requires at least 2 arguments');
   help ClothoidAT
end

if nargin <= 2
   termslimit=Inf;
elseif isempty(termslimit)
   termslimit=Inf;
end

if nargin < 4
   plotterms = 0;
else
   plotterms = 1;
end

if tau>10*pi
   warning(['ClothoidAT: floating point resolution limited:  tau=' num2str(tau/pi) '*pi > 10*pi']);
   disp(['tau = ' num2str(tau/pi) '*pi  >  10*pi'])
end

%[S,C]=FresnelSC(2^0.5/pi^0.5*tau^0.5);
%X=A*pi^0.5*C;
%Y=A*pi^0.5*S;
%return

Xterms = (2*tau)^0.5;
Yterms = ((2*tau)^1.5)/6;
n=1;
if tau~=0
   RequiredPrecision = 1e-6;    %precision before multiplying by A, == 6 significant figures
   stop = n == termslimit;
   while ~stop
      n=n+1;
      Cx = (2*tau)^2 * (4*n-7) / ( 4 * (4*n-3) * (2*n-2) * (2*n-3) );
      Xterms(n) = -Xterms(n-1) * Cx;
      Cy = (2*tau)^2 * (4*n-5) / ( 4 * (4*n-1) * (2*n-1) * (2*n-2) );
      Yterms(n) = -Yterms(n-1) * Cy;
      
      stop = abs(Xterms(n))<abs(Xterms(n-1)) & abs(Xterms(n))< RequiredPrecision & ...
         abs(Yterms(n))<abs(Yterms(n-1)) & abs(Yterms(n))< RequiredPrecision;
      stop = stop | n >= termslimit;
   end
end
%   n
%   Xterms'
%   Yterms'
X=A*sum(Xterms);
Y=A*sum(Yterms);

if plotterms == 1
   figure(gcf);
   cla
   hold on;
   plot(1:n,Yterms,'g');
   plot(1:n,Xterms,'b');
   YLimmax=max(max(abs(Yterms)), max(abs(Xterms)));
   if YLimmax ~= 0
      set(gca,'YLim',[-YLimmax YLimmax]);
   end   
   h=text(0,0,['\tau = ' num2str(tau/pi) ' \pi']);
   set(h,'Units','normalized');
   set(h,'Position',[0.65 0.45]);
   set(h,'Color',[0 0 0.5]);
   set(h,'HorizontalAlignment','left', 'verticalalignment','top');

   h=text(0,0,['Xterms in blue']);
   set(h,'Units','normalized');
   set(h,'Position',[0.65 0.35]);
   set(h,'Color',[0 0 0.5]);
   set(h,'HorizontalAlignment','left', 'verticalalignment','top');

   h=text(0,0,['Yterms in green']);
   set(h,'Units','normalized');
   set(h,'Position',[0.65 0.25]);
   set(h,'Color',[0 0 0.5]);
   set(h,'HorizontalAlignment','left', 'verticalalignment','top');

   %drawnow;
end

   