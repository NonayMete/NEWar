% function rtpan(CommandString)
%
% This function makes possible the changing of many figure and axes properties 
%     - at the press of a button.
%
% Features include: 
%     panning along X, Y, and Z. 
%     zooming in and out, 
%     rotating 3-D plots about the z axis and raising or lowering elevation, 
%     rotating 2-D plots about camera axis,
%     changing axes limits, 
%     changing data aspect ratio (2-D only),
%     toggling X Y and Z grids,
%     toggling the axes on and off.
%     changing the figure size and position, 
%     deleting the current figure
% See below for mapping of keyboard to these functions.
%
% There is also a CONTINUOUS mode that allows many of these features to loop automatically.
% The step size for many of these functions, defined by 'factor', can raised or lowered 
% to suit.
%
% This function is designed to be used as the 'KeyPressFcn' Call Back Routine for MATLAB
% figures, where each key press on the figure initiates a new instance of this function.
% Special care has been taken to allow a 'continuous mode' instance of this function to 
% run concurrently and interact with non-continuous instances of this function.
%
% ItialiseDisplay, a robot initialisation function, sets this function as the 
% 'keypressfcn' for all robot plots.
%
% It may be set as a default for all figures, by running this command:
% set(0,'DefaultFigureCreateFcn','set(gcf,''keypressfcn'',''rtpan'')')
%
% THE COMMANDS:
%
% This is the keypad layout:
%
%                    Shrink Axes(/)      Grow Axes(*)       Decrease
%                                                           factor(-)
%  Zoom Out.(7)      Pan Y+.....(8)      Zoom In..(9) 
%                                                           Increase
%  Pan X-...(4)      STOP.......(5)      Pan X+...(6)       factor(+)
%
%  Pan Z-...(1)      Pan Y-.....(2)      Pan Z+...(3)
%
%     Continuous mode.......(0)          RESET....(.)
%
% Main keyboard commands:
%
%     ( DELETE )      Kill current figure  (use space to end a trajectory first!)
%     ( [ | ] )       Rotates Clockwise | Anti-Clockwise about Z axis
%     ( p | ; )       Increases | Decreases Elevation
%     ( e | r )       Shrinks | Grows X axis limits
%     ( d | f )       Shrinks | Grows Y axis limits
%     ( c | v )       Shrinks | Grows Z axis limits
%     ( u | i )       Shrinks | Grows X axis DataAspectRatio (2D only)
%     ( j | k )       Shrinks | Grows Y axis DataAspectRatio (2D only)
%     ( m | , )       Shrinks | Grows Z axis DataAspectRatio (2D only)
%     ( g )           toggles Grid
%     ( x | y | z )   toggles XGrid | YGrid | Zgrid
%     ( a )           toggles Axis Visibility
%     { q }           disables rtpan by removing the keypressfcn of the current figure.
%     { Q }           Used by plot's rtpan initialisation string to quit if already initialised.
%     { n }           Redefine settings for RESET as current settings
%     { ` }           Maximise figure window
%     { ~ }           Makes the figure window square
%     { ! }           Makes the figure window 15 cm wide
%     { s }           Makes the figure window full width and half height for stereo plots.
%     { ! }           Makes the figure window fit inside an A4 page
%     { T }           Top view (current axis only)
%     { F }           Front view (current axis only)
%     { R }           Right view (current axis only)
%     { G }           Default 3-D view (current axis only)
%     { P }           Toggles current axis 'projection' between 'orthographic' and 'perspective'
%     ( Z )           toggles figure renderer between 'painters' and 'zbuffer'
%
% Note: 'CommandString', a string of 'command characters' is a parameter which enables other
%       functions to call upon this function.  It is not required when this function is 
%       called from the commmand prompt, as input is given through the figure key presses.
% Side effects:  Using 'zbuffer' as the renderer consumes a lot of system memory,
%       so using continuous motion with zbuffer gradually depletes system resources,
%       until the computer runs out of memory.  The fix is to restart matlab before memory 
%       gets too low...
%       The system resources can be monitored with the windows application:
%       "C:\Program Files\Common Files\Microsoft Shared\MSINFO\MSINFO32.EXE"

% Author: Stephen LePage
% March 1999

function rtpan(CommandString)
DeleteKey=char(127);
EnterKey=char(13);
BackspaceKey=char(8);
cf=gcf;
%set(cf,'Interruptible','off');
set(cf,'KeyPressFcn','rtpan');
figure(cf);
if nargin == 0
   CommandString=get(cf,'currentcharacter');
end

UserData=get(cf,'UserData');
if isempty(UserData) | isempty(UserData.axishandles) %Initialise figure and axes properties
   
   UserData.factor=0.04;
   UserData.Conts=0;         % continuous motion mode switch
   UserData.ContsPending=0;  % semaphore to allow one further keypress after turning conts on.
   
   UserData.axishandles=[];
   UserData.handles3D=[];
   UserData.handles2D=[];
   children=get(cf,'children');       %find axes on current plot
   for child = children'
      if strcmp(get(child,'type'),'axes') == 1
         UserData.axishandles = [UserData.axishandles; child];
         
         AxisData.XLim=get(child,'XLim');                             % for use with RESET
         AxisData.YLim=get(child,'YLim');                             % for use with RESET
         AxisData.ZLim=get(child,'ZLim');                             % for use with RESET
         AxisData.CameraPosition=get(child,'CameraPosition');         % for use with RESET
         AxisData.CameraTarget=get(child,'CameraTarget');             % for use with RESET
         AxisData.CameraUpVector=get(child,'CameraUpVector');         % for use with RESET
         AxisData.DataAspectRatio=get(child,'DataAspectRatio');       % for use with RESET
         AxisData.XGrid=get(child,'XGrid');                           % for use with RESET
         AxisData.YGrid=get(child,'YGrid');                           % for use with RESET
         AxisData.ZGrid=get(child,'ZGrid');                           % for use with RESET
         AxisData.Visible=get(child,'Visible');                       % for use with RESET
         AxisData.Projection=get(child,'Projection');                 % for use with RESET
         set(child,'UserData',AxisData);        % Store axes properties for use with RESET
         
         if  all(rem(get(child,'view'),90)==0),
            UserData.handles2D = [UserData.handles2D; child];
         else
            UserData.handles3D = [UserData.handles3D; child];
         end
         
         set(child,'DataAspectRatioMode','manual');
         set(child,'PlotBoxAspectRatioMode','manual');
         set(child,'CameraViewAngleMode','manual');
         set(child,'CameraPositionMode','manual');
         set(child,'CameraUpVectorMode','manual');
         set(child,'CameraTargetMode','manual');
         set(child,'XLimMode','manual','YLimMode','manual','ZLimMode','manual');
         set(child,'ButtonDownFcn','zoomaxis')
      end
   end
   
   set(cf,'UserData',UserData);     % Store figure properties
   
   if size(CommandString) == [0 0]
      return
   end
   CharactersNoAxesRequired=sprintf('q~` %s%s%s',DeleteKey,EnterKey,BackspaceKey);
   if size(UserData.axishandles,1) == 0 & isempty(findstr(CommandString(1),CharactersNoAxesRequired))
      disp('rtpan requires at least one axis');
      return
   end
else
   if ~isempty(CommandString) & strcmp(CommandString(1),'Q')   % return on 'Q' if already initialised.
      return                         % used at the beginning of initialisation strings
   end                               % so that figures are initialised once only.
   UserData=get(cf,'UserData');
end

ContinuousCommands=sprintf('1234567890[]p;.n%s',DeleteKey);

for cc=CommandString
   if isempty(findstr(cc,ContinuousCommands))  % If cc is not a command that effects continuous 
      switch(cc)                               % movement, make the change and quit.
      case '+'
         UserData.factor=UserData.factor*1.5;
      case '-'
         UserData.factor=UserData.factor/1.5;
      case {'/', '*'}                           %Srink or Grow ALL axis Limits
         for h=UserData.axishandles';
            XLim=get(h,'XLim');
            YLim=get(h,'YLim');
            ZLim=get(h,'ZLim');
            Xdel=UserData.factor*(XLim(2)-XLim(1));
            Ydel=UserData.factor*(YLim(2)-YLim(1));
            Zdel=UserData.factor*(ZLim(2)-ZLim(1));
            if strcmp(cc,'/')
               XLim=XLim + [Xdel -Xdel];
               YLim=YLim + [Ydel -Ydel];
               ZLim=ZLim + [Zdel -Zdel];
            else
               XLim=XLim + [-Xdel Xdel];
               YLim=YLim + [-Ydel Ydel];
               ZLim=ZLim + [-Zdel Zdel];
            end
            set(h,'XLim',XLim)
            set(h,'YLim',YLim)
            set(h,'ZLim',ZLim)
         end
      case {'e', 'r'}                           %Srink or Grow X axis Limits
         for h=UserData.axishandles';
            XLim=get(h,'XLim');
            Xdel=UserData.factor*(XLim(2)-XLim(1));
            if strcmp(cc,'e')
               XLim=XLim + [Xdel -Xdel];
            else
               XLim=XLim + [-Xdel Xdel];
            end
            set(h,'XLim',XLim)
         end
      case {'d', 'f'}                           %Srink or Grow Y axis Limits
         for h=UserData.axishandles';
            YLim=get(h,'YLim');
            Ydel=UserData.factor*(YLim(2)-YLim(1));
            if strcmp(cc,'d')
               YLim=YLim + [Ydel -Ydel];
            else
               YLim=YLim + [-Ydel Ydel];
            end
            set(h,'YLim',YLim)
         end
      case {'c', 'v'}                           %Srink or Grow Z axis Limits
         for h=UserData.axishandles';
            ZLim=get(h,'ZLim');
            Zdel=UserData.factor*(ZLim(2)-ZLim(1));
            if strcmp(cc,'c')
               ZLim=ZLim + [Zdel -Zdel];
            else
               ZLim=ZLim + [-Zdel Zdel];
            end
            set(h,'ZLim',ZLim)
         end
      case {'u', 'i'}                           %Srink or Grow X axis DataAspectRatio
         for h=UserData.handles2D';
            DataAspectRatio=get(h, 'DataAspectRatio');
            if strcmp(cc,'u')
               NewX=DataAspectRatio(1)/(1-UserData.factor);
            else
               NewX=DataAspectRatio(1)*(1-UserData.factor);
            end
            set(h,'DataAspectRatio',[NewX DataAspectRatio(2) DataAspectRatio(3)]);
         end
      case {'j', 'k'}                           %Srink or Grow Y axis DataAspectRatio
         for h=UserData.handles2D';
            DataAspectRatio=get(h, 'DataAspectRatio');
            if strcmp(cc,'j')
               NewY=DataAspectRatio(2)/(1-UserData.factor);
            else
               NewY=DataAspectRatio(2)*(1-UserData.factor);
            end
            set(h,'DataAspectRatio',[DataAspectRatio(1) NewY  DataAspectRatio(3)]);
         end
      case {'m', ','}                           %Srink or Grow Z axis DataAspectRatio
         for h=UserData.handles2D';
            DataAspectRatio=get(h, 'DataAspectRatio');
            if strcmp(cc,'m')
               NewZ=DataAspectRatio(3)/(1-UserData.factor);
            else
               NewZ=DataAspectRatio(3)*(1-UserData.factor);
            end
            set(h,'DataAspectRatio',[DataAspectRatio(1) DataAspectRatio(2) NewZ]);
         end
      case 'g'
         for h=UserData.axishandles';
            set(cf,'currentaxes',h);
            grid;
         end
      case 'x'
         for h=UserData.axishandles';
            if (strcmp(get(h,'XGrid'),'off'))
               set(h,'XGrid','on');
            else
               set(h,'XGrid','off');
            end
         end
      case 'y'
         for h=UserData.axishandles';
            if (strcmp(get(h,'YGrid'),'off'))
               set(h,'YGrid','on');
            else
               set(h,'YGrid','off');
            end
         end
      case 'z'
         for h=UserData.axishandles';
            if (strcmp(get(h,'ZGrid'),'off'))
               set(h,'ZGrid','on');
            else
               set(h,'ZGrid','off');
            end
         end
      case 'a'
         for h=UserData.axishandles';
            if (strcmp(get(h,'Visible'),'off'))
               set(h,'Visible','on');
            else
               set(h,'Visible','off');
            end
         end
      case 'Z'
         if (strcmp(get(cf,'renderer'),'zbuffer'))
            set(cf,'renderer','painters');
         else
            set(cf,'renderer','zbuffer');
         end
      case 'P'
         if (strcmp(get(gca,'projection'),'perspective'))
            set(gca,'projection','orthographic');
         else
            set(gca,'projection','perspective');
         end
      case 'q'
         set(cf, 'keypressfcn',''); 
      case '`'
         movefigure('max');
      case '~'
         movefigure('square');
      case '!'
         movefigure('15');
      case 'A'
         movefigure('fitA4');
      case 's'
         movefigure('stereo')
      case 'T'
         view(0,90);
      case 'F'
         view(0,0);
      case 'R'
         view(90,0);
      case 'G'
         view(3);
      case 'Q'
         % reserved for preventing an initialisation string from excecting more than once.
      case ' '
         % reserved for halting animation functions
      case {EnterKey}
         % reserved for resumption to functions pausing for figure pre-configuration with rtpan.
      case {BackspaceKey}
         %unassigned
      otherwise
         %display(sprintf('char = %c num = %d\n',cc,cc)); % for finding new keys
         fprintf('\007')      %print 'beep'
      end
      set(cf,'UserData',UserData);
      
      
   else  % if cc IS a command that effects continuous movement.
      
      
      if UserData.Conts == 1      %rtpan already active from another key press! --> return
         return
      end
      
      if UserData.ContsPending == 1  % turn on continuous mode if first key pressed after
         UserData.Conts = 1;         % continuous mode was requested.
         UserData.ContsPending = 0;
         set(cf,'UserData',UserData);                    %Update UserData
         %set(cf,'Interruptible','on');  % allow other key presses to set 'currentcharacter'.
      end
      
      loop=1;              % to cause a single cycle to excecute while not in continuous mode.
      while loop
         switch(cc)
         case {'6', '4'}                           %Pan along X axis
            for h=UserData.axishandles';
               XLim=get(h,'XLim');
               del=UserData.factor*(XLim(2)-XLim(1));
               if strcmp(cc,'4')
                  del = -del;
               end
               XLim = XLim + del;
               mid=mean(XLim);
               set(h,'XLim',XLim)
               CameraTarget=get(h,'CameraTarget');
               CameraPosition=get(h,'CameraPosition');
               CameraVector=CameraPosition-CameraTarget;
               
               NewTarget = [mid CameraTarget(2) CameraTarget(3)];
               NewPosition = NewTarget + CameraVector;
               set(h,'CameraPosition',NewPosition);
               set(h,'CameraTarget',NewTarget);
            end
         case {'8', '2'}                           %Pan along Y axis
            for h=UserData.axishandles';
               YLim=get(h,'YLim');
               del=UserData.factor*(YLim(2)-YLim(1));
               if strcmp(cc,'2')
                  del = -del;
               end
               YLim = YLim + del;
               mid=mean(YLim);
               set(h,'YLim',YLim)
               CameraTarget=get(h,'CameraTarget');
               CameraPosition=get(h,'CameraPosition');
               CameraVector=CameraPosition-CameraTarget;
               
               NewTarget = [CameraTarget(1) mid CameraTarget(3)];
               NewPosition = NewTarget + CameraVector;
               set(h,'CameraPosition',NewPosition);
               set(h,'CameraTarget',NewTarget);
            end
         case {'3', '1'}                           %Pan along Z axis
            for h=UserData.axishandles';
               ZLim=get(h,'ZLim');
               del=UserData.factor*(ZLim(2)-ZLim(1));
               if strcmp(cc,'1')
                  del = -del;
               end
               ZLim = ZLim + del;
               mid=mean(ZLim);
               set(h,'ZLim',ZLim)
               CameraTarget=get(h,'CameraTarget');
               CameraPosition=get(h,'CameraPosition');
               CameraVector=CameraPosition-CameraTarget;
               
               NewTarget = [CameraTarget(1) CameraTarget(2) mid];
               NewPosition = NewTarget + CameraVector;
               set(h,'CameraPosition',NewPosition);
               set(h,'CameraTarget',NewTarget);
            end
         case {'7', '9'}                            %Zoom Out, In
            for h=UserData.axishandles'
               CameraTarget=get(h,'CameraTarget');
               CameraPosition=get(h,'CameraPosition');
               CameraVector=CameraPosition-CameraTarget;
               if strcmp(cc,'7')
                  CameraPosition=CameraTarget+ (CameraVector./(1-UserData.factor));
               else
                  CameraPosition=CameraTarget+ (CameraVector.*(1-UserData.factor));
               end
               set(h,'CameraPosition',CameraPosition);
            end
         case {'[',']'}                            %Rotate Azimuth angle CW, ACW
            rad=UserData.factor*100*pi/180;
            if cc=='['
               rad=-rad;
            end
            if isempty(UserData.handles3D)   % no 3D plots --> OK to rotate 2D plots
               for h=UserData.handles2D'
                  CameraVector=get(h,'CameraPosition')-get(h,'CameraTarget');
                  CameraVector=CameraVector/norm(CameraVector);
                  CameraUpVector = get(h,'CameraUpVector');
                  CameraUpVector=CameraUpVector/norm(CameraUpVector);
                  CameraRightVector=cross(CameraVector,CameraUpVector);
                  NewUp=CameraUpVector*cos(rad)+CameraRightVector*sin(rad);
                  set(h,'CameraUpVector',NewUp);
               end
            else                             % rotate 3D axes only
               for h=UserData.handles3D'
                  CameraPosition = get(h,'CameraPosition')';
                  CameraPosition(4)=1;
                  NewPos=CameraPosition'*rotz(rad);
                  set(h,'CameraPosition',NewPos(1:3));
                  CameraUpVector= get(h,'CameraUpVector')';
                  CameraUpVector(4)=1;
                  NewUp=CameraUpVector'*rotz(rad);
                  set(h,'CameraUpVector',NewUp(1:3));
              end
            end
         case {'p',';'}                            %Rotate elevation angle UP, DOWN
            rad=UserData.factor*100*pi/180;
            if cc=='p'
               rad=-rad;
            end
            for h=UserData.handles3D'
               CameraTarget = get(h,'CameraTarget')';
               CameraPosition = get(h,'CameraPosition')';
               TargetPosition= CameraPosition-CameraTarget;
               CameraDistance=norm(TargetPosition);
               CameraForwardVector = -TargetPosition/CameraDistance;
               CameraUpVector = get(h,'CameraUpVector')';
               CameraRightVector = cross(CameraForwardVector,CameraUpVector);
               CameraRightVector = CameraRightVector / norm(CameraRightVector);
               CameraUpVector = cross(CameraRightVector,CameraForwardVector);
%               set(h,'CameraUpVector',CameraUpVector);
               
               T = [[CameraRightVector CameraForwardVector CameraUpVector CameraTarget];...
                     [0 0 0 1]];  %Target frame Transformation matrix
                                  %(Using same orientation as Camera frame)
               
               TC = trans(0,-CameraDistance,0);  %transformation from Target frame to Camera frmae

               NewC = T * rotx(rad) * TC;
               set(h,'CameraPosition',NewC(1:3,4)');
               set(h,'CameraUpVector',NewC(1:3,3)');
            end   
         case '5'                                  %Halt motion
            UserData.Conts=0;
            %set(cf,'Interruptible','off');
            set(cf,'UserData',UserData); 
         case '0'                                  %Set continuous motion pending
            UserData.Conts=0;
            UserData.ContsPending=1;
            %set(cf,'Interruptible','off');
            set(cf,'UserData',UserData); 
         case '.'
            UserData.Conts=0;                      %Halt motion and RESET 
            UserData.factor=0.04;
            set(cf,'UserData',UserData); 
            for h=UserData.axishandles';
               AxisData=get(h,'UserData');
               set(h,'XLim',AxisData.XLim);
               set(h,'YLim',AxisData.YLim);
               set(h,'ZLim',AxisData.ZLim);
               %set(h,'View',AxisData.AZEL);  %resets to auto: PositionMode, UpVectorMode, TargetMode(OK)
               %Note: CameraViewAngle should never change.
               set(h,'CameraPosition',AxisData.CameraPosition);
               set(h,'CameraTarget',AxisData.CameraTarget);
               set(h,'CameraUpVector',AxisData.CameraUpVector);
               set(h,'DataAspectRatio',AxisData.DataAspectRatio);
               set(h,'XGrid',AxisData.XGrid);
               set(h,'YGrid',AxisData.YGrid);
               set(h,'ZGrid',AxisData.ZGrid);
               set(h,'Visible',AxisData.Visible);
               set(h,'Projection',AxisData.Projection);
            end
         case 'n'
            UserData.Conts=0;                      %Halt motion and take NEW SETTINGS for RESET 
            set(cf,'UserData',UserData); 
            for h=UserData.axishandles';
               AxisData.XLim=get(h,'XLim');
               AxisData.YLim=get(h,'YLim');
               AxisData.ZLim=get(h,'ZLim');
               AxisData.CameraPosition=get(h,'CameraPosition');
               AxisData.CameraTarget=get(h,'CameraTarget');
               AxisData.CameraUpVector=get(h,'CameraUpVector');
               AxisData.DataAspectRatio=get(h,'DataAspectRatio');
               AxisData.XGrid=get(h,'XGrid');
               AxisData.YGrid=get(h,'YGrid');
               AxisData.ZGrid=get(h,'ZGrid');
               AxisData.Visible=get(h,'Visible');
               AxisData.Projection=get(h,'Projection');
               set(h,'UserData',AxisData);
            end
         case {DeleteKey}                          %close figure and exit
            close
            return
         end 
         ExternalyModifiedUserData=get(cf,'UserData');
         UserData.Conts=ExternalyModifiedUserData.Conts;   %Allow an external instance of rtpan 
         UserData.factor=ExternalyModifiedUserData.factor;     %to switch off continuous motion,
         UserData.ContsPending=ExternalyModifiedUserData.ContsPending;         % and set factor.
         set(cf,'UserData',UserData);   %Update UserData
         
         loop=UserData.Conts;
         if loop
            drawnow
         end
         
         if nargin == 1   % rtpan activated from command prompt
            if strcmp(cc,'0');
               charindex=findstr(cc,CommandString);
               if size(charindex,2)~=1 | ...   % if there is more than one '0' in CommandString
                     (charindex(1) ~= size(CommandString,2) - 1) % or if not second last command.
                  UserData.ContsPending=0;    % do not allow continuous motion pending
                  set(cf,'UserData',UserData);
               else % UserData.ContsPending set succesfully
                  cchar=get(cf,'currentcharacter');
                  if ~strcmp(cchar,'')
                     warning(['Continuous motion will be effected by the figure''s current' ... 
                           ' character:' cchar '.']); 
                  end
               end
            end
         end
         
         if loop
            oldcc=cc;
            cc=get(cf,'currentcharacter');              % prepare for next iteration
            if isempty(findstr(cc,ContinuousCommands))  % if none of these commands,
               cc=oldcc;  % continue old motion, and let the external rtpan instance handle 
            end           % the new key press.
         end  % if loop
      end  %while loop
   end  % if isempty(findstr(cc,ContinuousCommands))
end  % for cc=CommandString
