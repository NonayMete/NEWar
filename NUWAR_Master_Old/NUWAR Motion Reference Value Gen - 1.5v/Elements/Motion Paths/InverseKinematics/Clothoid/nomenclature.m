% --------------------------------------------------------------------------------------------
% drawmode = [{0,1,2,3}, {0,1}, {0,1}, {0,1}, {1,2,4}, {0,1}]
%
% where:
% param1 = 0 means don't plot
%        = 1 means plot wire frame
%        = 2 means plot wire frame with accurate representation of forearms
%        = 3 means plot cylinder representation
% param2 = 1 means also plot reference frames
% param3 = 1 means initialise the display
% param4 = 1 means writing to GUI
% param5 = the number of plots generated (1 for single, 2 for stereo, 4 for top,front,right,3D)
% param6 = 1 means create a movie for playback
%          NOTE: a movie cannot be created for multiple plots
%
% The defaults for this parameter is set by the function CheckDrawMode.m
% --------------------------------------------------------------------------------------------
% The following are the configurable GEOMETRIC parameters of the robot:
%
% Ra            - the distance from the centre of the base triangle to the motors, 
%                 when alpha and beta are zero.
% Rb            - the distance from the centre of the gripper triangle to the juntion 
%                 with the forearms.
% La            - the length of the control arms.
% Lb            - the length of the forearms (length of each of the parallel rods).
% ForearmOffset - half the displacement between the forearm rods.
%
% The defaults for these parameters are set by the funciton InitArms.m
% --------------------------------------------------------------------------------------------
% The following are the parameter used by MOVEMENT PROFILE functions.
%
% Input parameters:
%      d            is the total distance to travell
%      Tst          is the starting time.
%      Tfin         is the finishing time.
%      m            is the ratio between the maximum acceleration (Aa), and the maximum 
%                   deceleration (Ad). 
%                   Note:  m - only applies to 'SineonRamp' and 'ParabolicTime' time ramps.
%      Tsamp        is the sample period, in seconds
%      show         = 1 means calculate and plot distance, velocity and tangential  
%                   acceleration and tangential jerk graphs.
%                   Note:- This option must be set to 1 in order to export v, At, and Jt
% Outputs:
%      time         an array of times, from Tst to Tfin step Tsamp
%      s            an array of corresponding positions
%      v            an array of corresponding velocities
%      At           an array of corresponding tangential accelerations
%      Jt           an array of corresponding tangential jerks
% --------------------------------------------------------------------------------------------
% The following are the parameter used by TRAGECTORY GENERATION functions.
%
% Input parameters:
%      drawmode     please run 'help nomenclature' for a description.
%      TimeRampType is the type of movement profile to use.
%                   choose 'LinearTime', 'ParabolicTime', 'SineonRamp' or 'PolyTime'.
%      Tst          is the starting time.
%      Tfin         is the finishing time.
%      Tsamp        is the sample period, in seconds
%      UserPoints   is a matrix of points defining the trajectory path
%                   it should be a 4xn matrix, each colunm of the form [x y z 1]'.  n>=3.
%      SummitType   Choose 's' for symmetrical summit, 'a' for asymmetrical summit
%      dfactor - a 2 by 1 array:      
%           dfactor(1) is the fraction of the available 'd' length to be used. (for scaling)
%           dfactor(2) is the user-specified limit to the D-ratio (ie: a limit to asymmetry)
%           where       0 < dfactor(1) <= 1    and    1 <= dfactor(2) <= 2
%      m            is the ratio between the maximum acceleration (Aa), and the maximum 
%                   deceleration (Ad). 
%                   Note:  m - only applies to 'SineonRamp' and 'ParabolicTime' time ramps.
%      alpha        is the orientation of the motors in the 'alpha' direction, in degrees
%      beta         is the orientation of the motors in the 'beta' direction, in degrees
%      interactive  is a boolean value, to request the chance to modify the viewing angle
%                   using the 'rtpan' function before the motion simulation commences.
%                   Type 'help rtpan' for more details.
% Outputs:
%      timepos      is a matrix of time and position data
%                   Each row is in the form [t x(t) y(t) z(t)]
%      timetheta    is a matrix of time and motor angle data
%                   Each row is in the form [t theta1(t) theta2(t) theta3(t)]
%      M            is a matlab movie matrix.
% --------------------------------------------------------------------------------------------
