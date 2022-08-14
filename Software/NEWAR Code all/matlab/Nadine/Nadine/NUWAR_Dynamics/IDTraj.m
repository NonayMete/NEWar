%function[timeQ,timetheta,timepos,timelambda]=IDTraj(trajectoryFun,drawmode,filename,...
%TimeRampType,Tst, Tfin, Tsamp,startpt, endpt, m, alpha, beta, interactive,plotmode);
%
%Example usage:
%[timeQ]=IDTraj('TrajEllipse',[0 1 1 0 1 0],'','SineonRamp',0,1,0.005,[-0.3;0;-0.6],[0.3;0;-0.6],2,0,0,1,1);
%
% This function solves the inverse dynamics problem for a specified trajectory.
% The time history of travelling plate position and motor angles, and the corresponding
% time history of the required motor torques and Lagrange multipliers are returned
% as output.
%
%
% Input Parameters:
%      trajectoryFun = the name of an m-file to use to generate the trajectory.
%      drawmode = [{0,1,2}, {0,1}, {0,1}, {0,1}, {1,2,4}, {0,1}]
%      where:
%        param1 = 0 means don't plot
%               = 1 means plot wire frame
%               = 2 means plot wire frame with accurate representation of forearms
%               = 3 means plot cylinder representation
%        param2 = 1 means also plot reference frames
%        param3 = 1 means initialise the display
%        param4 = 1 means writing to GUI
%        param5 = number of plots generated (eg 2 for stereo)
%        param6 = 1 means create a movie for playback
%      filename     = the name of the file to export the data to (leave blank to ask for a filename)
%      TimeRampType = type of movement profile to use.
%                     choose 'LinearTime', 'ParabolicTime', 'SineonRamp' or 'PolyTime'.
%      Tst          = the starting time.
%      Tfin         = the finishing time.
%      Tsamp        = the sample period, in seconds
%      startpt      = the starting point for the trajectory - a vector in the format [x;y;z])
%      endpt        = the ending point for the trajectory - a vector in the format [x;y;z])
%      m            = the ratio between the maximum acceleration (Aa), and the maximum 
%                     deceleration (Ad). 
%                     Note:  m - only applies to 'SineonRamp' and 'ParabolicTime' time ramps.
%      alpha        = the orientation of the motors in the 'alpha' direction, in degrees
%      beta         = the orientation of the motors in the 'beta' direction, in degrees
%      interactive  = a boolean value, to request the chance to modify the viewing angle
%                     using the 'rtpan' function before the motion simulation commences.
%                     Type 'help rtpan' for more details.
%      plotmode     = 0 means do not plot graphs of results
%                   = 1 means plot graphs of results
%     
% Default Input values:  (the trajectory function is required)
%
%     TrajectoryFun= (no default) TrajLinear, TrajEllipse, TranSinus etc
%     drawmode     = set by the default in function checkdrawmode 
%     TimeRampType = LinearTime
%     Tst          = 0
%     Tfin         = 20
%     Tsamp        = (Tfin-Tst)/20
%     startpt      = [-0.3;0;-0.5]
%     endpt        = [0.3;0;-0.5]
%     m            = 1
%     alpha        = 0
%     beta         = 0
%     interactive  = 1
%     plotmode     = 0
%
%     Other defaults are set by the functions InitArms and checkdrawmode
%
% Press enter to run the simulations.
% Press the space bar to end the simulation at any time.
%
%
% Output arguments:
%      timeQ = time history of motor torques
%      timetheta = time history of control arm (motor) angles
%      timepos = time history of travelling plate position
%      timelambda = time history of Lagrange multipliers
%
% Author: Nadine Frame 1999


function[timeQ,timetheta,timepos,timelambda]=IDTraj(trajectoryFun,drawmode,filename,TimeRampType,Tst, Tfin, Tsamp,startpt, endpt, m, alpha, beta, interactive,plotmode);

%Set defaults
if nargin < 1 | isempty(trajectoryFun)
   error('Please specify a trajectory type.');
   return;
end   

% check the drawmode parameter
if nargin < 2 | isempty(drawmode)
   drawmode = checkdrawmode;
else
   drawmode = checkdrawmode(drawmode);
end

if nargin < 3 | isempty(filename)
   [filename, pathname] = uiputfile('*.txt', 'Export data as:');
   if ischar(filename)
      filename = strcat(pathname, filename);
   end
end

if nargin < 4 | isempty(TimeRampType)
   TimeRampType = 'LinearTime';
end

if nargin < 5 | isempty(Tst)
   Tst = 0;
end

if nargin < 6 | isempty(Tfin)
   Tfin = 20;
end

if nargin < 7 | isempty(Tsamp)
   Tsamp = (Tfin-Tst)/20;
end

if nargin < 8 | isempty(startpt)
   startpt = [-0.3;0;-0.5];
end

if nargin < 9 | isempty(endpt)
   endpt = [0.3;0;-0.5];
end

if nargin < 10 | isempty(m)
   m = 1;
end

if nargin < 11 | isempty(alpha)
%   alpha=-35.26;  % NUWAR configuration
	alpha = 0;       % DELTA configuration
end

if nargin < 12 | isempty(beta)
%   beta=60;       % NUWAR configuration
	beta = 0;        % DELTA configuration
end

if nargin < 13 | isempty(interactive)
   interactive = 1;
end

if nargin < 14 | isempty(plotmode)
   plotmode =0; %don't plot results
end

%Obtain trajectory data: travelling plate position and control arm angles
[timetheta,timepos]=Traj1999(trajectoryFun,drawmode,filename,TimeRampType,Tst, Tfin, Tsamp,startpt, endpt, m, alpha, beta, interactive);

tic; %used to check computation times

%Obtain velocities and accelerations:
[timed1V,timed2V]=diff5pt(timepos);
[timed1theta,timed2theta]=diff5pt(timetheta);
%timepos, timed1theta and timed2theta are in degrees. 
%Conversion to radians in performed in the ID1 or ID2 m-file.

%Set up time points:
timeQ(:,1)=timepos(:,1);
timelambda(:,1)=timepos(:,1);

%Perform Inverse Dynamics for each time point:
numpoints=size(timepos,1);
for i = 1:numpoints
   %Obtain input vectors for Inverse Dynamics function:
   V(1:3)=timepos(i,2:4);
   d1V(1:3)=timed1V(i,2:4);
   d2V(1:3)=timed2V(i,2:4);
   theta(1:3)=timetheta(i,2:4);
   d1theta(1:3)=timed1theta(i,2:4);
   d2theta(1:3)=timed2theta(i,2:4);
   %Inverse Dynamics Function:
   [Q,lambda]=ID2(V,d1V,d2V,theta,d1theta,d2theta,alpha, beta);
   %the Inverse Dynamics function used here can be changed between ID1 and ID2,
   %depending on which is preferred.
   %Create output vectors:
   timeQ(i,2:4)=[Q(1),Q(2),Q(3)];
   timelambda(i,2:4)=[lambda(1),lambda(2),lambda(3)];
end

toc %used to check computation times

%find rate of change of torque - used for trajectory analysis
%[timedQ]=diff5pt(timeQ);

%Plotting Results:
if plotmode ==1
   
   %Inverse Dynamics Input Plot:
   figure(2);
   
   %Convert angles back to radians for plotting
   timetheta(:,2:4)=timetheta(:,2:4)*pi/180;
   timed1theta(:,2:4)=timed1theta(:,2:4)*pi/180;
   timed2theta(:,2:4)=timed2theta(:,2:4)*pi/180;

   subplot(2,3,1),plot(timepos(:,1),timepos(:,2),'r-',timepos(:,1),timepos(:,3),'b-',timepos(:,1),timepos(:,4),'g-');
   xlabel('Time [s]');
   ylabel('Position [m]');
   subplot(2,3,2),plot(timed1V(:,1),timed1V(:,2),'r-',timed1V(:,1),timed1V(:,3),'b-',timed1V(:,1),timed1V(:,4),'g-');
   xlabel('Time [s]');
   ylabel('Velocity [m/s]');
   title('INVERSE DYNAMICS INPUT');
   subplot(2,3,3),plot(timed2V(:,1),timed2V(:,2),'r-',timed2V(:,1),timed2V(:,3),'b-',timed2V(:,1),timed2V(:,4),'g-');
   xlabel('Time [s]');
   ylabel('Acceleration [m/s^2]');
   legend('X','Y','Z',0);
   subplot(2,3,4),plot(timetheta(:,1),timetheta(:,2),'r-',timetheta(:,1),timetheta(:,3),'b-',timetheta(:,1),timetheta(:,4),'g-');
   xlabel('Time [s]');
   ylabel('Angle [rad]');
   subplot(2,3,5),plot(timed1theta(:,1),timed1theta(:,2),'r-',timed1theta(:,1),timed1theta(:,3),'b-',timed1theta(:,1),timed1theta(:,4),'g-');
   xlabel('Time [s]');
   ylabel('Velocity [rad/s]');
   subplot(2,3,6),plot(timed2theta(:,1),timed2theta(:,2),'r-',timed2theta(:,1),timed2theta(:,3),'b-',timed2theta(:,1),timed2theta(:,4),'g-');
   xlabel('Time [s]');
   ylabel('Acceleration [rad/s^2]');
   legend('Arm 1','Arm 2','Arm 3',0);
   
   %Inverse Dynamics Output Plot:
   figure(3);
   
   subplot(2,1,1),plot(timeQ(:,1),timeQ(:,2),'r-',timeQ(:,1),timeQ(:,3),'b-',timeQ(:,1),timeQ(:,4),'g-');
   title('INVERSE DYNAMICS OUTPUT');
   xlabel('Time [s]');
   ylabel('Torque [Nm]');
   legend('  Arm 1   ','  Arm 2   ','  Arm 3   ',-1);
   
   subplot(2,1,2),plot(timelambda(:,1),timelambda(:,2),'r-',timelambda(:,1),timelambda(:,3),'b-',timelambda(:,1),timelambda(:,4),'g-');
   xlabel('Time [s]');
   ylabel('Lagrange multipliers [N]');
   legend('Lambda 1','Lambda 2','Lambda 3',-1);
   
   %Convert angles back to degrees after plotting
   timetheta(:,2:4)=timetheta(:,2:4)*180/pi;
   timed1theta(:,2:4)=timed1theta(:,2:4)*180/pi;
   timed2theta(:,2:4)=timed2theta(:,2:4)*180/pi;

end
