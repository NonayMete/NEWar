function varargout = NUWAR_MRVG(varargin)
% NUWAR_MRVG MATLAB code for NUWAR_MRVG.fig
%      NUWAR_MRVG, by itself, creates a new NUWAR_MRVG or raises the existing
%      singleton*.
%
%      H = NUWAR_MRVG returns the handle to a new NUWAR_MRVG or the handle to
%      the existing singleton*.
%
%      NUWAR_MRVG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NUWAR_MRVG.M with the given input arguments.
%
%      NUWAR_MRVG('Property','Value',...) creates a new NUWAR_MRVG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NUWAR_MRVG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NUWAR_MRVG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NUWAR_MRVG

% Last Modified by GUIDE v2.5 20-Sep-2014 17:29:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NUWAR_MRVG_OpeningFcn, ...
                   'gui_OutputFcn',  @NUWAR_MRVG_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before NUWAR_MRVG is made visible.
function NUWAR_MRVG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NUWAR_MRVG (see VARARGIN)

% Choose default command line output for NUWAR_MRVG
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NUWAR_MRVG wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NUWAR_MRVG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_run.
function [timepos,timetheta]= pushbutton_run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%GUI-JointSpace Calculation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Enosh Lam - 20753711          
% 2/08/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Get Values From buttons/dropdowns/edittexts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Data from panel-'1.Plot Control'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Dropdown_1       [Num]
Drawvar1=get(handles.popupmenu_var1drawmode,'Value');
  %Radiobutton_1    [Num]
Drawvar2=get(handles.radiobutton_var2drawmode,'Value');
  %Dropdown_2       [Num]
Drawvar3=get(handles.popupmenu_var5drawmode,'Value');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Data from panel '2.Trajectory Type'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Dropdown_1     [Num]
ramptype=get(handles.popupmenu_ramptime,'Value');
    %Dropdown_2     [Num]
tragpro=get(handles.popupmenu_trajprofile,'Value');
    %Edittext_1     [String]
mvalue=get(handles.edit_m,'String');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Data from panel '3.Trajectory Time Control'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Edittext_1     [String]
starttime=get(handles.edit_startt,'String');
    %Edittext_2     [String]
samptime=get(handles.edit_sampt,'String');
    %Edittext_3     [String]
endtime=get(handles.edit_endt,'String');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Data from panel '4.TaskSpace Trajectory'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Edittext_1-3     [String]
startpt1=get(handles.edit_startpt1,'String');
startpt2=get(handles.edit_startpt2,'String');
startpt3=get(handles.edit_startpt3,'String');
    %Edittext_3-6     [String]
midpt1=get(handles.edit_midpt1,'String');
midpt2=get(handles.edit_midpt2,'String');
midpt3=get(handles.edit_midpt3,'String');
    %Edittext_6-9     [String]
endpt1=get(handles.edit_endpt1,'String');
endpt2=get(handles.edit_endpt2,'String');
endpt3=get(handles.edit_endpt3,'String');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Data from panel '6. Export motion reference in PMAC Motion Prog Format'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Edittext_1     [String]
exportdir=get(handles.edit_dir,'String');
    %Edittext_2     [String]
filename=get(handles.edit_outputname,'String');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Data from panel 'A.Motor Data'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Edittext_1     [String]
kt=get(handles.edit_motorconstant,'String');
    %Edittext_2     [String]
Ohms=get(handles.edit_resistance,'String');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Creating Drawmode array for panel '1.Plot Control'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Drawmode array - LePage 1998
% -------------------------------------------------------------------------
% drawmode = [{0,1,2,3}, {0,1}, {0,1}, {0,1}, {1,2,4}, {0,1}]
%
% where:
% param1 = 0 means don't plot
%        = 1 means plot wire frame
%        = 2 means plot wire frame with accurate representation of forearms
%        = 3 means plot cylinder representation
% param2 = 1 means also plot reference frames
% param3 = 1 means initialise the display
% param4 = 1 means writing to GUI
% param5 = the number of plots generated (1 for single, 2 for stereo, 4 for top,front,right,3D)
% param6 = 1 means create a movie for playback
%          NOTE: a movie cannot be created for multiple plots
%
% The defaults for this parameter is set by the function CheckDrawMode.m
% -------------------------------------------------------------------------
% Drawmode=[dv1,dv2,1,0,dv3,0]
%1st param of drawmode array

%Assign parameter values to each case of the dropdown menu
    switch Drawvar1
        case 1%'No Plot'
            dv1=0;
        case 2%'Draw W.F'
            dv1=1;
        case 3%'Draw W.F & F.A'
            dv1=2;
        case 4%'Draw All'
            dv1=3;
    end
%2nd param of drawmode array

%obtain boolean value from radiobutton (1 or 0 )
     dv2=Drawvar2;
%5th param of drawmode array

%Assign parameter values to each case of the dropdown menu
    switch Drawvar3
        case 1%'1'
            dv3=1;
        case 2%'2'
            dv3=2;
        case 3%'4'
            dv3=4;
    end

%Writing the Drawmode array
drawmode=[dv1,dv2,1,0,dv3,0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Obtain inputs required for motion trajectory
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set Acceleration profile
% Use switch to select appropriate acceleration profile
    switch ramptype
        case 1%'SineOnRamp'
            TimeRampType='SineonRamp';
        case 2%'Parabolic'
            TimeRampType='ParabolicTime';
        case 3%'LinearT'
            TimeRampType='LinearTime';
        case 4%'PolyT'
            TimeRampType='PolyTime';
        case 5%'ConstantJerk'
            TimeRampType='SineOnRamp';
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set MaxAcceleration to MinAcceleration ratio
mval=str2double(mvalue);
%Force mval to be a number
    if mval==isempty(mval)
        mval=1;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set Time of Trajectory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Obtain start time of motion
startt=str2double(starttime);
%Set default value of start time to 0.00
%Force start time to be >0 and a number
    if startt==isempty(startt)
        startt=0.00;
    end
    if startt<0
        startt=0.00;
    end
%Obtain sampling time of motion
sampt=str2double(samptime);
%Set default value of samp time to 0.05
%Force samp time to be >0 and a number
    if sampt==isempty(sampt)
        sampt=0.05;
    end
    if sampt<0
        sampt=0.05;
    end
%Obtain end time of motion
endt=str2double(endtime);
%Set default value of end time to 1+[start time]
%Force end time to be > [start time] and a number
    if endt==isempty(endt);
        endt=startt+1;
    end
    if endt<startt
        endt=startt+1;
    end

% Display any changes to input values on edit text box
disstartt=num2str(startt);
dissampt=num2str(sampt);
disendt=num2str(endt);

set(handles.edit_startt,'String',disstartt);
set(handles.edit_sampt,'String',dissampt);
set(handles.edit_endt,'String',disendt);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set Trajectory points in TaskSpace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
startp1=str2double(startpt1); % Get x start
startp2=str2double(startpt2); % Get y  ''
startp3=str2double(startpt3); % Get z  ''

%Test to make sure points are not char
    if startp1==isempty(startp1)
        startp1=0;
    end
    if startp2==isempty(startp2)
        startp2=0;
    end
    if startp3==isempty(startp3)
        startp3=0;
    end

%update edittext if any changes are made
dispstart1=num2str(startp1);
dispstart2=num2str(startp2);
dispstart3=num2str(startp3);

set(handles.edit_startpt1,'String',dispstart1);
set(handles.edit_startpt2,'String',dispstart2);
set(handles.edit_startpt3,'String',dispstart3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

midp1=str2double(midpt1); % Get x mid
midp2=str2double(midpt2); % Get y ''
midp3=str2double(midpt3); % Get z ''

%Test to make sure points are not char
    if midp1==isempty(midp1)
        midp1=0;
    end
    if midp2==isempty(midp2)
        midp2=0;
    end
    if midp3==isempty(midp3)
        midp3=0;
    end

%update edittext if any changes are made
dispmidp1=num2str(midp1);
dispmidp2=num2str(midp2);
dispmidp3=num2str(midp3);

set(handles.edit_midpt1,'String',dispmidp1);
set(handles.edit_midpt2,'String',dispmidp2);
set(handles.edit_midpt3,'String',dispmidp3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

endp1=str2double(endpt1); % Get x end
endp2=str2double(endpt2); % Get y ''
endp3=str2double(endpt3); % Get z ''

%Test to make sure points are not char
    if endp1==isempty(endp1)
        endp1=0;
    end
    if endp2==isempty(endp2)
        endp2=0;
    end
    if endp3==isempty(endp3)
        endp3=0;
    end
    
%update edittext if any changes are made

dispendp1=num2str(endp1);
dispendp2=num2str(endp2);
dispendp3=num2str(endp3);

set(handles.edit_endpt1,'String',dispendp1);
set(handles.edit_endpt2,'String',dispendp2);
set(handles.edit_endpt3,'String',dispendp3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Creation of start/mid/end point matrix
startpoint=[startp1;startp2;startp3];
midpoint=[midp1;midp2;midp3];
endpoint=[endp1;endp2;endp3];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Selecting motion profile and running main functions to generate 
% joint space trajectory q(t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% select motion profile and run to generate jointspace trajectory

    switch tragpro
        case 1%Ellipse
            [timetheta,timepos]=Ellipse(drawmode,TimeRampType,startt,endt,sampt,startpoint,endpoint,midpoint,mval,-35.26,60,0);
        
        case 2%Linear
            [timetheta,timepos]=Linear(drawmode,TimeRampType,startt,endt,sampt,startpoint,endpoint,mval,-35.26,60,0);

        case 3%Natural
            [timetheta,timepos]=Natural(drawmode,TimeRampType,startt,endt,sampt,startpoint,endpoint,mval,-35.26,60);

    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solving INVERSE Dynamics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Q,lamda]=IDHtraj(timepos,timetheta,-35.26,60,5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%obtain velocity term
step = timepos(2,1)-timepos(1,1);
samp = size(timepos,1);
[q, dq] = q_dq(timepos, timetheta, step, samp,5);
%obtain rate of change of torque with time term
[dQ]=matrixdiff(Q, step, samp, 5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Software Limit Test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
testtheta=timetheta(:,2:4);
if max(max(testtheta))>=78
    fprintf('\n Software Limit Reach > 78 \n');
end
if min(min(testtheta))<=-14
    fprintf('\n Software Limit Reach < -14 \n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converting Torques to Voltage Value Bits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ktc=str2double(kt);
ohmsc=str2double(Ohms);
I=Q/ktc;
V=I*(0.5);

DAC= ((32768/10)*V);

Ix30 = 2000;
Ix08 = 96;

Fe=DAC; 
%(DAC)/((2^-19)*(Ix30)*(Ix08));
QNm= Q;
Q = Fe;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Formating q for pmac
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%hatchet job :)

timetheta2=horzcat(timetheta(:,1),dq(:,4:6));
pvt=[];
for i=2:1:4
    pvt=horzcat(pvt,timetheta(:,i),timetheta2(:,i));
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Formating Q for FFT PVT Motion Program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timetorques=horzcat(timetheta(:,1),Q);
PVTQ=[];
for cts=1:3%%%
    PVTQ=horzcat(PVTQ,Q(:,cts),dQ(:,cts));
end
FFTPVT=horzcat(pvt,PVTQ);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Formating Q for FFT Spline1 Motion Program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FFTS1Q=[];
for cts=1:3%%%
    FFTS1Q=horzcat(FFTS1Q,Q(:,cts));
end
FFTS1=horzcat(timetheta(:,2:4),FFTS1Q);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
assignin('base','timepos',timepos);
assignin('base','timepos0',timepos);
assignin('base','timetheta',timetheta);
assignin('base','timetheta0',timetheta);
assignin('base','q',q);
assignin('base','dq',dq);
assignin('base','Q',Q);
assignin('base','lamda',lamda);
assignin('base','pvt',pvt);
assignin('base','FFTPVT',FFTPVT);
assignin('base','FFTS1',FFTS1);
assignin('base','QNm',QNm);
assignin('base','DAC',DAC);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output Matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% switch unittype
%     case 1%deg&Nm
%         %format to deg
%     case 2%rad&Nm
%         % normal
%     case 3%ct&Nm
%         %format to cts
% end
% Function [Q,lamda]=IDHtraj(timepos, timetheta,alpha, beta, diffpoints)

        


function edit_dir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dir as text
%        str2double(get(hObject,'String')) returns contents of edit_dir as a double


% --- Executes during object creation, after setting all properties.
function edit_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_splineexport.
function pushbutton_splineexport_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_splineexport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get values from panel 6.Export motion reference in PMAC Motion Prog
% Format
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dirstring=get(handles.edit_dir,'String');
filestring=get(handles.edit_outputname,'String');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get value from workspace
%
timetheta=evalin('base','timetheta');
dest=[dirstring,filestring,'.txt'];
[data]=exportPMACprog(timetheta,dest);
% function [data] = exportPMACprog(timetheta, dest)


% --- Executes on button press in pushbutton_pvtexport.
function pushbutton_pvtexport_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pvtexport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get values from panel 6.Export motion reference in PMAC Motion Prog
% Format
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dirstring=get(handles.edit_getpvtdir,'String');
filestring=get(handles.edit_outputname,'String');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get value from workspace
%
pvt=evalin('base','pvt');
dest=[dirstring,filestring,'.txt'];
[data]=exportPMACprogPVT(pvt,dest);


function edit_outputname_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outputname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_outputname as text
%        str2double(get(hObject,'String')) returns contents of edit_outputname as a double


% --- Executes during object creation, after setting all properties.
function edit_outputname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outputname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_startpt1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_startpt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_startpt1 as text
%        str2double(get(hObject,'String')) returns contents of edit_startpt1 as a double


% --- Executes during object creation, after setting all properties.
function edit_startpt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_startpt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_endpt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_endpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_endpt as text
%        str2double(get(hObject,'String')) returns contents of edit_endpt as a double


% --- Executes during object creation, after setting all properties.
function edit_endpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_endpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_midpt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_midpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_midpt as text
%        str2double(get(hObject,'String')) returns contents of edit_midpt as a double


% --- Executes during object creation, after setting all properties.
function edit_midpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_midpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_startt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_startt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_startt as text
%        str2double(get(hObject,'String')) returns contents of edit_startt as a double


% --- Executes during object creation, after setting all properties.
function edit_startt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_startt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_endt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_endt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_endt as text
%        str2double(get(hObject,'String')) returns contents of edit_endt as a double


% --- Executes during object creation, after setting all properties.
function edit_endt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_endt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sampt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sampt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sampt as text
%        str2double(get(hObject,'String')) returns contents of edit_sampt as a double


% --- Executes during object creation, after setting all properties.
function edit_sampt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sampt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_ramptime.
function popupmenu_ramptime_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ramptime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ramptime contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ramptime


% --- Executes during object creation, after setting all properties.
function popupmenu_ramptime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ramptime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_trajprofile.
function popupmenu_trajprofile_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_trajprofile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_trajprofile contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_trajprofile


% --- Executes during object creation, after setting all properties.
function popupmenu_trajprofile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_trajprofile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_m_Callback(hObject, eventdata, handles)
% hObject    handle to edit_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_m as text
%        str2double(get(hObject,'String')) returns contents of edit_m as a double


% --- Executes during object creation, after setting all properties.
function edit_m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_var1drawmode.
function popupmenu_var1drawmode_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_var1drawmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_var1drawmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_var1drawmode


% --- Executes during object creation, after setting all properties.
function popupmenu_var1drawmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_var1drawmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_var2drawmode.
function radiobutton_var2drawmode_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_var2drawmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_var2drawmode



function edit_var5drawmode_Callback(hObject, eventdata, handles)
% hObject    handle to edit_var5drawmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_var5drawmode as text
%        str2double(get(hObject,'String')) returns contents of edit_var5drawmode as a double


% --- Executes during object creation, after setting all properties.
function edit_var5drawmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_var5drawmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_startpt2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_startpt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_startpt2 as text
%        str2double(get(hObject,'String')) returns contents of edit_startpt2 as a double


% --- Executes during object creation, after setting all properties.
function edit_startpt2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_startpt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_startpt3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_startpt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_startpt3 as text
%        str2double(get(hObject,'String')) returns contents of edit_startpt3 as a double


% --- Executes during object creation, after setting all properties.
function edit_startpt3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_startpt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_midpt1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_midpt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_midpt1 as text
%        str2double(get(hObject,'String')) returns contents of edit_midpt1 as a double


% --- Executes during object creation, after setting all properties.
function edit_midpt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_midpt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_midpt2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_midpt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_midpt2 as text
%        str2double(get(hObject,'String')) returns contents of edit_midpt2 as a double


% --- Executes during object creation, after setting all properties.
function edit_midpt2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_midpt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_midpt3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_midpt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_midpt3 as text
%        str2double(get(hObject,'String')) returns contents of edit_midpt3 as a double


% --- Executes during object creation, after setting all properties.
function edit_midpt3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_midpt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_endpt1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_endpt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_endpt1 as text
%        str2double(get(hObject,'String')) returns contents of edit_endpt1 as a double


% --- Executes during object creation, after setting all properties.
function edit_endpt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_endpt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_endpt2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_endpt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_endpt2 as text
%        str2double(get(hObject,'String')) returns contents of edit_endpt2 as a double


% --- Executes during object creation, after setting all properties.
function edit_endpt2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_endpt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_endpt3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_endpt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_endpt3 as text
%        str2double(get(hObject,'String')) returns contents of edit_endpt3 as a double


% --- Executes during object creation, after setting all properties.
function edit_endpt3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_endpt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_units.
function popupmenu_units_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_units (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_units contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_units


% --- Executes during object creation, after setting all properties.
function popupmenu_units_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_units (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_FFTS1.
function pushbutton_FFTS1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FFTS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get values from panel 6.Export motion reference in PMAC Motion Prog
% Format
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dirstring=get(handles.edit_getFFTS1dir,'String');
filestring=get(handles.edit_outputname,'String');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get value from workspace
%
FFTS1=evalin('base','FFTS1');
dest=[dirstring,filestring,'.txt'];
[data]=FFTS1exportPMACprog(FFTS1,dest);

% --- Executes on selection change in popupmenu_var5drawmode.
function popupmenu_var5drawmode_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_var5drawmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_var5drawmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_var5drawmode


% --- Executes during object creation, after setting all properties.
function popupmenu_var5drawmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_var5drawmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_getpvtdir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_getpvtdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_getpvtdir as text
%        str2double(get(hObject,'String')) returns contents of edit_getpvtdir as a double


% --- Executes during object creation, after setting all properties.
function edit_getpvtdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_getpvtdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_getFFTS1dir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_getFFTS1dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_getFFTS1dir as text
%        str2double(get(hObject,'String')) returns contents of edit_getFFTS1dir as a double


% --- Executes during object creation, after setting all properties.
function edit_getFFTS1dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_getFFTS1dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_motorconstant_Callback(hObject, eventdata, handles)
% hObject    handle to edit_motorconstant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_motorconstant as text
%        str2double(get(hObject,'String')) returns contents of edit_motorconstant as a double


% --- Executes during object creation, after setting all properties.
function edit_motorconstant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_motorconstant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_helpinfo.
function pushbutton_helpinfo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_helpinfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Opens block explaining the program
figure
imshow('help.bmp')
figure
imshow('help.bmp')


% --- Executes on button press in pushbutton_A2trajcorrection.
function pushbutton_A2trajcorrection_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_A2trajcorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Feed Calculated JS traject into SPLINE1 interpolation algorithm...
% Outputs actual commanded motion

timetheta=evalin('base','timetheta');
FFTS1=evalin('base','FFTS1');

a=size(timetheta);
b=size(FFTS1);
a=a(1);
b=b(1);
x=timetheta(:,2:4);
y=FFTS1;
corrective=[];
correctivefft=[];
for i=2:1:(a-1)
    fiveptcorrection = (-x((i-1),:)+8*x(i,:)-x((i+1),:))/6;
    fiveptcorrectionfft= (-y((i-1),:)+8*y(i,:)-y((i+1),:))/6; 
    corrective=[corrective;fiveptcorrection];
    correctivefft=[correctivefft;fiveptcorrectionfft];
end

final=[x(1,:);corrective;x(a,:)];
finalfft=[y(1,:);correctivefft;y(b,:)];
final= horzcat(timetheta(:,1),final);
assignin('base','timetheta',final);
assignin('base','FFTS1',finalfft);


% --- Executes on button press in pushbutton_A3JSdev.
function pushbutton_A3JSdev_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_A3JSdev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Shows the difference between jointspace of intial planned motion and the
% motion actually processed. 

%(Matrix(n-1)+4Matrix(n)+Matrix(n+1))/6
timetheta=evalin('base','timetheta');
timepos=evalin('base','timepos');
timetheta0=evalin('base','timetheta0');
timepos0=evalin('base','timepos0');

n=size(timetheta(:,2:4));
n=n(1);
mtr1th=timetheta(:,2);
mtr2th=timetheta(:,3);
mtr3th=timetheta(:,4);
mtr1p=timepos(:,2);
mtr2p=timepos(:,3);
mtr3p=timepos(:,4);

wp1t=[];
wp2t=[];
wp3t=[];
wp1p=[];
wp2p=[];
wp3p=[];
for ct = 2:n-1
    wp1t=[wp1t;(mtr1th(ct-1)+(4*mtr1th(ct))+mtr1th(ct+1))/6];
    wp2t=[wp2t;(mtr2th(ct-1)+(4*mtr2th(ct))+mtr2th(ct+1))/6];
    wp3t=[wp3t;(mtr3th(ct-1)+(4*mtr3th(ct))+mtr3th(ct+1))/6];
    wp1p=[wp1p;(mtr1p(ct-1)+(4*mtr1p(ct))+mtr1p(ct+1))/6];
    wp2p=[wp2p;(mtr2p(ct-1)+(4*mtr2p(ct))+mtr2p(ct+1))/6];
    wp3p=[wp3p;(mtr3p(ct-1)+(4*mtr3p(ct))+mtr3p(ct+1))/6];
end

spline1th=[wp1t,wp2t,wp3t];
spline1p=[wp1p,wp2p,wp3p];

splineth1=timetheta(1,2:4);
splinep1=timepos(1,2:4);
splineth2=timetheta(n,2:4);
splinep2=timepos(n,2:4);

spline1th=[splineth1;spline1th;splineth2];
spline1th=[timetheta(:,1),spline1th];
spline1p=[splinep1;spline1p;splinep2];
spline1p=[timetheta(:,1),spline1p];

dev=timetheta0-spline1th;
dev=[timetheta0(:,1),dev(:,2:4)];

assignin('base','spline1p',spline1p);
assignin('base','spline1th',spline1th);
assignin('base','dev',dev);
figure
plot(dev(:,1),dev(:,2),dev(:,1),dev(:,3),dev(:,1),dev(:,4));
title('PMAC SPLINE1 Deviations from planned trajectory');
ylabel('Angular difference(Deg)');
xlabel('Time (Sec)');
legend('Motor1','Motor2','Motor3');
% --- Executes on button press in pushbutton_plotdacinput.
function pushbutton_plotdacinput_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plotdacinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Plot the converted torque to DAC input compenstation voltage graph
timetheta=evalin('base','timetheta');
QNm=evalin('base','QNm');
DAC=evalin('base','DAC');
timeDAC=[timetheta(:,1),DAC];
timeQNm=[timetheta(:,1),QNm];
figure
plot(timeDAC(:,1),timeDAC(:,2),timeDAC(:,1),timeDAC(:,3),timeDAC(:,1),timeDAC(:,4));
title('PMAC Digital to Analogue Bits for Torque Control');
ylabel('Voltage DAC (Bits)');
xlabel('Time (Sec)');
legend('Motor1','Motor2','Motor3');
figure
plot(timeQNm(:,1),timeQNm(:,2),timeQNm(:,1),timeQNm(:,3),timeQNm(:,1),timeQNm(:,4));
title('Motor Torques required for Planned trajectory');
ylabel('Motor Torque(Nm)');
xlabel('Time (Sec)');
legend('Motor1','Motor2','Motor3');
% --- Executes on button press in pushbutton_b1draw.
function pushbutton_b1draw_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_b1draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% generate ... user define custom trajectory.



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_openwin.
function pushbutton_openwin_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_openwin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% OPEN Drawing Window (for custom user trajectory profiles)


% --- Executes on button press in pushbutton_FFTPVT.
function pushbutton_FFTPVT_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FFTPVT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get values from panel 6.Export motion reference in PMAC Motion Prog
% Format
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dirstring=get(handles.edit_getFFTPVTdir,'String');
filestring=get(handles.edit_outputname,'String');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get value from workspace
%
FFTPVT=evalin('base','FFTPVT');
dest=[dirstring,filestring,'.txt'];
[data]=FFTPVTexportPMACprog(FFTPVT,dest);


function edit_getFFTPVTdir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_getFFTPVTdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_getFFTPVTdir as text
%        str2double(get(hObject,'String')) returns contents of edit_getFFTPVTdir as a double


% --- Executes during object creation, after setting all properties.
function edit_getFFTPVTdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_getFFTPVTdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_resistance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_resistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_resistance as text
%        str2double(get(hObject,'String')) returns contents of edit_resistance as a double


% --- Executes during object creation, after setting all properties.
function edit_resistance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_resistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
