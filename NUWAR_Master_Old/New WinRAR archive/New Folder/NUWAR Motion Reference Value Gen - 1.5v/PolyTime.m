%function [s, time] = PolyTime(d, Tst, Tfin, Ta, Tsamp)
%function [s, time] = PolyTime(d, Tst, Tfin, Ta, Tsamp, show)
%
%eg:      [s, time] = PolyTime(1, 0, 1, 0.5, 0.01, 1);
%
%Returns an array of times [time] and a corresponding time-profile [s] from an polynomial equation
%found by the direct solution of the boundary constraints.
%where:- 
%    d is the total distance travelled
%    Tst is the starting time.
%    Tfin is the finishing time.
%    Ta is a specified time for zero acceleration (set to mean([Tst, Tfin]) for symetrical acceleration)
%    Tsamp is the sample period, in seconds
%    show = 1 means plot distance, velocity and acceleration graphs.

function [s, time] = PolyTime(d, Tst, Tfin, Ta, Tsamp, show)
if nargin == 0
   disp('This function requires arguments:');
   help PolyTime
   return
end
if nargin <= 5
   show = 0;
end
% Work with time values relative to Tst:
Tfin = Tfin - Tst;
Ta = Ta - Tst;

%Ploynomial is in the form:
%s = a0 + a1*t + a2*t^2 + a3*t^3 + a4*t^4 + a5*t^5 [+ a6*t^6]
%Note that a0,a1,a2 are 0

%Local variables for saving on calculation.
Tfin2=Tfin^2;
Tfin3=Tfin2*Tfin;
Tfin4=Tfin3*Tfin;
Tfin5=Tfin4*Tfin;
Ta2=Ta^2;

%old 5th order parameters
%a3 = 10*d/Tfin3;
%a4 = -15*d/Tfin4;
%a5 = 6*d/Tfin5;

%from mathematica (this has a fault - still working on it...):
denom = 5*Ta2 - 5*Ta*Tfin + Tfin2;
a3 = -10*d*(-5*Ta2 + 3*Ta*Tfin) / (Tfin3*denom);
a4 = 15*d*(-5*Ta2 + Ta*Tfin + Tfin2) / (Tfin4*denom);
a5 = -6*d*(-5*Ta2 - 5*Ta*Tfin + 4*Tfin2) / (Tfin5*denom);
a6 = -10*d*(2*Ta - Tfin) / (Tfin5*denom);

time = [];
s = [];
for t=0:Tsamp:Tfin
   time = [time;Tst+t]; % record absolute time values
   s = [s; a3*t^3 + a4*t^4 + a5*t^5 + a6*t^6];
end

if show == 1
   % calculate velocity and acceleration profiles
   v = [];
   a = [];
   for t=0:Tsamp:Tfin
      v = [v; 3*a3*t^2 + 4*a4*t^3 + 5*a5*t^4 + 6*a6*t^5];
      a = [a; 6*a3*t + 12*a4*t^2 + 20*a5*t^3 + 30*a6*t^4];
   end
   % plot position, velocity, and acceleration in one figure
   figure(10);
   subplot(3,1,1); % plot displacement graph
   plot(time,s,'r');
   hold on;
   ylabel('S');
   subplot(3,1,2); % plot velocity graph
   plot(time,v,'r');
   hold on;
   ylabel('Vel');
   subplot(3,1,3);
   plot(time,a,'r'); % plot acceleration graph
   hold on;
   plot([time(1) time(length(time))],[0 0],'k');
   xlabel('Time');
   ylabel('Accn');
end
%set(gcf,'keypressfcn','closeonreturn')  % causes the figure window to close when the return key is pressed.

