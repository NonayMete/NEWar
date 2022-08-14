% function [p,dp] = p_dp(q,dq,alpha, beta, step,samp, diffpoints)
%
%	Canonical Momenta Function
%
%	This function calculates the canonical momenta p as well as the first time derivative dp. dp is calculated by differentiating
% 	p using the matrixdiff function.
%
%
% Input parameters:
% q = matrix of travelling plate position and motor angles.
% dq = matrix of travelling plate velocity and motor angular velocity.
% alpha = the orientation of the motors in the 'alpha' direction.
% beta = the orientation of the motors in the 'beta' direction.
% diffpoints = 3 or 5 (the number of points to use for numerical differntiation.
%
% Outputs:
% p = canonical momenta for entire time history.
% dp = first derivative of canonical momenta for entire time history.
%
% Author: Ben Hawkey 2000.

function [p,dp] = p_dp(q,dq,alpha, beta, step,samp, diffpoints)


InitArms;

InitDynamics;


x = q(:,1);
y = q(:,2);
z = q(:,3);
theta1 = q(:,4);
theta2 = q(:,5);
theta3 = q(:,6);
dx = dq(:,1);
dy = dq(:,2);
dz = dq(:,3);
dtheta1 = dq(:,4);
dtheta2 = dq(:,5);
dtheta3 = dq(:,6);

cosalpha = cos(alpha);
sinalpha = sin(alpha);
cosbeta = cos(beta);
sinbeta = sin(beta);

costheta1 = cos(theta1);
sintheta1 = sin(theta1);
costheta2 = cos(theta2);
sintheta2 = sin(theta2);
costheta3 = cos(theta3);
sintheta3 = sin(theta3);
      
p = [(1/12).*(12.*dx.*(Mb+Mc)+2.*dtheta1.*La.*Mb.*(costheta1.* ...
sinalpha.*sinbeta+(-1).*cosbeta.*sintheta1)+dtheta2.*La.*Mb.*((-1) ...
.*costheta2.*sinalpha.*(sqrt(3).*cosbeta+sinbeta)+(cosbeta+(-1).* ...
sqrt(3).*sinbeta).*sintheta2)+dtheta3.*La.*Mb.*(costheta3.* ...
sinalpha.*(sqrt(3).*cosbeta+(-1).*sinbeta)+(cosbeta+sqrt(3).* ...
sinbeta).*sintheta3)),(1/12).*(12.*dy.*(Mb+Mc)+2.*dtheta1.*La.* ...
Mb.*(cosbeta.*costheta1.*sinalpha+sinbeta.*sintheta1)+dtheta2.* ...
La.*Mb.*(costheta2.*sinalpha.*((-1).*cosbeta+sqrt(3).*sinbeta)+( ...
-1).*(sqrt(3).*cosbeta+sinbeta).*sintheta2)+dtheta3.*La.*Mb.*((-1) ...
.*costheta3.*sinalpha.*(cosbeta+sqrt(3).*sinbeta)+(sqrt(3).* ...
cosbeta+(-1).*sinbeta).*sintheta3)),(1/6).*((-1).*cosalpha.*( ...
costheta1.*dtheta1+costheta2.*dtheta2+costheta3.*dtheta3).*La.*Mb+ ...
6.*dz.*(Mb+Mc)),(1/6).*((-1).*cosalpha.*costheta1.*dz.*La.*Mb+6.* ...
dtheta1.*(Ja+(1/3).*La.^2.*(Mb+3.*Mj))+dx.*La.*Mb.*(costheta1.* ...
sinalpha.*sinbeta+(-1).*cosbeta.*sintheta1)+dy.*La.*Mb.*(cosbeta.* ...
costheta1.*sinalpha+sinbeta.*sintheta1)),(1/12).*((-2).*cosalpha.* ...
costheta2.*dz.*La.*Mb+4.*dtheta2.*(3.*Ja+La.^2.*(Mb+3.*Mj))+dy.* ...
La.*Mb.*(costheta2.*sinalpha.*((-1).*cosbeta+sqrt(3).*sinbeta)+( ...
-1).*(sqrt(3).*cosbeta+sinbeta).*sintheta2)+dx.*La.*Mb.*((-1).* ...
costheta2.*sinalpha.*(sqrt(3).*cosbeta+sinbeta)+(cosbeta+(-1).* ...
sqrt(3).*sinbeta).*sintheta2)),(1/12).*((-2).*cosalpha.* ...
costheta3.*dz.*La.*Mb+4.*dtheta3.*(3.*Ja+La.^2.*(Mb+3.*Mj))+dy.* ...
La.*Mb.*((-1).*costheta3.*sinalpha.*(cosbeta+sqrt(3).*sinbeta)+( ...
sqrt(3).*cosbeta+(-1).*sinbeta).*sintheta3)+dx.*La.*Mb.*( ...
costheta3.*sinalpha.*(sqrt(3).*cosbeta+(-1).*sinbeta)+(cosbeta+ ...
sqrt(3).*sinbeta).*sintheta3))];

%dp is now determined by numerically differentiating p.

dp = matrixdiff(p, step, samp, diffpoints);