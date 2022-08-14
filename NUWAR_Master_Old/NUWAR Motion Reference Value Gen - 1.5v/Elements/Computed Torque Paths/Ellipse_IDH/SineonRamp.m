%function [s, time] = SineonRamp(d, Tst, Tfin, m, Tsamp)
%function [s, time] = SineonRamp(d, Tst, Tfin, m, Tsamp, show)
%
%eg:      [s, time] = SineonRamp(1, 0, 1, 2, 0.01, 1);
%
%Returns an array of times [time] and a corresponding time-profile [s] from the SineonRamp equation.
%where:- 
%    d is the total distance travelled
%    Tst is the starting time.
%    Tfin is the finishing time.
%    Ta is a specified time for zero acceleration (set to mean([Tst, Tfin]) for symetrical acceleration)
%    Tsamp is the sample period, in seconds
%    show = 1 means plot distance, velocity and acceleration graphs.

function [s, time] = SineonRamp(d, Tst, Tfin, m, Tsamp, show)
if nargin <= 5
   show = 0;
end
% Work with time values relative to Tst:
Tfin = Tfin - Tst;

Aa = d*pi*(1+m)/Tfin^2;				%max acceleration in the accelerating phase
Ad = Aa/m;								%max acceleration in the decelerating phase

Ta = Ad/(Aa + Ad) * Tfin;				%time-length of the acceleration phase
Td = Tfin - Ta;							%time-length of the deceleration phase

psi = pi*(1-Ta/Td);

time = [];
s = [];
for t=0:Tsamp:Ta
   time = [time;Tst+t];
   s = [s; Aa*Ta/pi*t - Aa*Ta^2/pi^2*sin(pi*t/Ta)]; %the Time-Profile from To to Ta
end
for t=(t+Tsamp):Tsamp:Tfin
   time = [time;Tst+t];
   s = [s; Ad*Td/pi*(t-Ta) + Aa/pi*Ta^2 - Ad*Td^2/pi^2*sin(pi/Td*t + psi)]; % the Time-Profile from Ta to Tfin
end

if show == 1
   % calculate velocity and acceleration profiles
   v = [];
   a = [];
   for t=0:Tsamp:Ta
      v = [v; Aa*Ta/pi - Aa*Ta/pi*cos(pi*t/Ta)]; 
      a = [a; Aa*sin(pi*t/Ta)];
   end
   for t=t+Tsamp:Tsamp:Tfin
      v = [v; Ad*Td/pi - Ad*Td/pi*cos(pi/Td*t + psi)];
      a = [a; Ad*sin(pi/Td*t + psi)];
   end
   % plot position, velocity, and acceleration in one figure
   figure(10);
   subplot(3,1,1); % plot displacement graph
   plot(time,s,'b');
   hold on;
   ylabel('S');
   subplot(3,1,2); % plot velocity graph
   plot(time,v,'b');
   hold on;
   ylabel('Vel');
   subplot(3,1,3); % plot acceleration graph
   plot(time,a,'b');
   hold on;   
   plot([time(1) time(length(time))],[0 0],'k');
   xlabel('Time');
   ylabel('Accn');
end
%set(gcf,'keypressfcn','closeonreturn')  % causes the figure window to close when the return key is pressed.

