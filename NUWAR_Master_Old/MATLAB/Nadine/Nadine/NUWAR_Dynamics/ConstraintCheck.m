% function [f]=ConstraintCheck(V,drawmode, alpha, beta, Ra, Rb, La, Lb);
%
% eg [f]=ConstraintCheck([0;0;-0.5],[0 0 0 0 0 0])
%
% This function checks the compatibility of the constraint equations and the Inverse 
% Kinematics function.
% This function returns the values of the three constraint functions (f1,f2,f3) for 
% a given travelling plate position, using the theta values returned by the IK function.
% If the constraint equations and the IK function are compatible, the values of 
% (f1,f2,f3) will be zero.
%
% Input Parameters:
%
%      V = position of the travelling plate (in base coordinates, in metres)
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
%      alpha = the orientation of the motors in the 'alpha' direction, in degrees
%      beta  = the orientation of the motors in the 'beta' direction, in degrees
%      Ra = distance from the centre of the base to the motors
%      Rb = distance from the centre of the travelling plate to the point of connection
%           between the travelling plate and forearm
%      La = length of the control arm
%      Lb = length of the forearm
%
% Default values:
%      V: is required
%      drawmode: set by the default in function checkdrawmode 
%      alpha and beta: alpha=beta=0, corresponding to Delta configuration
%      Ra, Rb, La, Lb: assigned by InitArms
%
% Author: Nadine Frame 1999

function [f]=ConstraintCheck(V,drawmode, alpha, beta, Ra, Rb, La, Lb);

% Set defaults
if nargin == 0	%make sure that parameters have been supplied
   disp('Parameters are required:')
   help ConstraintCheck;
   return
end

% check that 'drawmode' has been specified correctly or assign a default if
% it hasn't been supplied.
if nargin == 1	
   drawmode = checkdrawmode;
else
   drawmode = checkdrawmode(drawmode);
end

%set default values for unspecified parameters
if nargin <= 2,	%set the default values for alpha and beta - DELTA configuration
	%alpha = -35.26;
   %beta  = 60;
   alpha = 0;
   beta  = 0;
end

if nargin <= 4,	%initialise geometric parameters
   InitArms;
end

%Find theta values (motor angles) corresponding to plate position V.
[theta] = IK(V, drawmode, alpha, beta, Ra, Rb, La, Lb);

phi=[0;120;240]; %angles of the motor array

%convert angles in degrees to radians
theta=theta*pi/180;
phi=phi*pi/180;
alpha=alpha*pi/180;
beta=beta*pi/180;

R=Ra-Rb;

%constraint functions
f1 = -Lb^2+(La*sin(phi(1))*(cos(theta(1))*sin(beta)-cos(beta)*sin(alpha)*sin(theta(1)))+...
   cos(phi(1))*(R+La*cos(beta)*cos(theta(1))+La*sin(alpha)*sin(beta)*sin(theta(1)))-V(1))^2+...
   (cos(phi(1))*(-La*cos(theta(1))*sin(beta)+La*cos(beta)*sin(alpha)*sin(theta(1)))+...
   sin(phi(1))*(R+La*cos(beta)*cos(theta(1))+La*sin(alpha)*sin(beta)*sin(theta(1)))-V(2))^2+...
   (La*cos(alpha)*sin(theta(1))+V(3))^2;

f2 = -Lb^2+(La*sin(phi(2))*(cos(theta(2))*sin(beta)-cos(beta)*sin(alpha)*sin(theta(2)))+...
   cos(phi(2))*(R+La*cos(beta)*cos(theta(2))+La*sin(alpha)*sin(beta)*sin(theta(2)))-V(1))^2+...
   (cos(phi(2))*(-La*cos(theta(2))*sin(beta)+La*cos(beta)*sin(alpha)*sin(theta(2)))+...
   sin(phi(2))*(R+La*cos(beta)*cos(theta(2))+La*sin(alpha)*sin(beta)*sin(theta(2)))-V(2))^2+...
   (La*cos(alpha)*sin(theta(2))+V(3))^2;

f3 = -Lb^2+(La*sin(phi(3))*(cos(theta(3))*sin(beta)-cos(beta)*sin(alpha)*sin(theta(3)))+...
   cos(phi(3))*(R+La*cos(beta)*cos(theta(3))+La*sin(alpha)*sin(beta)*sin(theta(3)))-V(1))^2+...
   (cos(phi(3))*(-La*cos(theta(3))*sin(beta)+La*cos(beta)*sin(alpha)*sin(theta(3)))+...
   sin(phi(3))*(R+La*cos(beta)*cos(theta(3))+La*sin(alpha)*sin(beta)*sin(theta(3)))-V(2))^2+...
   (La*cos(alpha)*sin(theta(3))+V(3))^2;

%vector of constraint functions
f=[f1;f2;f3];