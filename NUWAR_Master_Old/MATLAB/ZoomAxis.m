% function zoomaxis(axishandle)
%
% This function zooms in on a subplot, making it the full size of the figure.
% It is intended to be used via the axis's 'ButtonDownFcn' call back routine -
% It is excecuted (without any parameters) when the axis is clicked upon.
% A second click on the axis will return the figure to it's original format.
%
% AnalyseTrajectory has been configured to put a title, xlabel, and ylabel on each 
% subplot, but hiding those that are unnecessary, and would clutter up the graph.
% These hidden titles, xlabels and ylabels are restored for the zoomed axis, so 
% that each plot is labelled properly.

% Author: Stephen LePage
% March 1999

function zoomaxis(axishandle)
if nargin > 0 & ~isempty(axishandle)
   ca=axishandle;
else
   ca=gca;
end

ZoomedPosition=[0.13 0.11 0.775 0.815];
set(ca,'units','normalized');
set(0, 'ShowHiddenHandles', 'on');

% Initialise UserData in all axes
for ha=get(gcf,'children')'
   UserData=get(ha,'UserData');
   if ~isfield(UserData,'SmallPosition')
      UserData.SmallPosition=get(ha,'position');
   end
   if ~isfield(UserData,'VisibleChildren')
      UserData.VisibleChildren=[];
      for c=get(ha,'children')'
         if strcmp(get(c,'visible'),'on')
            UserData.VisibleChildren=[UserData.VisibleChildren; c];
         end
      end
%      UserData.VisibleChildren
%      pause
   end
   set(ha,'UserData',UserData);  %update UserData
end

if ~all(get(ca,'position') == ZoomedPosition)  % zooming in
   HideAllHandles;
   ShowAllCurrentAxisChildren(ca),
   set(ca,'position',ZoomedPosition);
else                                           % zooming out
   for ha=get(gcf,'children')'
      UserData=get(ha,'UserData');
      set(ha,'position',UserData.SmallPosition);   %set all axes to SmallPosition
   end
   HideAllHandles;
   ShowVisibleChildrenOnly;
end
set(0, 'ShowHiddenHandles', 'off');




function HideAllHandles
for ha=get(gcf,'children')'
   set(ha,'Visible','off');
   for hac=get(ha,'children')'
      set(hac,'Visible','off');
   end
end



function ShowVisibleChildrenOnly
for ha=get(gcf,'children')'
   set(ha,'Visible','on');
   UserData=get(ha,'UserData');
   for hac=get(ha,'children')'
      set(hac,'Visible','off');
   end
   for hac=UserData.VisibleChildren'
      set(hac,'Visible','on');
   end
end



function ShowAllCurrentAxisChildren(ca)
set(ca,'Visible','on');
for hac=get(ca,'children')'
   set(hac,'Visible','on');
end
