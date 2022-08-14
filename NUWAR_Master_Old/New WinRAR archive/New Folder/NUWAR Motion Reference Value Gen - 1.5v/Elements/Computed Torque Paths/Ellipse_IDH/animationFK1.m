% function [M] = animationFK1;
% function [M] = animationFK1(drawmode);
% function [M] = animationFK1(drawmode, alpha, beta);
%
% - performs a simple animation where the motor angles are cycled through
%   from 0 to 180 degrees.
%
% M - the matrix holding the frames for movie playback
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
% NOTE: a movie cannot be created for more than one simultaneous plots, ie: for param 5 = 2 or more
%
% Default values:
%       drawmode = (set by default in function checkdrawmode)
%       alpha    = 0
%       beta     = 0
% Note: 
%       All angles in degrees.
%       Other defaults set by InitArms  

% Authors: Josh Male and Stephen LePage
% November 1998

function [M] = animationFK1(drawmode, alpha, beta);

% check the drawmode parameter
if nargin == 0
   drawmode = checkdrawmode;
else
   drawmode = checkdrawmode(drawmode);
end

if nargin <= 1		%set the default values for alpha and beta - DELTA configuration
%    alpha = 0;   %- DELTA configuration
%    beta  = 0;
   alpha = -35.26;   %- NUWAR configuration
   beta  = 60;
end

drawmode(3) = 1;	% ensure we initialise the base
InitBase(drawmode,alpha*pi/180, beta*pi/180);
drawmode(3)=0;  % we won't need to initialise the base again

% if a movie is desired, allocate memory for it
if drawmode(6)~=0
   M = moviein(n);
end

while 1
    for i = 0:10:350
       FK([i;i;i], drawmode, alpha, beta);
       drawnow;
        if drawmode(6)~=0
           M(:,i/10 + 1) = getframe;
       end
       if strcmp(get(gcf,'currentcharacter'),' ') == 1 %exit loop if space key is pressed
          break
       end	   
    end
end

