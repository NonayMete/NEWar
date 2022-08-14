% function [V] = FK(theta);
% function [V] = FK(theta, drawmode);
% function [V] = FK(theta, drawmode, alpha, beta);
% function [V] = FK(theta, drawmode, alpha, beta, Ra, Rb, La, Lb);
% eg:       V  = fk([-40;125;125],[3,0,1,0,1,0])
%
% - performs the forward kinematics corresponding to a set of motor angles 
%   for the NUWAR robot and draws the pose of the robot if specified
%
% where 
%       theta  = [theta1;theta2;theta3] - the actuated angles of each of the forearms
%       V      = the centre point of the gripper plate in base coordinates
%       alpha  = angle through which the motors are rotated in the 'alpha' direction
%       beta   = angle through which the motors are rotated in the 'alpha' direction
%       Ra     = distance from the centre of the base triangle to the motors when alpha and beta are zero
%       Rb     = distance from the centre of the gripper triangle to the juntion with the forearms
%       La     = length of the control arms
%       Lb     = length of the forearms (length of each of the parallel rods)
%
% drawmode = [{0,1,2}, {0,1}, {0,1}, {0,1}, {1,2,4}, {0,1}]
% where 
%       param1 = 0 means don't plot
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
%       alpha   = 0
%       beta    = 0
%       drawmode = (set by the default in function checkdrawmode)
% Note: 
%       All angles in degrees.
%       Other defaults set by InitArms and checkdrawmode

function [V] = FK(theta, drawmode, alpha, beta, Ra, Rb, La, Lb);

if nargin == 0	%make sure that parameters have been supplied
   disp('Parameters are required:')
   help fk;
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
if nargin <= 2, %set the default values for alpha and beta - DELTA configuration 
	%alpha = -35.26;
   %beta  = 60;
   alpha = 0;
   beta  = 0;
end
if nargin <= 4,	%initialise geometric parameters
   InitArms;
end

% set length of motor for cylinder rep
Lmotor = 0.05;

% convert the angles specified in degrees into radians
alpha  = alpha  * pi/180;
beta   = beta   * pi/180;
theta  = theta  * pi/180;

% set up the motor axes subtracting the offset vector at the gripper now.
motor1 = dhtrans(0, 0, Ra-Rb, -pi/2) * roty(beta) * rotx(alpha);
motor2 = rotz(2*pi/3) * motor1;
motor3 = rotz(4*pi/3) * motor1;

% arm1-3 is a matrix representing a coordinate frame at the end of the ith control arm but offset by Rb.
arm1 = motor1 * dhtrans(theta(1), 0, La, 0);
arm2 = motor2 * dhtrans(theta(2), 0, La, 0);
arm3 = motor3 * dhtrans(theta(3), 0, La, 0);

% extracting the positions of the ends of each of the control arms offset by Rb.
q1 = arm1(1:3,4);
q2 = arm2(1:3,4);
q3 = arm3(1:3,4);

% working out the equidistant centre (or circumcentre), 'U', of the triangle formed by the ends of the control arms
q12 = q2 - q1;
q13 = q3 - q1;

n = cross(q13, q12);
s13 = cross(n, q13);
m13 = (q1 + q3)/2;

t = (q2(1)^2 - q1(1)^2 + q2(2)^2 - q1(2)^2 + q2(3)^2 - q1(3)^2 - 2*(m13(1)*q12(1) + m13(2)*q12(2) + m13(3)*q12(3)) )/ ...
                                                                (2*(s13(1)*q12(1) + s13(2)*q12(2) + s13(3)*q12(3)) );
                                                             
U = m13 + t*s13;

% working out the position of the middle of the end effector, 'V', choosing the solution that is below
% (in the z-direction) 'U'. 
UV = sqrt(Lb^2 - ( (q2(1)-U(1))^2 + (q2(2)-U(2))^2 + (q2(3)-U(3))^2 ));

% is there is no solution, ie if 'qU' is greater than 'Lb' then exit
if ~isreal(UV),
   error('motor angles are out side the workspace of the robot');
end

V = U + (UV/norm(n))*n;


%******************************************************************************
%                              PLOTTING                                       *
%******************************************************************************

if drawmode(1) ~= 0
	if drawmode(3) == 1
      InitBase(drawmode,alpha,beta);
	end
   
   % calculate constant offset vectors on gripper 
	cq1 = rotz(-beta)*[Rb;0;0;1];
	cq2 = rotz(-beta)*[-0.5*Rb;  sqrt(3)/2*Rb; 0; 1];
	cq3 = rotz(-beta)*[-0.5*Rb; -sqrt(3)/2*Rb; 0; 1];

	% calculating pseudo motor matrices which are coincident with the motors
	Motor1T = trans(cq1(1),cq1(2),cq1(3))*motor1;
	Motor2T = trans(cq2(1),cq2(2),cq2(3))*motor2;
	Motor3T = trans(cq3(1),cq3(2),cq3(3))*motor3;
   
	% work out actual position of forearms
	arm1p = q1 + cq1(1:3);
	arm2p = q2 + cq2(1:3);
	arm3p = q3 + cq3(1:3);

	% Initialise gripper
	gr1 = V + cq1(1:3);
	gr2 = V + cq2(1:3);
	gr3 = V + cq3(1:3);
	   
   if drawmode(1) >= 2 %ie: if we are drawing accurate forarms, calc. the extra points
      % calculating the offset vector - vector between the parallel rods of the forearms.
      offset1 = ForearmOffset * motor1(1:3,3);
      offset2 = ForearmOffset * motor2(1:3,3);
		offset3 = ForearmOffset * motor3(1:3,3);
      
      % working out the positions of the ends of the rods near at the gripper plate
      gr1a = gr1 + offset1;
		gr1b = gr1 - offset1;
      gr2a = gr2 + offset2;
		gr2b = gr2 - offset2;
      gr3a = gr3 + offset3;
		gr3b = gr3 - offset3;
      
      % working out the positions of the ends of the rods at the connection with the control arms
		arm1ap = arm1p + offset1;
		arm1bp = arm1p - offset1;
		arm2ap = arm2p + offset2;
		arm2bp = arm2p - offset2;
		arm3ap = arm3p + offset3;
      arm3bp = arm3p - offset3;
   end
   
  if drawmode(4) == 1
   	axeshandles = findobj('Tag','GuiAxes1');
  else
   	axeshandles = get(gcf,'children');
  end
   
   for plot=1:size(axeshandles,1)
	   subplot(axeshandles(plot));
		cla;
		% Draw gripper
      plot3([gr1(1),gr2(1),gr3(1),gr1(1)], [gr1(2),gr2(2),gr3(2),gr1(2)], [gr1(3),gr2(3),gr3(3),gr1(3)], 'r-');

      if drawmode(1) == 1 | drawmode(1) == 2  %ie: if we are drawing a WIRE frame
		   % draw upper/control arms
			plot3([Motor1T(1,4), arm1p(1)], [Motor1T(2,4), arm1p(2)], [Motor1T(3,4), arm1p(3)], 'k-');
			plot3([Motor2T(1,4), arm2p(1)], [Motor2T(2,4), arm2p(2)], [Motor2T(3,4), arm2p(3)], 'k-');
			plot3([Motor3T(1,4), arm3p(1)], [Motor3T(2,4), arm3p(2)], [Motor3T(3,4), arm3p(3)], 'k-');
      
	      % draw forearms
	      if drawmode(1) == 1
	         %title('Simple wire-frame representation of robot');
				plot3([gr1(1), arm1p(1)], [gr1(2), arm1p(2)], [gr1(3), arm1p(3)], 'k-');
				plot3([gr2(1), arm2p(1)], [gr2(2), arm2p(2)], [gr2(3), arm2p(3)], 'k-');
				plot3([gr3(1), arm3p(1)], [gr3(2), arm3p(2)], [gr3(3), arm3p(3)], 'k-');
	      else
	         %title('Accurate wire-frame representation of robot');
	         LINEMATRIX = [arm1ap,arm1bp,gr1b,gr1a,arm1ap];
		      plot3(LINEMATRIX(1,:), LINEMATRIX(2,:), LINEMATRIX(3,:), 'k-');
	         LINEMATRIX = [arm2ap,arm2bp,gr2b,gr2a,arm2ap];
		      plot3(LINEMATRIX(1,:), LINEMATRIX(2,:), LINEMATRIX(3,:), 'k-');
	         LINEMATRIX = [arm3ap,arm3bp,gr3b,gr3a,arm3ap];
		      plot3(LINEMATRIX(1,:), LINEMATRIX(2,:), LINEMATRIX(3,:), 'k-');
	   	end

		else
			%title('Rendered cylinder representation of robot');
			n = 6;	%the number of sides of each cylinder
	      
	      % calculating pseudo arm matrices which are alligned with the actual positions of the control arms
	      Arm1T = trans(cq1(1),cq1(2),cq1(3))*arm1;
	      Arm2T = trans(cq2(1),cq2(2),cq2(3))*arm2;
	      Arm3T = trans(cq3(1),cq3(2),cq3(3))*arm3;
      
	      % draw control arms
	      [X,Y,Z] = xcylinder(0.015, n, -La, 0);
			[Xt, Yt, Zt] = transsurf(Arm1T, X,Y,Z);
			surf(Xt, Yt, Zt);
			[Xt, Yt, Zt] = transsurf(Arm2T, X,Y,Z);
			surf(Xt, Yt, Zt);
			[Xt, Yt, Zt] = transsurf(Arm3T, X,Y,Z);
			surf(Xt, Yt, Zt);
      
	      % draw elbow links
	      [X,Y,Z] = zcylinder(0.005, n, -ForearmOffset, ForearmOffset);
			[Xt, Yt, Zt] = transsurf(Arm1T, X,Y,Z);
			surf(Xt, Yt, Zt);
	      [Xt, Yt, Zt] = transsurf(Arm2T, X,Y,Z);
			surf(Xt, Yt, Zt);
	      [Xt, Yt, Zt] = transsurf(Arm3T, X,Y,Z);
	      surf(Xt, Yt, Zt);
      
	      %draw wrist - 1
	      Wrist1T = trans(gr1a(1)-arm1ap(1),gr1a(2)-arm1ap(2),gr1a(3)-arm1ap(3))*Arm1T;
			[Xt, Yt, Zt] = transsurf(Wrist1T, X,Y,Z);
	      surf(Xt, Yt, Zt);
	      
	      %draw wrist - 2
	      Wrist2T = trans(gr2a(1)-arm2ap(1),gr2a(2)-arm2ap(2),gr2a(3)-arm2ap(3))*Arm2T;
			[Xt, Yt, Zt] = transsurf(Wrist2T, X,Y,Z);
	      surf(Xt, Yt, Zt);
	      
	      %draw wrist - 3
	      Wrist3T = trans(gr3a(1)-arm3ap(1),gr3a(2)-arm3ap(2),gr3a(3)-arm3ap(3))*Arm3T;
			[Xt, Yt, Zt] = transsurf(Wrist3T, X,Y,Z);
	      surf(Xt, Yt, Zt);
		      
	      % Forearms - 1
	      Xdir=(gr1a-arm1ap)/norm(gr1a-arm1ap);
	      Ydir = cross(Xdir, motor1(1:3,3));
	      Zdir = cross(Xdir, Ydir);
	      Forarm1aT=[Xdir Ydir Zdir arm1ap];
	      Forarm1aT(4,1:4) = [0 0 0 1];
	      [X,Y,Z] = xcylinder(0.005, n, 0, Lb);
			[Xt, Yt, Zt] = transsurf(Forarm1aT, X,Y,Z);
	      surf(Xt, Yt, Zt);
	      
	      Forarm1bT = trans(arm1bp(1)-arm1ap(1),arm1bp(2)-arm1ap(2),arm1bp(3)-arm1ap(3))*Forarm1aT;
			[Xt, Yt, Zt] = transsurf(Forarm1bT, X,Y,Z);
	      surf(Xt, Yt, Zt);
	
	      % Forearms - 2
	      Xdir=(gr2a-arm2ap)/norm(gr2a-arm2ap);
	      Ydir = cross(Xdir, motor2(1:3,3));
	      Zdir = cross(Xdir, Ydir);
	      Forarm2aT=[Xdir Ydir Zdir arm2ap];
	      Forarm2aT(4,1:4) = [0 0 0 1];
	      [X,Y,Z] = xcylinder(0.005, n, 0, Lb);
			[Xt, Yt, Zt] = transsurf(Forarm2aT, X,Y,Z);
	      surf(Xt, Yt, Zt);
	      
	      Forarm2bT = trans(arm2bp(1)-arm2ap(1),arm2bp(2)-arm2ap(2),arm2bp(3)-arm2ap(3))*Forarm2aT;
			[Xt, Yt, Zt] = transsurf(Forarm2bT, X,Y,Z);
	      surf(Xt, Yt, Zt);
	
	      % Forearms - 3
	      Xdir=(gr3a-arm3ap)/norm(gr3a-arm3ap);
	      Ydir = cross(Xdir, motor3(1:3,3));
	      Zdir = cross(Xdir, Ydir);
	      Forarm3aT=[Xdir Ydir Zdir arm3ap];
	      Forarm3aT(4,1:4) = [0 0 0 1];
	      [X,Y,Z] = xcylinder(0.005, n, 0, Lb);
			[Xt, Yt, Zt] = transsurf(Forarm3aT, X,Y,Z);
	      surf(Xt, Yt, Zt);
	      
	      Forarm3bT = trans(arm3bp(1)-arm3ap(1),arm3bp(2)-arm3ap(2),arm3bp(3)-arm3ap(3))*Forarm3aT;
			[Xt, Yt, Zt] = transsurf(Forarm3bT, X,Y,Z);
	      surf(Xt, Yt, Zt);
      end
   end
	figure(gcf);
end


