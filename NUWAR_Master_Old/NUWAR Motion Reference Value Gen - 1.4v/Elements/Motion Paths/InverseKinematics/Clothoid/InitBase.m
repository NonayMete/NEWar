% function InitBase;
% function InitBase(drawmode);
% function InitBase(drawmode,alpha, beta);
% 
% eg: InitBase([3 0 1 0 1 0],-35.26*pi/180,60*pi/180)
%
% This function draws all the static parts of the robot in a mode that
% is not cleared when the 'cla' command is called.
%
% Note:
%       alpha and beta in radians.
%       Other defaults set by InitArms and checkdrawmode

function InitBase(drawmode,alpha, beta);

if nargin == 0
   disp('Warning: Initbase is being called without any paramters. - Default values may not apply');
   drawmode = checkdrawmode;
else
   drawmode = checkdrawmode(drawmode);
end

if nargin <= 2
   alpha = 0;
   beta = 0;
end

if max(size(drawmode)) < 3
   error('InitBase requires the first 3 parameters of drawmode to be specified at least.');
end
if drawmode(3) == 0
   error('InitBase should not have been called.');
end
if length(drawmode) == 3
   InitialiseDisplay;
elseif length(drawmode) == 4
   InitialiseDisplay(drawmode(4));  % drawmode(4) sets 'useGUI'.
else 
   InitialiseDisplay(drawmode(4),drawmode(5)) % drawmode(4) sets 'useGUI' and drawmode(5) sets 'numPlots'.
end

InitArms;

% calculate base triangle coordinates
Triangle1 = dhtrans(pi/3, 0, 2*(Ra-Rb), 0);
Triangle2 = rotz(2*pi/3) * Triangle1;
Triangle3 = rotz(4*pi/3) * Triangle1;
LINEMATRIX2 = [Triangle1(:,4), Triangle2(:,4), Triangle3(:,4), Triangle1(:,4)];

%set up motor axes - the gripper offset is accounted for here
motor1 = dhtrans(0, 0, Ra-Rb, -pi/2) * roty(beta) * rotx(alpha);
motor2 = rotz(2*pi/3) * motor1;
motor3 = rotz(4*pi/3) * motor1;
	   
% calculate constant offset vectors on gripper 
cq1 = rotz(-beta)*[Rb;0;0;1];
cq2 = rotz(-beta)*[-0.5*Rb;  sqrt(3)/2*Rb; 0; 1];
cq3 = rotz(-beta)*[-0.5*Rb; -sqrt(3)/2*Rb; 0; 1];
   
% calculating pseudo motor matrices which are coincident with the motors
Motor1T = trans(cq1(1),cq1(2),cq1(3))*motor1;
Motor2T = trans(cq2(1),cq2(2),cq2(3))*motor2;
Motor3T = trans(cq3(1),cq3(2),cq3(3))*motor3;
	   
% set length of motor shaft
Lmotor = 0.05;

if drawmode(4) == 1
   axeshandles = findobj('Tag','GuiAxes1');
else
   axeshandles = get(gcf,'children');
end

for plot=1:size(axeshandles,1)
   subplot(axeshandles(plot));
   
	% draw base triangle
	h = plot3(LINEMATRIX2(1,:), LINEMATRIX2(2,:), LINEMATRIX2(3,:), 'r-');
	set(h,'handlevisibility','off');
   
   % draw cq vectors
	h = plot3([motor1(1,4), Motor1T(1,4)], [motor1(2,4), Motor1T(2,4)], [motor1(3,4), Motor1T(3,4)], 'b-');
   set(h,'handlevisibility','off');
	h = plot3([motor2(1,4), Motor2T(1,4)], [motor2(2,4), Motor2T(2,4)], [motor2(3,4), Motor2T(3,4)], 'b-');
   set(h,'handlevisibility','off');
	h = plot3([motor3(1,4), Motor3T(1,4)], [motor3(2,4), Motor3T(2,4)], [motor3(3,4), Motor3T(3,4)], 'b-');
   set(h,'handlevisibility','off');
      
	
	if drawmode(2) == 1     % draw frames
   	% Initialise base frame and draw it
		frame0 = eye(4);
		plotframe(frame0, 'x0', 'y0', 'z0');
	   
	   % plot the motor axes
		plotframe(motor1, 'x1', 'y1', 'z1');
		plotframe(motor2, 'x2', 'y2', 'z2');
	   plotframe(motor3, 'x3', 'y3', 'z3');
	end
	
	if drawmode(1)==1	| drawmode(1)==2 % wire frame mode
      %draw line to represent motors
      [Xt, Yt, Zt] = transsurf(Motor1T, [0;0],[0;0],[-Lmotor;Lmotor]);
      h = plot3(Xt,Yt,Zt,'m');
	   set(h,'handlevisibility','off');
      [Xt, Yt, Zt] = transsurf(Motor2T, [0;0],[0;0],[-Lmotor;Lmotor]);
      h = plot3(Xt,Yt,Zt,'m');
	   set(h,'handlevisibility','off');
      [Xt, Yt, Zt] = transsurf(Motor3T, [0;0],[0;0],[-Lmotor;Lmotor]);
      h = plot3(Xt,Yt,Zt,'m');
	   set(h,'handlevisibility','off');
	end
   
   if drawmode(1)==3	% rendered cylinder mode
      % draw motors
	   [X,Y,Z] = zcylinder(0.075, 16, Lmotor, 4*Lmotor);
      
      % motor1
	   [Xt, Yt, Zt] = transsurf(Motor1T, X,Y,Z);
	   %h = patch(Xt, Yt, Zt,'g');
	   h = surf(Xt, Yt, Zt);
	   %set(h,'edgecolor','interp')
	   set(h,'handlevisibility','off');
	   for i=1:2
	      h = patch(Xt(i,:),Yt(i,:),Zt(i,:),'b');
		   set(h,'handlevisibility','off');
	   end
	   
      % motor2
	   [Xt, Yt, Zt] = transsurf(Motor2T, X,Y,Z);
	   h = surf(Xt, Yt, Zt);
		set(h,'handlevisibility','off');
	   for i=1:2
	      h = patch(Xt(i,:),Yt(i,:),Zt(i,:),'b');
		   set(h,'handlevisibility','off');
	   end
	   
      % motor3
	   [Xt, Yt, Zt] = transsurf(Motor3T, X,Y,Z);
	   h = surf(Xt, Yt, Zt);
		set(h,'handlevisibility','off');
	   for i=1:2
	      h = patch(Xt(i,:),Yt(i,:),Zt(i,:),'b');
		   set(h,'handlevisibility','off');
	   end
	   
	   % draw motor shafts
	   [X,Y,Z] = zcylinder(0.015, 16, -Lmotor, Lmotor);
	   [Xt, Yt, Zt] = transsurf(Motor1T, X,Y,Z);
	   h = surf(Xt, Yt, Zt);
		set(h,'handlevisibility','off');
	   [Xt, Yt, Zt] = transsurf(Motor2T, X,Y,Z);
	   h = surf(Xt, Yt, Zt);
		set(h,'handlevisibility','off');
	   [Xt, Yt, Zt] = transsurf(Motor3T, X,Y,Z);
	   h = surf(Xt, Yt, Zt);
		set(h,'handlevisibility','off');
   end
end
