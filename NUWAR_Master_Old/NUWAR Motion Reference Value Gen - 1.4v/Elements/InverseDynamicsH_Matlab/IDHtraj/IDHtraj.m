% Function [Q,lamda]=IDHtraj(timepos, timetheta,alpha, beta, diffpoints)

% This function solves the inverse dynamics problem for an entire trajectory using the hamiltonian
% formulation of the equations of motion. The inverse dynamic calulations are solved for the entire
% trajectory in one matrix operation. This dramatically reduces calculation time (by as much as 95%), but removes the ability
% to calculate torques "on the fly".
%
% Input Parameters:
%		timepos		= the time-position data for the travelling plate.
%		timetheta	= the time-angle data for the three motors.
%		alpha		= the orientation of the motors in the 'alpha' direction.
%		beta		= the orientation of the motors in the 'beta' direction.
%		diffpoints	= 3 or 5 (the number of points to use for numerical differntiation.
%
% Default values:
% 		timepos		= required.
%		timetheta 	= required.
%		alpha		= -35.26 degrees.
% 		beta		= 60 degrees.
% 		diffpoints  	= 5 (5 point differentiation scheme).
%
% Output values:
%     Q 			= vector of motor torques.
%     lamda 	= vector of Lagrange multipliers.
%
% Required Functions:
%		q_dq
%		p_dp
%		lagrange_multipliers
%		torques
%		matrixdiff
%		InitArms
%		InitDynamics
% 
% All distances are in metres, and all angles in degrees.
%
% Author: Ben Hawkey 2000


function [Q, lamda]=IDHtraj(timepos, timetheta, alpha, beta, diffpoints)

alpha  = pi/180*alpha;

beta = pi/180*beta;

timetheta(:,2:4)=(pi/180).*timetheta(:,2:4);
%All operations use radians instead of degrees.

step = timepos(2,1)-timepos(1,1);
%This determines the time interval between samplepoints.

samp = size(timepos,1);
% Number of sample points


[q,dq]=q_dq(timepos, timetheta, step, samp, diffpoints);

[p,dp]=p_dp(q,dq,alpha, beta, step, samp, diffpoints);

[lamda]=lagrange_multipliers(q, dp, alpha, beta);

[Q] = torques(q, dq, dp, lamda, alpha, beta);






