% function drawmode = checkdrawmode(drawmode)
%
% CheckDrawMode checks validity of drawmode parameters, 
% setting default values where essential parameters are missing
% 
% drawmode = [{0,1,2}, {0,1}, {0,1}, {0,1}, {1,2,4}, {0,1}]
% where param1 = 0 means don't plot
%              = 1 means plot wire frame
%              = 2 means plot wire frame with accurate representation of forearms
%              = 3 means plot cylinder representation
%       param2 = 1 means also plot reference frames
%       param3 = 1 means initialise the display
%       param4 = 1 means writing to GUI
%       param5 = number of plots generated (eg 2 for stereo)
%       param6 = 1 means create a movie for playback

% Authors: Josh Male and Stephen LePage
% November 1998

function drawmode = checkdrawmode(drawmode)

drawmodedefault = [3 0 1 0 1 0];  %the global default for drawmode
if nargin == 1
   i = length(drawmode);
   j = length(drawmodedefault);
   if i > j
      error('Too many drawmode parameters have been specified');
   end
   drawmode(i+1:j)=drawmodedefault(i+1:j);
   if drawmode(5) ~= 1 & drawmode(6) == 1 
      drawmode(6) = 0;
      disp('Warning: cannot make movie drawmode(6)=1 with multiple plots drawmode(5)>1');
   end
else
   drawmode = drawmodedefault;
end   

   
