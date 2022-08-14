% InitDynamics
%
% Dynamics Parameters
%
% This script initialises:
% Ma = 0.977     Control arm mass [kg]
% Mb = 0.0592    Parallelogram mass [kg]
% Mc = 0.2807    Travelling plate mass [kg]
% Mj = 0.0099    Parallelogram-control arm joint mass [kg]
% Ja = 0.01822   Mass moment of inertia of control arm [kgm^2]
% g  = 9.81      Gravitational acceleration [m/s^2]
% H  = 0.03/La   Ratio of control arm's centre of mass to length
%
% Note: La is specified in 'InitArms'

Ma = 0.977;
Mb = 0.0592;
Mc = 0.2807;
Mj = 0.0099;
Ja = 0.01822;
g = 9.81;
H = 0.03/La;
