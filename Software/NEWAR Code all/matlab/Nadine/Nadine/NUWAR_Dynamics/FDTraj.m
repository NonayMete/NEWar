%function [timepos,timetheta,dpos,dtheta] = FDTraj(V0, timeQ, alpha,beta,a,b,plotmode,drawmode,interactive);
%
%FDTraj is the Forward Dynamics function.
%FDTraj calculates the trajectory that results from a given inital position and torque
%time history.
%A three-dimensional simulation of the trajectory can be viewed by using the 'drawmode'
%parameter.
%FDTraj uses the FD function to solve the ODEs.
%FDTraj also incorporates the Baumgarte method of constraint stabilisation.
%
%Example usage:
%[timepos,timetheta] = FDTraj([-0.3,0,-0.6], timeQ, 0,0,0,0,0);
%
% Input Parameters:
%      V0       = the starting point for the trajectory - a vector in the format [x;y;z])
%      timeQ    = the time history of motor torques (in the same format as that produces
%                 by the 'IDTraj' function for compatibility)
%      alpha    = the orientation of the motors in the 'alpha' direction, in degrees
%      beta     = the orientation of the motors in the 'beta' direction, in degrees
%      a        = parameter associated with constraint stabilisation
%      b        = parameter associated with constraint stabilisation
%                 [Note: a and b are recommended to be in the range 1 to 20]
%      plotmode = 0 means do not plot graphs of results
%               = 1 means plot graphs of results
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
%      interactive  = a boolean value, to request the chance to modify the viewing angle
%                     using the 'rtpan' function before the motion simulation commences.
%                     Type 'help rtpan' for more details.
%     
% Default Input values:  (the initial position and torque history are required)
%
%     alpha        = 0
%     beta         = 0
%     a            = 0
%     b            = 0
%     plotmode     = 0
%     drawmode     = [0 0 0 0 0 0] (don't plot)
%     interactive  = 1
%
%
% Press enter to run the simulations.
% Press the space bar to end the simulation at any time.
%
%
% Output arguments:
%      timepos = time history of travelling plate position
%      timetheta = time history of control arm (motor) angles
%      dpos = time history of travelling plate velocity
%      dtheta = time history of motor angle velocity
%
% Author: Nadine Frame 1999


function [timepos,timetheta,dpos,dtheta] = FDTraj(V0, timeQ, alpha,beta,a,b,plotmode,drawmode,interactive);

%Set defaults
if nargin < 2   
   disp('Insufficient parameters.')
   help FDTraj;
   return
end

if nargin <= 2,	%set the default values for alpha and beta - DELTA configuration
	%alpha = -35.26;
   %beta  = 60;
   alpha = 0;
   beta  = 0;
end

if nargin <=4, %set the default values for the constraint stabilisation parameters
   a=0;
   b=0;
end

if nargin < 7 | isempty(plotmode)
   plotmode = 0;  %don't plot results
end

% check the drawmode parameter
if nargin < 8 | isempty(drawmode)
   drawmode = [0 0 0 0 0 0];
else
   drawmode = checkdrawmode(drawmode);
end

if nargin < 9 | isempty(interactive)
   interactive = 1;
end

tic; %used to find calculation time for Forward Dynamics function

phi=[0;120;240]; %angles of the motor array

%find inital values of theta
[theta0]=IK(V0, [0 0 0 0 0 0],alpha,beta);

%convert angles from degrees to radians
theta0=theta0*pi/180;
alpha=alpha*pi/180;
beta=beta*pi/180;
phi=phi*pi/180;

%assign global variables for use in the Forward Dynamics ODE file 'FD'
global alpha beta phi a b timeQ

%assume inital velocities and accelerations are zero.
d1V0=[0,0,0];
d2V0=[0,0,0];
d1theta0=[0,0,0];
d2theta0=[0,0,0];

%initial value vector
Y0=[V0(1);V0(2);V0(3);theta0(1);theta0(2);theta0(3);d1V0(1);d1V0(2);d1V0(3);d1theta0(1);d1theta0(2);d1theta0(3)];

%numerical integration of ODE eqns
%T is the vector of time points
%Y is the vector of dependent coordinates and dependent coordinate velocities
[T,Y]=ode45('FD',timeQ(:,1),Y0);

%trajectory output
timepos(:,1)=T;
timepos(:,2:4)=Y(:,1:3);
timetheta(:,1)=T;
timetheta(:,2:4)=Y(:,4:6)*180/pi; %convert back to degrees
dpos(:,1)=T;
dpos(:,2:4)=Y(:,7:9);
dtheta(:,1)=T;
dtheta(:,2:4)=Y(:,10:12)*180/pi;%convert back to degrees

% ----------------------------
% Show Forward Dynamics Plots:
% ----------------------------
if plotmode ==1
   
%travelling plate and control arm accelerations
[d2pos]=diff5pt(dpos);
[d2theta]=diff5pt(dtheta);

%plot position, velocity and acceleration time histories
figure(4);

%for travelling plate plots: 
%	x component: red line
%	y component: blue line
%	z component: green line

subplot(2,3,1),plot(timepos(:,1),timepos(:,2),'r-',timepos(:,1),timepos(:,3),'b-',timepos(:,1),timepos(:,4),'g-');
xlabel('Time [s]');
ylabel('Position [m]');
subplot(2,3,2),plot(dpos(:,1),dpos(:,2),'r-',dpos(:,1),dpos(:,3),'b-',dpos(:,1),dpos(:,4),'g-');
xlabel('Time [s]');
ylabel('Velocity [m/s]');
title('FORWARD DYNAMICS OUTPUT');
subplot(2,3,3),plot(d2pos(:,1),d2pos(:,2),'r-',d2pos(:,1),d2pos(:,3),'b-',d2pos(:,1),d2pos(:,4),'g-');
xlabel('Time [s]');
ylabel('Acceleration [m/s^2]');
legend('X','Y','Z',0);

%for control arm angle plots:
%	control arm 1: red line
%	control arm 2: blue line
%	control arm 3: green line

%Convert angles back to radians for plotting
timetheta(:,2:4)=timetheta(:,2:4)*pi/180;
dtheta(:,2:4)=dtheta(:,2:4)*pi/180;
d2theta(:,2:4)=d2theta(:,2:4)*pi/180;

subplot(2,3,4),plot(timetheta(:,1),timetheta(:,2),'r-',timetheta(:,1),timetheta(:,3),'b-',timetheta(:,1),timetheta(:,4),'g-');
xlabel('Time [s]');
ylabel('Angle [rad]');
subplot(2,3,5),plot(dtheta(:,1),dtheta(:,2),'r-',dtheta(:,1),dtheta(:,3),'b-',dtheta(:,1),dtheta(:,4),'g-');
xlabel('Time [s]');
ylabel('Velocity [rad/s]');
subplot(2,3,6),plot(d2theta(:,1),d2theta(:,2),'r-',d2theta(:,1),d2theta(:,3),'b-',d2theta(:,1),d2theta(:,4),'g-');
xlabel('Time [s]');
ylabel('Acceleration [rad/s^2]');
legend('Arm 1','Arm 2','Arm 3',0);

%Convert angles back to degrees after plotting
timetheta(:,2:4)=timetheta(:,2:4)*180/pi;
dtheta(:,2:4)=dtheta(:,2:4)*180/pi;
d2theta(:,2:4)=d2theta(:,2:4)*180/pi;

end

toc %outputs the calculation time

% ---------------------------
% Show Simulation Trajectory:
% ---------------------------
if drawmode(1) ~= 0
   %convert alpha and beta back to degrees: 
   %(ShowTrajectory requires them in degrees)
   alpha = alpha*180/pi
   beta = beta*180/pi
   if drawmode(6) == 1
      [timetheta, M] = ShowTrajectory(drawmode, timepos, alpha, beta, interactive);
   else
      [timetheta] = ShowTrajectory(drawmode, timepos, alpha, beta, interactive);
   end

% Check for out-of-range angles
if ~isempty(find(timetheta(:,2:4) < -30)) | ~isempty(find(timetheta(:,2:4) > 90))
   warndlg('Angles out of range for a trajectory (must be between -30 and 90', 'Error');
   error('Angles out of range for a trajectory.');
   return;
end
end 

clear global
