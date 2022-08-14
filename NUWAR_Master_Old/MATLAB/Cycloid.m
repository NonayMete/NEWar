% function [timetheta, timepos, M] = Cycloid(drawmode, TimeRampType, Tst, Tfin, Tsamp, startpt, endpt, sheared, m, alpha, beta)
% eg:      [timetheta, timepos] = Cycloid([2,0,1,0,4,0],'SineonRamp', 0, 1, 0.05, [-0.3;0;-0.6], [0.3;0;-0.6], 0, 1);
%
% Generates a cycloidal trajectory based on 2 control points -
% The path will be in the vertical plane.
%
% where
%       TimeRampType - choose 'SineonRamp', 'PolyTime' or 'LinearTime'
%       Tst is the starting time.
%       Tfin is the finishing time.
%       Tsamp is the sample period, in seconds
%       startpt - start point of trajectory
%       endpt - end point of trajectory
%          each of these parameters should be points in cartesian space, and in one column
%          startpt and endpt for the major semi-axis of the ellipse
%       m - the ratio between the maximum acceleration (Aa) and the maximum deceleration (Ad)
% Note
%       m - only applies to 'SineonRamp' time ramp.
%
% drawmode = [{0,1,2}, {0,1}, {0,1}, {0,1}, {1,2,4}, {0,1}]
% where param1 = 0 means don't plot
%              = 1 means plot wire frame
%              = 2 means plot wire frame with accurate representation of forearms
%              = 3 means plot cylinder representation
%       param2 = 1 means also plot reference frames
%       param3 = 1 means initialise the display
%       param4 = 1 means writing to GUI
%       param5 = number of plots generated (eg 2 for stereo)
%       param6 = 1 means create a movie for playback
%
% Default values:
%       m       = 1
%       alpha   = 0
%       beta    = 0
% Note: 
%       All angles in degrees.
%       Other defaults set by InitArms and checkdrawmode

function [timetheta, timepos, M] = Cycloid(drawmode, TimeRampType, Tst, Tfin, Tsamp, startpt, endpt, sheared, m, alpha, beta)
if nargin < 8
   disp('The first 8 arguments are required:');
   help Cycloid
   return
end
drawmode = checkdrawmode(drawmode);
if nargin <= 8
   m=1;
end
if nargin <= 9	   % set the default values for alpha and beta 
%	alpha=-35.26;  % NUWAR configuration
%	beta=60;
	alpha=0;       % DELTA configuration
	beta=0;
end

% setting up the local ellipse axes & parameters
r = norm(endpt - startpt)/(2*pi);

% C - centre point of the ellipse
C = 1/2 * (endpt + startpt); 

% n1,n2,n3 are the unit vectors corresponding to the local coordinate system - xw,yw,zw
n1 = (endpt - startpt) / (2*pi*r);
n3 = cross(n1, [0;0;1]);
if sheared == 1
	n2 = [0;0;1];   
else
	n2 = cross(n3,n1);
end

% approximating the arc length of the ellipse
%d = pi*sqrt(0.5*(A^2 + B^2));
d = 1;

switch TimeRampType 
case 'SineonRamp', 
   [s, time] = SineonRamp(d, Tst, Tfin, m, Tsamp, 0);
case 'PolyTime', 
   [s, time] = PolyTime(d, Tst, Tfin, mean([Tst, Tfin]), Tsamp, 0); 
case 'LinearTime', 
   [s, time] = LinearTime(d, Tst, Tfin, Tsamp); 
otherwise,
   error('Please choose a valid Time Ramp function');
   return;
end

% setting up the matrix representing the local ellipse coordinate frame
T = [n1 n2 n3 startpt];
T(4,1:4) = [0 0 0 1];

timepos=time;
timetheta=time;

% Generate control points:
n = size(time,1);
for i = 1:n
   % find each point in the in local coords
	theta=2*pi*s(i)/d;
   xw=r*(theta-sin(theta));
	yw=r*(1-cos(theta));
   zw = 0;
   posw = [xw; yw; zw; 1];
   
   %transforming back to base coords
   posbase = T * posw;
   
   timetheta(i,2:4)=IK(posbase(1:3), 0, alpha, beta)';
   timepos(i,2:4)=posbase(1:3,1)';
end

% Show Trajectory
if drawmode(1)~=0
   InitBase(drawmode, alpha*pi/180, beta*pi/180);
   drawmode(3)= 0;  % we won't need to initialise the base again
   if drawmode(6)~=0 | nargout == 3
      M = moviein(2*n);
   end
   %draws the trajectory, then sets it so that it is not erased with 'cla'
   if drawmode(4) == 1
      axeshandles = findobj('Tag','GuiAxes1');
   else
      axeshandles = get(gcf,'children');
   end
   for plot=1:size(axeshandles,1)
      subplot(axeshandles(plot));
      h=plot3(timepos(:,2)',timepos(:,3)',timepos(:,4)','b-');
      set(h,'handlevisibility','off')
   end
   % Draw robot poses at each of the control points
   for i = 1:n
      IK(timepos(i,2:4)', drawmode, alpha, beta);
      drawnow;
      if drawmode(6)~=0 | nargout == 3
         M(:,i) = getframe;
      end
      if strcmp(get(gcf,'currentcharacter'),' ') == 1 %exit loop if space key is pressed
         break
      end	   
   end
   if strcmp(get(gcf,'currentcharacter'),' ') == 1 %exit loop if space key is pressed
    break
   end	   
   % Generate control points for backward path (just for demonstration):
   for i = 1:n
      % find each point in the in local coords
		theta=2*pi*(1-s(i)/d);
      xw=r*(theta-sin(theta));
		yw=r*(1-cos(theta));
      zw = 0;
      posw = [xw; yw; zw; 1];
      
      %transforming back to base coords
      posbase = T * posw;
      
      IK(posbase(1:3), drawmode, alpha, beta);
      drawnow;
      if drawmode(6)~=0 | nargout == 3
         M(:,i+n) = getframe;
      end
      if strcmp(get(gcf,'currentcharacter'),' ') == 1 %exit loop if space key is pressed
         break
      end	   
   end
end
