% function [s, time, v, At, Jt] = ParabolicTime(d, Tst, Tfin, m, Tsamp, show)
%
% ParabolicTime generates a Parabolic movement profile.
%
% Input parameters:
%      d            is the total distance to travell
%      Tst          is the starting time.
%      Tfin         is the finishing time.
%      m            is the ratio between the maximum acceleration (Aa), and the maximum 
%                   deceleration (Ad). 
%                   Note:  m - only applies to 'SineonRamp' and 'ParabolicTime' time ramps.
%      Tsamp        is the sample period, in seconds
%      show         = 1 means calculate and plot distance, velocity and tangential  
%                   acceleration and tangential jerk graphs.
%                   Note:- This option must be set to 1 in order to export v, At, and Jt
%
% Default Input values:  (unlisted parameters are required)
%      show         = 0
%      Other defaults set by the functions InitArms and checkdrawmode
%
% Outputs:
%      time         an array of times, from Tst to Tfin step Tsamp
%      s            an array of corresponding positions
%      v            an array of corresponding velocities
%      At           an array of corresponding tangential accelerations
%      Jt           an array of corresponding tangential jerks
%
%eg:      
%[s, time, v, At, Jt] = ParabolicTime(1, 0, 1, 1.5, 0.01, 1);

% Authors: Josh Male and Stephen LePage
% November 1998

function [s, time, v, At, Jt] = ParabolicTime(d, Tst, Tfin, m, Tsamp, show)
if nargin == 0
   disp('This function requires arguments:');
   help ParabolicTime
   return
end
if nargin <= 5
   show = 0;
end
if show == 0 & nargout > 2 
   disp('Velocity, acceleration and jerk not available without ''show'' parameter set to 1');
   help ParabolicTime
   return
end
   
% Work with time values relative to Tst:
Tfin = Tfin - Tst;

Aa = d*2*(1+m)/Tfin^2;        %max acceleration in the accelerating phase [Codourey 5.3.6/8]
Ad = Aa/m;                    %max acceleration in the decelerating phase

Ta = Ad/(Aa + Ad) * Tfin;     %time-length of the acceleration phase [Codourey 5.3.9]
Td = Tfin - Ta;               %time-length of the deceleration phase

time = [];
s = [];
for t=0:Tsamp:Ta
   time = [time;Tst+t];       %add back Tst
   s = [s; Aa*t^2/2];         %the Time-Profile from To to Ta [Codourey 5.3.1]
end
for t=(t+Tsamp):Tsamp:Tfin
   time = [time;Tst+t];
   s = [s; -Ad*t^2/2 + Ta*(Ad+Aa)*t - (Aa+Ad)*Ta^2/2]; % the Time-Profile from Ta to Tfin 
end
s(size(s,1))=d;  % fixes numerical resolution error for last s value

if show == 1
   % calculate velocity and acceleration profiles
   v  = [];
   At = [];
   Jt = [];
   for t=0:Tsamp:Ta
      v  = [v ; Aa*t]; 
      At = [At; Aa];
      Jt = [Jt; 0];
   end
   for t=t+Tsamp:Tsamp:Tfin
      v  = [v; -Ad*t + Ta*(Aa+Ad)];
      At = [At; -Ad];
      Jt = [Jt; 0];
   end
   % plot position, velocity, and acceleration in one figure
   figure(10);
   
   subplot(4,1,1); % plot displacement graph
   hold on;
   plot(time,s,'b');
   ylabel('S');
   
   subplot(4,1,2); % plot velocity graph
   hold on;
   plot(time,v,'b');
   ylabel('Vel');
   
   subplot(4,1,3);
   hold on;
   plot(time,At,'b'); % plot acceleration graph
   n = size(time,1);
   plot([time(1) time(1)],[0 At(1)],'b');
   plot([time(n) time(n)],[0 At(n)],'b');
   ylabel('Accn');
   
   subplot(4,1,4);
   hold on;
   plot(time,Jt,'b'); % plot jerk graph
   plot([0 0],[0 100],'b');
   plot([Ta Ta],[0 -100],'b');
   plot([Tfin Tfin],[0 100],'b');
   ylabel('Jerk');
   xlabel('Time');
   
   rtpan('Q+++++iiiii-----rjjjjjjjffgZn');
   for h=get(gcf,'children')'
      subplot(h)
      set(gca,'YLimMode','auto');
      set(gca,'dataaspectratiomode','auto');
   end
   XLim=get(gca,'XLim');
   subplot(4,1,1);
   plot(XLim,[0 0],'k');
   subplot(4,1,2);
   plot(XLim,[0 0],'k');
   subplot(4,1,3);
   plot(XLim,[0 0],'k');
   subplot(4,1,4);
   plot(XLim,[0 0],'k');
end
