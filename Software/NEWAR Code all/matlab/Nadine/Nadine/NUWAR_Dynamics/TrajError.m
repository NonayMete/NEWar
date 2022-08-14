%function [poserror, thetaerror]=TrajError(trajectoryFun,TimeRampType,Tst, Tfin,...
%Tsamp,startpt, endpt, m, alpha, beta, interactive,a,b,plotmode);
%
%Example usage:
%[poserror, thetaerror]=TrajError('TrajEllipse','SineonRamp',0,5,0.05,[-0.3;0;-0.6],[0.3;0;-0.6],2,0,0,1,0,0,2);
%
%TrajError calculates the difference between the original trajectory used by the 
%Inverse Dynamics function, and the output trajectory from the Forward Dynamics function.
%TrajError can be used to assess the effect of the constraint stabilisation method on 
%the accuracy of the Forward Dynamics trajectory.
%
%
% Input Parameters:
%      trajectoryFun = the name of an m-file to use to generate the trajectory.%
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
%      a            = parameter associated with constraint stabilisation
%      b            = parameter associated with constraint stabilisation
%                     [Note: a and b are recommended to be in the range 1 to 20]
%      plotmode     = 0 means do not plot graphs of results
%                   = 1 means plot graphs of results for Inverse and Forward Dynamics
%                   = 2 means plot graph of Trajectory Error
%                   = 3 mean plot graphs of Inverse and Forward Dynamics and Trajectory Error
%     
% Default Input values:  (the trajectory function is required)
%
%     TrajectoryFun= (no default) TrajLinear, TrajEllipse, TranSinus etc
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
%     a            = 0
%     b            = 0
%     plotmode     = 0
%
%
% Output arguments:
%      poserror = difference between the travelling plate positions calculated by the
%                 original trajectory function and the Forward Dynamics function.
%      thetaerror = difference between the motor angles calculated by the original
%                   trajectory function and the Forward Dynamics function.
%
% Author: Nadine Frame 1999


function [poserror, thetaerror]=TrajError(trajectoryFun,TimeRampType,Tst, Tfin, Tsamp,startpt, endpt, m, alpha, beta, interactive,a,b,plotmode)

%Perform Inverse Dynamics for given trajectory:
[timeQ,timetheta,timepos]=IDTraj(trajectoryFun,[0 0 0 0 0 0],'',TimeRampType,Tst, Tfin, Tsamp,startpt, endpt, m, alpha, beta, interactive,plotmode);

%Initial position is obtained from the start-point of the trajectory:
V0=timepos(1,2:4);

%Perform Forward Dynamics for the calculated torque history and initial position:
[FDtimepos,FDtimetheta] = FDTraj(V0, timeQ, alpha,beta,a,b,plotmode);

%Calculate error in position and theta: 
poserror(:,1)=timepos(:,1);
thetaerror(:,1)=timepos(:,1);
poserror(:,2:4) = timepos(:,2:4)-FDtimepos(:,2:4);
thetaerror(:,2:4)=timetheta(:,2:4)-FDtimetheta(:,2:4);

%Note: all theta angles are in degrees

if plotmode >= 2
   %Plot Trajectory Error
   figure(5);
   subplot(2,1,1),plot(poserror(:,1),poserror(:,2),'r-',poserror(:,1),poserror(:,3),'b-',poserror(:,1),poserror(:,4),'g-');
   xlabel('Time [s]');
   ylabel('Position Error [m]');
   legend('X','Y','Z',0);
   title('FORWARD DYNAMICS TRAJECTORY ERROR');
   subplot(2,1,2),plot(thetaerror(:,1),thetaerror(:,2),'r-',thetaerror(:,1),thetaerror(:,3),'b-',thetaerror(:,1),thetaerror(:,4),'g-');
   xlabel('Time [s]');
   ylabel('Theta Error [degrees]');
   legend('Arm 1','Arm 2','Arm 3',0);
end


