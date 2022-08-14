% function [timetheta, timepos, M] = Linear(drawmode, TimeRampType, Tst, Tfin, Tsamp, startpt, endpt, m, alpha, beta, interactive)
%
% Generates a straight line trajectory based on 2 control points.
%
% Input parameters:
%      drawmode     please run 'help nomenclature' for a description.
%      TimeRampType is the type of movement profile to use.
%                   choose 'LinearTime', 'ParabolicTime', 'SineonRamp' or 'PolyTime'.
%      Tst          is the starting time.
%      Tfin         is the finishing time.
%      Tsamp        is the sample period, in seconds
%      startpt      is the starting point for the trajectory - a vector in the format [x;y;z])
%      endpt        is the ending point for the trajectory - a vector in the format [x;y;z])
%      m            is the ratio between the maximum acceleration (Aa), and the maximum 
%                   deceleration (Ad). 
%                   Note:  m - only applies to 'SineonRamp' and 'ParabolicTime' time ramps.
%      alpha        is the orientation of the motors in the 'alpha' direction, in degrees
%      beta         is the orientation of the motors in the 'beta' direction, in degrees
%      interactive  is a boolean value, to request the chance to modify the viewing angle
%                   using the 'rtpan' function before the motion simulation commences.
%                   Type 'help rtpan' for more details.
%
% Default Input values:  (unlisted parameters are required)
%      m            = 1
%      alpha        = -35.26
%      beta         = 60
%      interactive  = 0
%      Other defaults set by the functions InitArms and checkdrawmode
%
% Outputs:
%      timepos      is a matrix of time and position data
%                   Each row is in the form [t x(t) y(t) z(t)]
%      timetheta    is a matrix of time and motor angle data
%                   Each row is in the form [t theta1(t) theta2(t) theta3(t)]
%      M            is a matlab movie matrix.
%
% Press the space bar to end the simulation at any time.
%
% eg:  
%[timetheta, timepos] = Linear([3,0,1,0,1,0],'SineonRamp',0,1,0.05,[-0.3;0;-0.5],[0.3;0;-0.5],2,-35.26,60,1);

% Authors: Josh Male and Stephen LePage
% November 1998
% Revised March 1999


function [timetheta, timepos, M] = Linear(drawmode, TimeRampType, Tst, Tfin, Tsamp, ...
   startpt, endpt, m, alpha, beta, interactive)

if nargin < 7
   disp('The first 7 arguments are required:');
   pause
   help Linear
   return
end

% -------------
% Set Defaults:
% -------------

drawmode = checkdrawmode(drawmode);
if nargin < 8 | isempty(m)
   m=1;
end
if nargin < 9 | isempty(alpha)
   alpha=-35.26;  % NUWAR configuration
%	alpha=0;       % DELTA configuration
end
if nargin < 10 | isempty(beta)
   beta=60;       % NUWAR configuration
%	beta=0;        % DELTA configuration
end
if nargin < 11 | isempty(interactive)
   interactive = 0;
end

% --------------
% Set Constants:
% --------------

D = endpt - startpt;
d = norm(D);
u = D/d;

% ------------------------------------------------------------------
% generate time-profile (also refered to as the 'Movement-profile'):
% ------------------------------------------------------------------

switch TimeRampType 
case 'LinearTime', 
   [s, time] = LinearTime(d, Tst, Tfin, Tsamp); 
case 'ParabolicTime', 
   [s, time] = ParabolicTime(d, Tst, Tfin, m, Tsamp, 0);
case 'SineonRamp', 
   [s, time] = SineonRamp(d, Tst, Tfin, m, Tsamp, 0);
case 'PolyTime', 
   [s, time] = PolyTime(d, Tst, Tfin, mean([Tst, Tfin]), Tsamp, 0); 
otherwise,
   error('Please choose a valid Time Ramp function');
   return;
end

% --------------------------------
% Generate trajectory path points:
% --------------------------------
numPathPoints = size(time,1);

% Initialise output tables
timepos=time;
timetheta=time;

for i = 1:numPathPoints 
   posbase = startpt + s(i)*u;        % find each path point
   timepos(i,2:4)=posbase';
   if drawmode(1)==0
      % Perform Inverse Kinematics for non-graphical simulation
      timetheta(i,2:4)=IK(posbase, 0, alpha, beta)';    
   end
end

% ----------------
% Show Trajectory:
% ----------------

if drawmode(1)~=0
   if drawmode(6) == 1
      [timetheta, M] = ShowTrajectory(drawmode, timepos, alpha, beta, interactive);
   else
      [timetheta] = ShowTrajectory(drawmode, timepos, alpha, beta, interactive);
   end
end

