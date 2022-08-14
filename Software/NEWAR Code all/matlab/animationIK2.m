% function [timetheta,timepos] = animationIK1;
% function [timetheta,timepos] = animationIK1(drawmode);
% function [timetheta,timepos] = animationIK1(drawmode, alpha, beta);
%
% - traces out a multidimentional sinusoidal curve in Cartesian (end-effector) space.
% - function loops forever or until execution is terminated, eg: via <ctrl c>.
%
% drawmode = [{0,1,2,3}, {0,1}, {0,1}, {0,1}, {1,2,4}, {0,1}]
% where param1 = 0 means don't plot
%              = 1 means plot wire frame
%              = 2 means plot wire frame with accurate representation of forearms
%              = 3 means plot cylinder representation
%       param2 = 1 means also plot reference frames
%       param3 = 1 means initialise the display
%       param4 = 1 means writing to GUI
%       param5 = number of plots generated (eg 2 for stereo)
%       param6 = 1 means create a movie for playback
%  NOTE: a movie cannot be created using this function
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

function [timetheta,timepos] = animationIK1(drawmode, alpha, beta);

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

% set-up the sinusoidal path for the end-effector
amp  = 0.2;
n = 64;
i = (0:n-1)/n*2*pi;
x = amp*sin(6*i);
y = amp*cos(6*i);
z = -0.6+0.02*cos(2*i);
V = [x;y;z];  % the set of control points in task space

if nargout >= 1 % calculate timetheta
   for i = 1:n
	   timetheta(i,1)=(i-1)/(n-1);  %generates artificial times from 0 to 1
      timetheta(i,2:4)=IK(V(:,i),0, alpha, beta)';
   end
end
if nargout == 2 %calculate timepos
   timepos=[timetheta(:,1) V'];
end

% Show Trajectory
if drawmode(1)~=0	  % only draw if specified by the user
   drawmode(3)= 1;  % ensure we initialise the base
	InitBase(drawmode, alpha*pi/180, beta*pi/180);
	drawmode(3)= 0;  % we won't need to initialise the base again

	if drawmode(5) == 1 %if only one plot is to be drawn, let's get a close-up!
		set(gca,'CameraViewAngle',30)
		set(gca,'Cameraposition',[-1 -1 1])
	end

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
		h=plot3([V(1,:) V(1,1)],[V(2,:) V(2,1)],[V(3,:) V(3,1)],'b-');
		set(h,'handlevisibility','off')
	end
	
	% perform the animation, drawing a pose of the robot for each of the control points
   
	while 1,
      for i = 1:n
	      IK(V(:,i),drawmode, alpha, beta);
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
