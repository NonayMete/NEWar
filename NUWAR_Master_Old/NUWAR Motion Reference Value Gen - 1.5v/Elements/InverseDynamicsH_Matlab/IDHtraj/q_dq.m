% function[q, dq] = q_dq(timepos, timetheta, step, samp, diffpoints)
%
% Position - Velocity Function
%
% Takes NUWAR position data and forms q matrix, then performs numerical differentiation to obtain the velocity matrix dq.
% q and dq contain the position and velocity data only and omit time information. The columns are
% x y z theta1 theta2 theta3 and dx dy dz dtheta1 dtheta2 dtheta3 respectively.
%
% Input Parameters:
%		timepos		= the time-position data for the travelling plate.
%		timetheta	= the time-angle data for the three motors.
%		step			= the time interval between sample points.
%		samp 			= the number of sample points.
%		diffpoints	= 3 or 5 (the number of points to use for numerical differntiation.
%
% Output values:
%     q 				= vector of NUWAR position data.
%     dq 			= vector of NUWAR velocity data.
%
% Required Functions:
%  	matrixdiff
% 
%
% Author: Ben Hawkey 2000



function[q, dq] = q_dq(timepos, timetheta, step, samp, diffpoints)

q = [timepos(:,2:4),timetheta(:,2:4)];
%Forms one matrix containing x,y,z,theta1, theta2, and theta3 data. There is no time column.
%It is transposed because q is most commonly used as a column vector.
	
dq = matrixdiff(q, step, samp, diffpoints);