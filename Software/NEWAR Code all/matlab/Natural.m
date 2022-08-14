% function [timetheta,timepos] = Natural(drawmode, TimeRampType, Tst, Tfin, Tsamp,...
%                                         startpt, endpt, m, alpha, beta);
%
% Generates the robot's 'natural' trajectory based on 2 control points.
% The TimeRamp function, in this case, is used to vary the motor angles.
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
% Default values:
%      startpt      = [-0.1,-0.4,-0.5];
%      endpt        = [0.1,0.4,-0.5];
%      m            = 1
%      alpha        = -35.26
%      beta         = 60
%      Other defaults set by the functions InitArms and checkdrawmode
%
% Outputs:
%      timepos      is a matrix of time and position data
%                   Each row is in the form [t x(t) y(t) z(t)]
%      timetheta    is a matrix of time and motor angle data
%                   Each row is in the form [t theta1(t) theta2(t) theta3(t)]
%
% Press the space bar to end the simulation at any time.
%
% eg:
%[timetheta,timepos] = Natural([2 0 1 0 4 0],'ParabolicTime',0,1,0.05,[0;-0.4;-0.6],[0,0.4,-0.6]);
%[timetheta,timepos] = Natural([2 0 1 0 4 0],'LinearTime',0,1,0.05,[-0.4;-0.4;-0.6],[0.4,0.4,-0.6]);
%[timetheta,timepos] = Natural([2 0 1 0 4 0],'SineonRamp',0,1,0.05,[-0.4;-0.4;-0.6],[0.4,0.4,-0.6],2,-35.26,60);

% Author: Stephen LePage
% March 1999

function [timetheta,timepos] = Natural(drawmode, TimeRampType, Tst, Tfin, Tsamp,...
   startpt, endpt, m, alpha, beta);

if nargin < 5
   disp('The first 7 arguments are required:');
   help Natural
   return
end

% -------------
% Set Defaults:
% -------------

drawmode = checkdrawmode(drawmode);
if nargin < 6 | isempty(startpt)
   startpt = [-0.1,-0.4,-0.5];
end
if nargin < 7 | isempty(endpt)
   endpt = [0.1,0.4,-0.5];
end
if nargin < 8
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

% ------------------------------------------------------------------
% generate time-profile (also refered to as the 'Movement-profile'):
% ------------------------------------------------------------------

%Use these vairous time-profiles to profile the motor movement
switch TimeRampType 
case 'LinearTime', 
   [s, time] = LinearTime(1, Tst, Tfin, Tsamp); 
case 'ParabolicTime', 
   [s, time] = ParabolicTime(1, Tst, Tfin, m, Tsamp, 0);
case 'SineonRamp', 
   [s, time] = SineonRamp(1, Tst, Tfin, m, Tsamp, 0);
case 'PolyTime', 
   [s, time] = PolyTime(1, Tst, Tfin, mean([Tst, Tfin]), Tsamp, 0); 
otherwise,
   error('Please choose a valid Time Ramp function');
   return;
end

% set starting and finishing angles for the motors
thetastart = IK(startpt,0,alpha,beta);
thetafinish = IK(endpt,0,alpha,beta);
n = size(time,1); % number of points generated
for i = 1:n
   theta(i,:) = thetastart'*(1-s(i)) + thetafinish'*s(i);
end

% calculate timepos.  Position is used to plot the trajectory.
for i = 1:n
   timepos(i,1)=1/(n-1)*(i-1);  %generates artificial times from 0 to 1
   timepos(i,2:4)=FK(theta(i,:)', 0, alpha, beta)'; % calculate only, so put 0 for 'drawmode' 
end
if nargout >= 2 
   timetheta = [timepos(:,1) theta];
end

% -----------------------------------------
% Show Trajectory: (Using FK instead of IK)
% -----------------------------------------

if drawmode(1)~=0	  % only draw if specified by the user
   drawmode(3) = 1;	% ensure we initialise the base
   disp('press SPACE to end cycle, and then DELETE to close window...');
   pause;
   
   InitBase(drawmode,alpha*pi/180, beta*pi/180);
   drawmode(3)=0;  % we won't need to initialise the base again
   
   % need to determine whether or not this function is being called the GUI
   % and if so get a handle to its axes; otherwise get the handles to all the 
   % axes (the number of which was specified by 'drawmode(5)') of the current
   % figure.
   if drawmode(4) == 1 
      axeshandles = findobj('Tag','GuiAxes1');
   else
      axeshandles = get(gcf,'children');
   end
   
   % draws the trajectory, then sets it so that it is not erased with 'cla'
   for plot=1:size(axeshandles,1)
	   subplot(axeshandles(plot));
		h=plot3(timepos(:,2)',timepos(:,3)',timepos(:,4)','b-');
		set(h,'handlevisibility','off')
	end
   
   % perform the animation, drawing a pose of the robot for each of the control points
   % specified in joint space
   while 1,
      for i = 1:n
         FK(theta(i,:)', drawmode, alpha, beta);
         if drawmode(5) <= 2
            %revolve(axeshandles, -360/n,1);
         end
         drawnow;
         if strcmp(get(gcf,'currentcharacter'),' ') == 1 %exit loop if space key is pressed
            return;
         end	   
      end
   end
end
