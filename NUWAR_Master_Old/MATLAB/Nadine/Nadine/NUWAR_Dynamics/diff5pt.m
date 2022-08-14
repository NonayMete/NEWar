% function [D1, D2] = diff5pt(data)
%
% diff5pt differentiates data by 5 point numerical differentiation.
% The data must be in the standard format of timetheta or timepos.
% The outputs of diff5pt are the first derivative of data with respect to time [D1],
% and the second derivative of data with respect to time [D2].
% Either D1 or both D1 and D2 can be evaluated.
% For good resolution, use a high path update rate. 
% 1000 rows or data is a good size so that spikes don't upset the scaling of the axes.
%
% The five point formula used in this function is from Burden & Faires, 
% 'Numerical Analysis', 1993,p 161.
% 
% Note:
% Endpoints are calculated on the assumption of zero velocity, acceleration and jerk
% at the starting and finishing time of timepos.
%
% Author: Nadine Frame 1999


function [D1, D2] = diff5pt(data)

numPoints = size(data, 1);
Tsamp = data(2,1) - data(1,1);   % assume equal time division

%calculation of the first derivative
if nargout >= 1
   D1 = data(:,1);
   % End points:
   for c=2:4
      D1(1,c)=0;
      D1(2,c)=(data(3,c)-data(1,c))/(Tsamp*2);
      D1(numPoints-1,c)=(data(numPoints,c)-data(numPoints-2,c))/(Tsamp*2);
      D1(numPoints,c)= 0;
   end
   % Other points:
   for r=3:numPoints-2
      for c=2:4
         D1(r,c)=(data(r-2,c)-8*data(r-1,c)+8*data(r+1,c)-data(r+2,c))/(Tsamp*12);
      end
   end
end

%calculation of second derivative
if nargout == 2
   D2 = data(:,1);
   % End points:
   for c=2:4
      D2(1,c)=0;
      D2(2,c)=(D1(3,c)-D1(1,c))/(Tsamp*2);
		D2(numPoints-1,c)=(D1(numPoints,c)-D1(numPoints-2,c))/(Tsamp*2);
      D2(numPoints,c)= 0;
   end
   % Other points:
   for r=3:numPoints-2
      for c=2:4
         D2(r,c)=(D1(r-2,c)-8*D1(r-1,c)+8*D1(r+1,c)-D1(r+2,c))/(Tsamp*12);
      end
   end
end


