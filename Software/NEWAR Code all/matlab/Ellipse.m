% function [timetheta, timepos, M] = Ellipse(drawmode, TimeRampType, Tst, Tfin, Tsamp, ...
%                                      startpt, endpt, mid_data, m, alpha, beta, interactive)
%
% Ellipse generates a semi-eliptical trajectory, based on 2 or 3 input points.
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
%      mid_data     is used to define the scalling and rotation of the semi-ellipse
%                   It can be of either of these two formats:
%                   [x;y;z]                  - a way point, uniquely defineing the ellipse, or
%                   [eccentricity, sheared]  - to define an ellipse in the vertical place, where
%                        eccentricity : minor axis lentgh (B) divided by major axis lentgh (A)
%                        sheared : a boolean value requesting that the ellipse be sheared to 
%                                  make the starting and finishing velocities vertical.
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
% eg 1:  
%[timetheta, timepos] = Ellipse([3,0,1,0,1,0],'SineonRamp',0,1,0.05,[-0.3;0;-0.5],[0.3;0;-0.5],[0;0;-0.4],1.5,-35.26,60,0);
%
% eg 2:
%[timetheta, timepos] = Ellipse([3,0,1,0,1,0],'SineonRamp',0,1,0.05,[-0.3;0;-0.5],[0.3;0;-0.5],[0.3 0],1.5,-35.26,60,0);

% Authors: Josh Male and Stephen LePage
% November 1998
% Revised March 1999

function [timetheta, timepos, M] = Ellipse(drawmode, TimeRampType, Tst, Tfin, Tsamp, ...
   startpt, endpt, mid_data, m, alpha, beta, interactive)

if nargin < 8
   disp('The first 8 arguments are required:');
   pause
   help Ellipt3p
   return
end

% -------------
% Set Defaults:
% -------------

drawmode = checkdrawmode(drawmode);
if nargin < 9 | isempty(m)
   m=1;
end
if nargin < 10 | isempty(alpha)
   alpha=-35.26;  % NUWAR configuration
%	alpha=0;       % DELTA configuration
end
if nargin < 11 | isempty(beta)
   beta=60;       % NUWAR configuration
%	beta=0;        % DELTA configuration
end
if nargin < 12 | isempty(interactive)
   interactive = 0;
end

% --------------
% Set Constants:
% --------------

[r,c]=size(mid_data);
if r*c == 3
   midpt = mid_data;
   DataPoints=3;
elseif r*c == 2
   eccentricity = mid_data(1);
   sheared = mid_data(2);
   DataPoints=2;
else
   disp('mid_data invalid:');
   pause
   help Ellipse
   return
end

% -----------------------------
% calculate ellipse parameters:
% -----------------------------

% setting up the local ellipse axes & parameters
A = 0.5 * norm(startpt-endpt);   % A - major semi-axis length
C = 1/2 * (endpt + startpt);     % C - centre point of the ellipse

% n1,n2,n3 are the unit vectors corresponding to the local coordinate system - xw,yw,zw
n1 = (endpt - startpt) / (2 * A);
if DataPoints == 3
   temp = cross(n1, midpt-startpt);
   n3 = temp / norm(temp);
   n2 = cross(n3,n1);
   
   % finding coords of 'midpt' in the local coord system
   xwm = dot(n1, midpt - C);  %local coordinates of the midpoint
   ywm = dot(n2, midpt - C);
   
   % working out the minor semi-axis length, 'B'
   um = acos(xwm / A);  %parameter(angle) for the ellipse representing the midpoint
   B = ywm / sin(um);
else
   n3 = cross(n1, [0;0;1]);
   if sheared == 1
      n2 = [0;0;1];
   else
      n2 = cross(n3,n1);
   end
   % working out the minor semi-axis length, 'B'
   B = A * eccentricity;
end   

% ------------------------------------------------------------------
% generate time-profile (also refered to as the 'Movement-profile'):
% ------------------------------------------------------------------

switch TimeRampType 
case 'LinearTime', 
   [theta, time] = LinearTime(pi, Tst, Tfin, Tsamp); 
case 'ParabolicTime', 
   [theta, time] = ParabolicTime(pi, Tst, Tfin, m, Tsamp, 0);
case 'SineonRamp', 
   [theta, time] = SineonRamp(pi, Tst, Tfin, m, Tsamp, 0);
case 'PolyTime', 
   [theta, time] = PolyTime(pi, Tst, Tfin, mean([Tst, Tfin]), Tsamp, 0); 
otherwise,
   error('Please choose a valid Time Ramp function');
   return;
end

% --------------------------------
% Generate trajectory path points:
% --------------------------------

% Initialise output tables
timepos=time;
timetheta=time;

% setting up the matrix representing the local ellipse coordinate frame
T = [n1 n2 n3 C];
T(4,1:4) = [0 0 0 1];

numPathPoints = size(time,1);
for i = 1:numPathPoints
   % find each point in the in local coords
   xw = A * -cos(theta(i));
   yw = B * sin(theta(i));
   zw = 0;
   posw = [xw; yw; zw; 1];
   
   %transforming back to base coords
   posbase = T * posw;
   
   timepos(i,2:4)=posbase(1:3)';
   if drawmode(1)==0
      % Perform Inverse Kinematics for non-graphical simulation
      timetheta(i,2:4)=IK(posbase(1:3), 0, alpha, beta)';    
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
