% function InitialiseDisplay;
% function InitialiseDisplay(useGUI);
% function InitialiseDisplay(useGUI,numPlots);
%
% This function initialises the axes and standard axes properties for nuwar plots.
%
% where:
%     useGUI = 1 means writing to GUI
%     numPlots = number of plots generated -
%         where numPlots = 1 means generate a single axes object
%                        = 2 means generate two axes for stereo viewing
%                        = 4 means generate four axes for top, front, right, and perspective viewing
% defaults:
%     useGUI = 0 
%     numPlots = 1  

function InitialiseDisplay(useGUI,numPlots);

if nargin == 0
   useGUI = 0;
end
if nargin <= 1
   numPots = 1;
end

if useGUI == 1
   h = findobj('Tag','GuiAxes1');   %test if the GUI exists.  If so, disactivate stereo plots.
   if size(h,1) == 1   % ie: the GUI exists 
      figure(get(h, 'parent')); 
      subplot(h(1));
	 	axis([-0.8, 0.8, -0.8, 0.8, -1.1, 0.4]);
	   AZ = -37.5;
	   EL = 30;
	  	view(AZ, EL);
		set(gca,'DataAspectRatio',[1 1 1]);
	  	set(gca,'projection','perspective');
	  	set(gca,'CameraViewAngleMode','manual');
		grid on;
	  	hold on;
      figure(gcf);
   elseif h > 1
		error('found too many GUIs');
	else
		error('could not find the GUI axes');
	end
else % not using GUI
   if numPlots <=2  % Initialises either a single or a stereo pair of axes
	   StereoAngle = 3.5;  % the difference between the view 'azimuth'angles of two stereo plots
	   figure;
		scrsz = get(0,'ScreenSize'); % eg:  [left, bottom, width, height] = [1 1 1024 768]
		set(gcf,'Position',scrsz + [-2 30 4 -66])  %maximise the figure the hard way
	   for plot=1:numPlots
		   subplot(1,numPlots,plot);
		   axis([-0.8, 0.8, -0.8, 0.8, -1.1, 0.4]);
		   AZ = -37.5 - (plot-1)*StereoAngle;
		   EL = 30;
		   view(AZ, EL);
			set(gca,'DataAspectRatio',[1 1 1]);
		   set(gca,'projection','perspective');
		   set(gca,'CameraViewAngleMode','manual');
			grid on;
		   hold on;
      end
   elseif numPlots == 4  % initialises 4 plots - top, front, right, and perspective.
	   figure;
		scrsz = get(0,'ScreenSize'); % eg:  [left, bottom, width, height] = [1 1 1024 768]
		set(gcf,'Position',scrsz + [-2 30 4 -66])  %maximise the figure the hard way
      for plot=1:numPlots 
		   subplot(2,2,plot);
		   axis([-0.8, 0.8, -0.8, 0.8, -1.1, 0.4]);
			set(gca,'DataAspectRatio',[1 1 1]);
			grid on;
         hold on;
      end
      subplot(2,2,1); %top
      view(0,90);
      subplot(2,2,2); %perspective
      view(3);
	   set(gca,'projection','perspective');
      subplot(2,2,3); % bottom
      view(0,0);
      subplot(2,2,4); % right
      view(90,0);
   else
      error('Check that the requested number of plots is valid.  Set drawmode(5) to = 1 2 or 4')
   end
end
set(gcf,'Renderer','zbuffer');
% The following line causes the figure window created to close when the return (or 'enter') key is pressed.
set(gcf,'keypressfcn','closeonreturn')  
