%function [s, time] = LinearTime(d, Tst, Tfin, Tsamp)
%
% LinearTime generates a linear interpolation of distance in time.
%
% Input parameters:
%      d            is the total distance to travell
%      Tst          is the starting time.
%      Tfin         is the finishing time.
%      Tsamp        is the sample period, in seconds
%
% Outputs:
%      time         an array of times, from Tst to Tfin step Tsamp
%      s            an array of corresponding positions
%
%eg:
%[s, time] = LinearTime(1, 0, 1, 0.01);

% Authors: Josh Male and Stephen LePage
% November 1998

function [s, time] = LinearTime(d, Tst, Tfin, Tsamp)
if nargin < 4
   disp('This function requires arguments:');
   help LinearTime
   return
end

time = [];
s = [];
for t=Tst:Tsamp:Tfin
   time = [time;t]; 
   s = [s; d/(Tfin-Tst)*(t-Tst)];
end
s(size(s,1))=d;  % fixes numerical resolution error
