% function [timetheta, M] = ShowTrajectory(drawmode, timepos, alpha, beta, interactive,...
%                                          UserPoints, rtpanInit, rtpanCycle)
%
% ShowTrajectory shows the trajectory defined by timepos.
% This function is called by all of the trajectory generation functions to show the trajectory.
% Multiple trajectory timepos matrices can be concatenated and then displayed as one animation,
% but each timepos matrix must be generated with the same sample period, Tsamp.
%
% Input parameters:
%      drawmode     please run 'help nomenclature' for a description.
%      timepos      is a matrix of time and position data
%                   Each row is in the form [t x(t) y(t) z(t)]
%      alpha        is the orientation of the motors in the 'alpha' direction, in degrees
%      beta         is the orientation of the motors in the 'beta' direction, in degrees
%      interactive  is a boolean value, to request the chance to modify the viewing angle
%                   using the 'rtpan' function before the motion simulation commences.
%                   Type 'help rtpan' for more details.
%      UserPoints   is a matrix of points defining the trajectory path
%                   it should be a 4xn matrix, each colunm of the form [x y z 1]'.  n>=3.
%      rtpanInit    is a command string to be sent to initialise rtpan.
%                   Use this string to set initial view and adjust the 'factor' variable.
%      rtpanCycle   is a command string to be sent to rtpan for every itteration.
%                   Use this string to rotate plots.
%
% Default Input values:  (unlisted parameters are required)
%      alpha        = -35.26
%      beta         = 60
%      interactive  = 0
%      Other defaults set by the functions InitArms and checkdrawmode
%
% Outputs:
%      timetheta    is a matrix of time and motor angle data
%                   Each row is in the form [t theta1(t) theta2(t) theta3(t)]
%      M            is a matlab movie matrix.
%
% Press the space bar to end the simulation at any time.
%
% eg:  [timetheta] = ShowTrajectory([3,0,1,0,1,0], timepos, [], [], 0, [], []);

% Author: Stephen LePage
% March 1999

function [timetheta, M] = ShowTrajectory(drawmode, timepos, alpha, beta, interactive, ...
   UserPoints, rtpanInit, rtpanCycle)

if nargin < 2
   disp('The first 2 arguments are required:');
   pause
   help ShowTrajectory
   return
end

% -------------
% Set Defaults:
% -------------

drawmode = checkdrawmode(drawmode);
if nargin < 3 | isempty(alpha)
   alpha=-35.26;  % NUWAR configuration
%	alpha=0;       % DELTA configuration
end
if nargin < 4 | isempty(beta)
   beta=60;       % NUWAR configuration
%	beta=0;        % DELTA configuration
end
if nargin < 5 | isempty(interactive)
   interactive = 0;
end
if nargin < 6 
   UserPoints = [];
end
if nargin < 7 
   rtpanInit=[];
end
if nargin < 8 
   rtpanCycle=[];
end

% ----------------
% Show Trajectory:
% ----------------

if drawmode(1)~=0
   numPathPoints=size(timepos,1);
   
   DeleteKey=char(127);
   EnterKey=char(13);
   BackspaceKey=char(8);
   
   if interactive
      disp(EnterKey);
      disp(['Use rtpan keyboard controls on the figure now to get the desired view angle' EnterKey ...
            'Press return on the figure when ready' EnterKey...
            'Press any key now to continue...'])
      disp(EnterKey);
      pause
   end
   
   InitBase(drawmode, alpha*pi/180, beta*pi/180);
   drawmode(3)= 0;  % we won't need to initialise the base again
   
   %draws the trajectory, then sets it so that it is not erased with 'cla'
   if drawmode(4) == 1
      axishandles = findobj('Tag','GuiAxes1');
   else
      axishandles = get(gcf,'children');
   end
   for h=axishandles'
      subplot(h);
      if nargin >= 6 & ~isempty(UserPoints)
         UserPointsHandel=plot3(UserPoints(1,:),UserPoints(2,:),UserPoints(3,:),'r-');
         set(UserPointsHandel,'handlevisibility','off')   % This is extra to ShowTrajectory.m
      end
      TrajectoryPointsHandel=plot3(timepos(:,2)',timepos(:,3)',timepos(:,4)','b.');
      set(TrajectoryPointsHandel,'handlevisibility','off')
   end
   if ~isempty(rtpanInit)
      rtpan(rtpanInit);
   end
   
   if interactive
      IK(timepos(1,2:4)', drawmode, alpha, beta);   %show initial position of manipulator
      drawnow;
      rtpan;
      i=0;
      while strcmp(EnterKey,get(gcf,'currentcharacter')) == 0
         i=i+1;
         %disp(['Pausing ' num2str(i) ' seconds, currentcharacter is: ' get(gcf,'currentcharacter')]); 
         %disp(['Please type the return key to continue']); 
         pause(1)
      end
   end
   
   if drawmode(6)~=0 & nargout == 2
      M = moviein(numPathPoints);
   end
   
   % Initialise output table
   timetheta(:,1)=timepos(:,1);
   
   QuitCharacters = sprintf(' %s',DeleteKey); % keys pressed which will end graphical simulation
      
   % Perform Inverse Kinematics with graphical simulation
   for i = 1:numPathPoints
      timetheta(i,2:4)=IK(timepos(i,2:4)', drawmode, alpha, beta)';
      if drawmode(1) ~= 0 
         if ~isempty(rtpanCycle)
            rtpan(rtpanCycle);
         end
         drawnow;
         if drawmode(6)~=0 & nargout == 2
            M(:,i) = getframe;
         end
         cc=get(gcf,'currentcharacter');
         if ~isempty(cc) & ~isempty(findstr(cc,QuitCharacters))
            drawmode = 0;
         end
      end	   
   end
end
