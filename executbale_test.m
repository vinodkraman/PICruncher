function varargout = executbale_test(varargin)
% EXECUTBALE_TEST MATLAB code for executbale_test.fig
%      EXECUTBALE_TEST, by itself, creates a new EXECUTBALE_TEST or raises the existing
%      singleton*.
%
%      H = EXECUTBALE_TEST returns the handle to a new EXECUTBALE_TEST or the handle to
%      the existing singleton*.
%
%      EXECUTBALE_TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXECUTBALE_TEST.M with the given input arguments.
%
%      EXECUTBALE_TEST('Property','Value',...) creates a new EXECUTBALE_TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before executbale_test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to executbale_test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help executbale_test

% Last Modified by GUIDE v2.5 09-Jul-2018 14:04:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @executbale_test_OpeningFcn, ...
                   'gui_OutputFcn',  @executbale_test_OutputFcn, ...
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


% --- Executes just before executbale_test is made visible.
function executbale_test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to executbale_test (see VARARGIN)
% ha = axes('Units','Pixels','Position',[50,60,200,185]); 
% handles.axes1 = ha;
% Choose default command line output for executbale_test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes executbale_test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = executbale_test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1:5 
    axes('Units','Pixels','Position',[50,60,200,185],'tag',strcat('hello',num2str(i))); 
end
allAxes = findall(0,'type','axes');
allAxes(1)
allAxes(2)
ax=findobj(gcf,'Tag','hello2');
axes(ax);

% figure(2)
% x = linspace(1,29);
% y = linspace(1,29);
% plot(x,y)
% plotedit 'off'

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
