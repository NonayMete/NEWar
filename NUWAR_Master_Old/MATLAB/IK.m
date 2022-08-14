% function [theta] = IK(V);
% function [theta] = IK(V, drawmode);
% function [theta] = IK(V, drawmode, alpha, beta);
% function [theta] = IK(V, drawmode, alpha, beta, Ra, Rb, La, Lb);
% eg:       theta  = IK([0;0;-0.5],[3 0 1 0 1 0])
%
% - performs the inverse kinemtics for a desired gripper position for the NUWAR robot
%   and draws the corresponding pose of the robot if specified
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


function [theta] = IK(V, drawmode, alpha, beta, Ra, Rb, La, Lb);

if nargin == 0	%make sure that parameters have been supplied
   disp('Parameters are required:')
   help IK;
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
   alpha = -35.26;
   beta  = 60;
   %alpha = 0;
   %beta  = 0;
end
if nargin <= 4,	%initialise geometric parameters
   InitArms;
end

if size(V) == [1 3]  % ensures V is a column vector
   V=V';
end

% convert the angles specified in degrees into radians
alpha  = alpha  * pi/180;
beta   = beta   * pi/180;

%set up motor axes - the gripper offset is accounted for here
motor1 = dhtrans(0, 0, Ra-Rb, -pi/2) * roty(beta) * rotx(alpha);
motor2 = rotz(2*pi/3) * motor1;
motor3 = rotz(4*pi/3) * motor1;

% work out the position of the end of the foreams in motor coordinates
V(4)=1;
V1 = invht(motor1) * V;
V2 = invht(motor2) * V;
V3 = invht(motor3) * V;

% then need to work out the motor angles - some simple trigonometry.
% 'gamma','phi' and 'psi' are checked to make sure that they contain no imaginary parts,
% since asin(x/y) returns complex values if x/y > 1. Similary with acos(x/y).
% x/y > 1 indicates that the desired point is outside the worspace of the robot.
% NOTE:	this checking could be combined at the end, but has been done here in three parts to
%			provide feedback regarding which arm is insoluble.

gamma1 = asin(V1(3) / Lb);
%phi1 = atan2(V1(1) , V1(2));
phi1 = atan(V1(1) / V1(2));
psi1 = acos((La^2 + (V1(1)/sin(phi1))^2 - (Lb * cos(gamma1))^2) / (2 * La * (V1(1)/sin(phi1))));
theta1 = pi/2 - (phi1 + psi1);
if ~isreal([gamma1 psi1]) 
   error('point out of workspace - 1st arm');
end

%fprintf('gamma1 = %d\nphi1 = %d\npsi1 = %d\ntheta1 = %d\n', gamma1*180/pi, ...
%    phi1*180/pi, psi1*180/pi, theta1*180/pi);


gamma2 = asin(V2(3) / Lb);
%phi2 = atan2(V2(1) , V2(2));
phi2 = atan(V2(1) / V2(2));
psi2 = acos((La^2 + (V2(1)/sin(phi2))^2 - (Lb * cos(gamma2))^2) / (2 * La * (V2(1)/sin(phi2))));
theta2 = pi/2 - (phi2 + psi2);
if ~isreal([gamma2 psi2]) 
   error('point out of workspace - 1st arm'); 
end

gamma3 = asin(V3(3) / Lb);
%phi3 = atan2(V3(1) , V3(2));
phi3 = atan(V3(1) / V3(2));
psi3 = acos((La^2 + (V3(1)/sin(phi3))^2 - (Lb * cos(gamma3))^2) / (2 * La * (V3(1)/sin(phi3))));
theta3 = pi/2 - (phi3 + psi3);
if ~isreal([gamma3 psi3]) 
   error('point out of workspace - 1st arm');
end

theta = [theta1;theta2;theta3]* 180/pi;  %returns values to degrees for output

%******************************************************************************
%                              PLOTTING                                       *
%******************************************************************************

if drawmode(1) ~= 0	%ie, user wants to draw the robot
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
   
   % arm1-3 is a matrix representing a coordinate frame at the end of the ith control arm but offset by Rb.
   arm1 = motor1 * dhtrans(theta1, 0, La, 0);
	arm2 = motor2 * dhtrans(theta2, 0, La, 0);
	arm3 = motor3 * dhtrans(theta3, 0, La, 0);

	% work out actual position of forearms
	arm1p = cq1(1:3) + arm1(1:3,4);
	arm2p = cq2(1:3) + arm2(1:3,4);
	arm3p = cq3(1:3) + arm3(1:3,4);

	% Initialise gripper
	gr1 = V(1:3) + cq1(1:3);
	gr2 = V(1:3) + cq2(1:3);
	gr3 = V(1:3) + cq3(1:3);
   
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
      
      % EDITED BY CHRIS
      % Draw some co-ords
      % Origins:
      origin = [0; 0; 0; 1];
      o_M1 = motor1 * origin;
      o_M2 = motor2 * origin;
      o_M3 = motor3 * origin;
      % Points
      pointx = [1; 0; 0; 1];
      pointy = [0; 1; 0; 1];
      pointz = [0; 0; 1; 1];
      x_M1 = motor1 * pointx;
      y_M1 = motor1 * pointy;
      z_M1 = motor1 * pointz;
      
      x_M2 = motor2 * pointx;
      y_M2 = motor2 * pointy;
      z_M2 = motor2 * pointz;
      
      x_M3 = motor3 * pointx;
      y_M3 = motor3 * pointy;
      z_M3 = motor3 * pointz;
      
      plot3([o_M1(1) x_M1(1)], [x_M1(2) x_M1(2)], [x_M1(3) x_M1(3)], 'color', 'g');
      plot3([y_M1(1) y_M1(1)], [o_M1(2) y_M1(2)], [y_M1(2) y_M1(2)], 'color', 'r');
      plot3([z_M1(1) z_M1(1)], [z_M1(2) z_M1(2)], [o_M1(2) z_M1(2)], 'color', 'b');
      
      plot3([o_M2(1) x_M2(1)], [x_M2(2) x_M2(2)], [x_M2(3) x_M2(3)], 'color', 'g');
      plot3([y_M2(1) y_M2(1)], [o_M2(2) y_M2(2)], [y_M2(2) y_M2(2)], 'color', 'r');
      plot3([z_M2(1) z_M2(1)], [z_M2(2) z_M2(2)], [o_M2(2) z_M2(2)], 'color', 'b');
      
	  plot3([o_M3(1) x_M3(1)], [x_M3(2) x_M3(2)], [x_M3(3) x_M3(3)], 'color', 'g');
      plot3([y_M3(1) y_M3(1)], [o_M3(2) y_M3(2)], [y_M3(2) y_M3(2)], 'color', 'r');
      plot3([z_M3(1) z_M3(1)], [z_M3(2) z_M3(2)], [o_M3(2) z_M3(2)], 'color', 'b');
      
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
	
		else   %Draw cylinder representation
	
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

