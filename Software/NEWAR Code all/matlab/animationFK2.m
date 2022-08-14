% function [timetheta,timepos] = animationFK2;
% function [timetheta,timepos] = animationFK2(drawmode);
% function [timetheta,timepos] = animationFK2(drawmode, alpha, beta);
%
% eg:      [timetheta,timepos] = animationFK2([3 0 1 0 4 0]);
%          [timetheta,timepos] = animationFK2([3 0 1 0 4 0],0,0);
%          [timetheta,timepos] = animationFK2([3 0 1 0 1 0]);
%
% - traces out a multidimentional sinusoidal curve in actuator (motor angle) space.
% - function loops forever or until execution is terminated via the space key
% - press return to close the figure window after finished
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
% NOTE: a movie cannot be created using this function
%
% Default values:
%       drawmode = (set by default in function checkdrawmode)
%       alpha    = 0
%       beta     = 0
% Note: 
%       All angles in degrees.
%       Other defaults set by InitArms  

% Authors: Josh Male and Stephen LePage
% November 1998

function [timetheta,timepos] = animationFK2(drawmode, alpha, beta);

% check the drawmode parameter 
if nargin == 0
   drawmode = checkdrawmode;
else
   drawmode = checkdrawmode(drawmode);
end

if nargin <= 1;	%set the default values for alpha and beta
	alpha = -35.26;     % NUWAR configuration
	beta = 60;
%	alpha = 0;          % DELTA configuration
%	beta = 0;
end

% set-up the sinusoidal path in joint space
n = 64; % number of points generated
mean = 30; %degrees
amp  = 80;
i = (1:n)/n*2*pi;
theta1 = mean + amp*sin(i);
theta2 = mean + amp*sin(i+120*pi/180);
theta3 = mean + amp*sin(i+240*pi/180);
theta = [theta1' theta2' theta3'];

% calculate timepos.  Position is used to plot the trajectory.
for i = 1:n
   timepos(i,1)=(i-1)/n;  %generates artificial times from 0 to 1
   timepos(i,2:4)=FK(theta(i,:)', 0, alpha, beta)'; % calculate only, so put 0 for 'drawmode' 
end
if nargin >= 2 
   timetheta = [timepos(:,1) theta];
end

% Show Trajectory
if drawmode(1)~=0	  % only draw if specified by the user
   drawmode(3) = 1;	% ensure we initialise the base
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
   V = timepos(:,2:4)';
   for plot=1:size(axeshandles,1)
	   subplot(axeshandles(plot));
		h=plot3([V(1,:) V(1,1)],[V(2,:) V(2,1)],[V(3,:) V(3,1)],'b-');
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
            break
         end	   
      end
      if strcmp(get(gcf,'currentcharacter'),' ') == 1 %exit loop if space key is pressed
         break
      end	   
   end
end
