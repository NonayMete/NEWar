%function [timetheta, timepos, M] = Clothoid(drawmode, TimeRampType, Tst, Tfin, Tsamp, ...
%                                UserPoints, SummitType, dfactor, m, alpha, beta, interactive)
%
% Clothoid generates a point-to-point trajectory based on straight line segments, 
% blended with symmetric or asymmetric summit clothoids.
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
%
% Default Input values:  (unlisted parameters are required)
%      SummitType   = 's'
%      dractor      = [1 2]
%      m            = 1
%      alpha        = -35.26
%      beta         = 60
%      interactive  = 0
%      Other defaults set by the functions InitArms and checkdrawmode
%
% Outputs:
%      timepos      is a matrix of time and position data
%                   Each row is in the form [t x(t) y(t) z(t)]
%      timetheta    is a matrix of time and motor angle data
%                   Each row is in the form [t theta1(t) theta2(t) theta3(t)]
%      M            is a matlab movie matrix.
%
% Press the space bar to end the simulation at any time.
%
% example sets of User points:
%      UserPoints = [[-0.4 0 -0.8 1]' [-0.3 0 -0.5 1]' [0.3 0 -0.5 1]' [0.4 0 -0.8 1]']
%      UserPoints = [[0.2 -0.3 -0.7 1]' [0.2 -0.3 -0.5 1]' [-0.2 0.3 -0.5 1]' [-0.2 0.3 -0.7 1]']
%
% eg: 
%[timetheta, timepos] = Clothoid([3,0,1,0,1,0],'SineonRamp',0,1,0.05,UserPoints,'a',[1 1.2], 1.5, -35.26, 60, 0);

% Author: Stephen LePage
% March 1999

function [timetheta, timepos, M] = Clothoid(drawmode, TimeRampType, Tst, Tfin, Tsamp, ...
   UserPoints, SummitType, dfactor, m, alpha, beta, interactive)

if nargin < 6
   disp('The first 6 arguments are required:');
   pause
   help Clothoid
   return
end
numUserPoints = size(UserPoints,2);
if size(UserPoints,1)~=4 | numUserPoints<3
   disp('Invalid userpoints matrix:');
   help Clothoid
   return
end

% -------------
% Set Defaults:
% -------------

drawmode = checkdrawmode(drawmode);
if nargin < 7 | isempty(SummitType)
   SummitType = 's';
end
if nargin < 8 | isempty(dfactor)
   dfactor=[1 2];
end
if nargin < 9 | isempty(m)
   m=1;
end
if nargin < 10 | isempty(alpha)
   alpha=-35.26;  % NUWAR configuration
%	alpha=0;       % DELTA configuration
end
if nargin < 11 | isempty(beta)
   beta=60;       % NUWAR configuration
%	beta=0;        % DELTA configuration
end
if nargin < 12 | isempty(interactive)
   interactive = 0;
end

% --------------
% Set Constants:
% --------------

% UserPoint-to-UserPoint vectors (V), vector lengths (Vlength), and vector directions (Vnorm)
for i=1:numUserPoints-1
   V(1:3,i) = UserPoints(1:3,i+1)-UserPoints(1:3,i);  %vectors between adjacent user points
   Vlength(i) = norm(V(1:3,i));                       %lengths of these vectors
   Vnorm(1:3,i) = V(1:3,i)/Vlength(i);                %normalised vectors
end

% ------------------------------
% calculate clothoid parameters:
% ------------------------------

for i=1:numUserPoints-2        % for each Summit Clothoid
   % Find 'alphaSC', the net angle change required by the Summit Clothoid.
   alphaSC(i) = acos(dot(Vnorm(1:3,i),Vnorm(1:3,i+1)));
   
   switch SummitType
   case 's'
      % Store a separate set of variables for the two parts of a symmetric summit clothoid
      % in order to simplify code later.
      %
      % Choose 'd' for Summit Clothoids as a proportion of shortest usable* length of the 
      % adjacent segments.  *All of the length of the first and last straights, and half the 
      % the length of the middle straights can be used.  
      % 'dfactor' represents this proportion.
      if numUserPoints == 3
         d(i,1) = min([Vlength(i)   Vlength(i+1)  ]) * dfactor(1);
      elseif i==1
         d(i,1) = min([Vlength(i)   Vlength(i+1)/2]) * dfactor(1);
      elseif i==numUserPoints-2
         d(i,1) = min([Vlength(i)/2 Vlength(i+1)  ]) * dfactor(1);
      else
         d(i,1) = min([Vlength(i)/2 Vlength(i+1)/2]) * dfactor(1);
      end
      d(i,2) = d(i,1);
      taui(i,1)=alphaSC(i)/2;  %symmetrical case
      taui(i,2)= taui(i,1);
      [Wx Wy] = ClothoidAT(1,taui(i,1));
      A(i,1) = d(i,1) / (Wx + Wy * tan(taui(i)));
      A(i,2) = A(i,1);
      Li(i,1) = (2*A(i,1)^2*taui(i,1))^0.5; 
      Li(i,2) = Li(i,1);
   case 'a'
      %set the outer bound for clothoid d-values as a factor of the straight's length
      if i == 1
         d(i,1) = Vlength(i)   * dfactor(1);
      else
         d(i,1) = Vlength(i)/2 * dfactor(1);
      end
      if i == numUserPoints-2
         d(i,2) = Vlength(i+1)   * dfactor(1);
      else
         d(i,2) = Vlength(i+1)/2 * dfactor(1);
      end
            
      % check d1/d2 is in range:
      DratioLimit = ASC_FindDratioLimit(alphaSC(i),1);   %use polynomial approximation.
      if d(i,1) > d(i,2)  %determine which side is is longer
         %set the user-specified limit to the asymmetry of the summit clothoid
         if d(i,1)/d(i,2) > dfactor(2),
            d(i,1) = dfactor(2)* d(i,2);    %shorten the longer d1 if requested
         end
         if d(i,1)/d(i,2) > DratioLimit,
            disp(['Warning: Too asymmetric: d1 of summit clothoid is being shortened at intersection ' num2str(i) '.']);
            disp(['         dratio was ' num2str(d(i,1)/d(i,2)) '.']);
            disp(['         dratio reduced to maximum value of ' num2str(DratioLimit)]);
            disp(['         dfactor(2) should be used to reduce this further, to achieve continuous curvature']);
            d(i,1) = DratioLimit * d(i,2);  %further shorten d1 if required!
         end
      else
         if d(i,2)/d(i,1) > dfactor(2),
            d(i,2) = dfactor(2)* d(i,1);    %shorten the longer d2 if requested
         end
         if d(i,2)/d(i,1) > DratioLimit,
            disp(['Warning: Too asymmetric: d2 of summit clothoid is being shortened at intersection ' num2str(i) '.']);
            disp(['         dratio was ' num2str(d(i,2)/d(i,1)) '.']);
            disp(['         dratio reduced to maximum value of ' num2str(DratioLimit)]);
            disp(['         dfactor(2) should be used to reduce this further, to achieve continuous curvature']);
            d(i,2) = DratioLimit * d(i,1);  %further shorten d2 if required!
         end
      end            
      
      taui(i,1) = fzero('ASC_Solve(x, P1, P2, P3)', [eps*100*alphaSC(i) (1-eps*100)*alphaSC(i)], ...
         [], [], alphaSC(i), d(i,1), d(i,2));
      [dummyvar, taui(i,2), A(i,1), A(i,2), R(i,1), R(i,2)] = ASC_Solve(taui(i,1), alphaSC(i), d(i,1), d(i,2));
      Li(i,1) = A(i,1)^2/R(i,1);  %length of clothoid
      Li(i,2) = A(i,2)^2/R(i,2);
   otherwise
      disp('SummitType should be ''s'' or ''a''');
      help Clothoid
      return
   end
end

% -------------------------------------
% Calculate trajectory segment lengths:
% -------------------------------------
% The trajectory is subdivided into segments of type 'straight line', 'pre-summit 
% clothoid', or 'post-summit clothoid'.

% Seglengths is an array of the lengths of each of the trajectory segments
SegLengths = [Vlength(1)-d(1,1) ; Li(1,1)];
for i=1:numUserPoints-3
   SegLengths = [SegLengths ; Li(i,2) ; -d(i,2)+Vlength(i+1)-d(i+1,1) ; Li(i+1,1)];
end
SegLengths = [SegLengths ; Li(numUserPoints-2,2) ; Vlength(numUserPoints-1)-d(numUserPoints-2,2)];

% CumSumSegLengths is the cummulative sum of the segment lengths, 
% and represents the distance along the trajectory where the segments end.
CumSumSegLengths = cumsum(SegLengths);

% trajLength is the total length of the trajectory
trajLength = CumSumSegLengths(length(CumSumSegLengths));

% ------------------------------------------------------------------
% generate time-profile (also refered to as the 'Movement-profile')
% ------------------------------------------------------------------

switch TimeRampType 
case 'LinearTime', 
   [s, time] = LinearTime(trajLength, Tst, Tfin, Tsamp); 
case 'ParabolicTime', 
   [s, time] = ParabolicTime(trajLength, Tst, Tfin, m, Tsamp, 0);
case 'SineonRamp', 
   [s, time] = SineonRamp(trajLength, Tst, Tfin, m, Tsamp, 0);
case 'PolyTime', 
   [s, time] = PolyTime(trajLength, Tst, Tfin, mean([Tst, Tfin]), Tsamp, 0); 
otherwise,
   error('Please choose a valid Time Ramp function');
   return;
end

% --------------------------------
% Generate trajectory path points:
% --------------------------------

% Initialise output tables
timepos=time;
timetheta=time;

%Initialise counters:
pathPointNo = 1;       %the counter enumerating each point, along the path of points 
segNo = 1;             %the counter enumerating each segment making up the trajectory

% INITIAL STRAIGHT LINE SEGMENT (having no clothoid at the beginning)
while s(pathPointNo) <= CumSumSegLengths(segNo)
   posbase = UserPoints(1:3,1) + s(pathPointNo).*Vnorm(1:3,1);   % point in Cartesion space
   timepos(pathPointNo,2:4)=posbase';                            % store point
%   timetheta(pathPointNo,2:4)=IK(posbase(1:3), 0, alpha, beta)'; % point in joint space
   pathPointNo = pathPointNo + 1;
end

for userPointNo = 2:numUserPoints-1
   % PRE-SUMMIT CLOTHOID:
   segNo = segNo + 1;
   
   % build transformation matrix from clothoid XY to position in space
   ClothoidOrigin = UserPoints(1:3,userPointNo) + -d(userPointNo-1,1)*Vnorm(1:3,userPointNo-1);
   n1 = Vnorm(1:3,userPointNo-1);
   temp = cross(n1,Vnorm(1:3,userPointNo));
   n3 = temp / norm(temp);   
   n2 = cross(n3,n1);
   T = [[n1 n2 n3 ClothoidOrigin];[0 0 0 1]];
   
   % calculate points along clothoid in local coordinates
   while s(pathPointNo) <= CumSumSegLengths(segNo)
      L = s(pathPointNo)-CumSumSegLengths(segNo-1);      % distance into the clothoid
      tau = L^2/(2*A(userPointNo-1,1)^2);                % angle of clothoid tangent
      [Xt Yt] = ClothoidAT(A(userPointNo-1,1),tau);      % point in local coordinates
      posbase = T * [Xt;Yt;0;1];                         % point in world coordinates
%     timetheta(pathPointNo,2:4)=IK(posbase(1:3), 0, alpha, beta)';
      timepos(pathPointNo,2:4)=posbase(1:3,1)';
      pathPointNo = pathPointNo + 1;
   end
   
   % POST-SUMMIT CLOTHOID:
   segNo = segNo + 1;
   
   % build transformation matrix from clothoid XY to position in space
   ClothoidOrigin = UserPoints(1:3,userPointNo) + d(userPointNo-1,2)*Vnorm(1:3,userPointNo);
   n1 = -Vnorm(1:3,userPointNo);
   temp = cross(Vnorm(1:3,userPointNo-1),n1);
   n3 = temp / norm(temp);   
   n2 = cross(n3,n1);
   T = [[n1 n2 n3 ClothoidOrigin];[0 0 0 1]];
   
   % calculate points along clothoid in local coordinates
   while s(pathPointNo) <= CumSumSegLengths(segNo)
      L = Li(userPointNo-1,2)-(s(pathPointNo)-CumSumSegLengths(segNo-1));
      tau = L^2/(2*A(userPointNo-1,2)^2);
      [Xt Yt] = ClothoidAT(A(userPointNo-1,2),tau);
      posbase = T * [Xt;Yt;0;1];
 %     timetheta(pathPointNo,2:4)=IK(posbase(1:3), 0, alpha, beta)';
      timepos(pathPointNo,2:4)=posbase(1:3,1)';
      if s(pathPointNo) == CumSumSegLengths(segNo)
         break
      else
         pathPointNo = pathPointNo + 1;
      end
   end
   
   % STRAIGHT LINE:
   segNo = segNo + 1;
   while s(pathPointNo) <= CumSumSegLengths(segNo)
      posbase = UserPoints(1:3,userPointNo) + ( s(pathPointNo)-CumSumSegLengths(segNo-1)+...
         d(userPointNo-1,2) ).*Vnorm(1:3,userPointNo);
%      timetheta(pathPointNo,2:4)=IK(posbase(1:3), 0, alpha, beta)';
      timepos(pathPointNo,2:4)=posbase(1:3,1)';
      if s(pathPointNo) == CumSumSegLengths(segNo)
         break
      else
         pathPointNo = pathPointNo + 1;
      end
   end
end

% --------------------------------------------------------
% Perform Inverse Kinematics for non-graphical simulation:
% --------------------------------------------------------

numPathPoints = size(s,1);

if drawmode(1)==0
   for i = 1:numPathPoints 
      timetheta(i,2:4)=IK(timepos(i,2:4)', 0, alpha, beta)';
   end
end

% ----------------
% Show Trajectory:
% ----------------

if drawmode(1)~=0
   if drawmode(6) == 1
      [timetheta, M] = ShowTrajectory(drawmode, timepos, alpha, beta, interactive, UserPoints);
   else
      [timetheta] = ShowTrajectory(drawmode, timepos, alpha, beta, interactive, UserPoints);
   end
end
