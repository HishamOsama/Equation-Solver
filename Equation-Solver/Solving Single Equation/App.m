function varargout = App(varargin)
% APP M-file for app.fig
%      APP, by itself, creates a new APP or raises the existing
%      singleton*.
%
%      H = APP returns the handle to a new APP or the handle to
%      the existing singleton*.
%
%      APP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APP.M with the given input arguments.
%
%      APP('Property','Value',...) creates a new APP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before app_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to app_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% Begin initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @App_OpeningFcn, ...
    'gui_OutputFcn',  @App_OutputFcn, ...
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

% --- Executes just before app is made visible.
function App_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to app (see VARARGIN)

% Choose default command line output for app
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Clearing the table data
set(handles.uitable1, 'Data', []);
set(handles.uitable2, 'Data', []);

% Displaying the initial appropriate textfields to the user
setAllFields(handles,'off');
Methods.BisectionMethod.setFields(handles,'on');

% --- Outputs from this function are returned to the command line.
function varargout = App_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in methodsMenu.
function methodsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to methodsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clearing the previous textfields
setAllFields(handles,'off');

% Showing the appropriate textfields to the user
contents = cellstr(get(hObject,'String'));
method = contents{get(hObject,'Value')};

switch method
    case 'Bisection'
        Methods.BisectionMethod.setFields(handles,'on');
    case 'Bisection (Steps)'
        Methods.BisectionMethodSteps.setFields(handles,'on');
    case 'False Position'
        Methods.FalsePositionMethod.setFields(handles,'on');
    case 'Fixed Point'
        Methods.FixedPointMethod.setFields(handles,'on');
    case 'Newton Raphson'
        Methods.NewtonRaphsonMethod.setFields(handles,'on');
    case 'Secant'
        Methods.SecantMethod.setFields(handles,'on');
    case 'Birge Vieta'
        Methods.BirgeVietaMethod.setFields(handles,'on');
    case 'All'
        setAllFields(handles,'on');
    case 'General Method'
end

% --- Executes on button press in solveButton.
function solveButton_Callback(hObject, eventdata, handles)
% hObject    handle to solveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Reset the table data
set(handles.uitable1, 'Data', cell(size(0)));
set(handles.uitable2, 'Data', cell(size(0)));
Utils.StringParser.checkSymbolicFunction(handles);
% Calling the appropriate method
contents = get(handles.methodsMenu,'String');
method = contents{get(handles.methodsMenu,'Value')};
switch method
    case 'Bisection'
        [range,stringEquation] = Methods.MethodsUtils.Solver.solveBisection(handles);
        Utils.GraphPlotter.plotCuvre(handles,stringEquation,range);
    case 'Bisection (Steps)'
        hold(handles.axes,'off');
        cla(handles.axes2,'reset');
        Methods.MethodsUtils.Solver.solveBisectionSteps(hObject,handles);
    case 'False Position'
        [range,stringEquation] = Methods.MethodsUtils.Solver.solveRegular(handles);
        Utils.GraphPlotter.plotCuvre(handles,stringEquation,range);
    case 'Fixed Point'
        [range,stringEquation] = Methods.MethodsUtils.Solver.solveFixed(handles);
        Utils.GraphPlotter.plotShiftedCurve(handles,stringEquation,range);
    case 'Newton Raphson'
        [range,stringEquation] = Methods.MethodsUtils.Solver.solveNewton(handles);
        Utils.GraphPlotter.plotTangentCurve(handles,stringEquation,range);
    case 'Secant'
        [range,stringEquation] = Methods.MethodsUtils.Solver.solveSecant(handles);
        Utils.GraphPlotter.plotCuvre(handles,stringEquation,range);
    case 'Birge Vieta'
        [range,stringEquation] = Methods.MethodsUtils.Solver.solveVieta(handles);
        Utils.GraphPlotter.plotCuvre(handles,stringEquation,range);
    case 'All'
        solveAll(hObject, eventdata, handles);
    case 'General Method'
        [range,stringEquation] = Methods.MethodsUtils.Solver.solveGeneral(handles);
        Utils.GraphPlotter.plotCuvre(handles,stringEquation,range);
end
writeFile(handles)

% --- Executes on button press in stepButton.
function stepButton_Callback(hObject, eventdata, handles)
% hObject    handle to stepButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.bisectionMethodSteps = handles.bisectionMethodSteps.solve(handles);
guidata(hObject,handles);

% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clearing the previous textfields
setAllFields(handles,'off');

startingLine = 3;

% Fetch Data from the Equations File
fid = fopen('+Files/Input.txt');
fileData = {};
while ~feof(fid)
    tline = fgetl(fid);
    fileData{end+1,1} = tline;
end

% Load the equation
set(handles.equation,'string',fileData{2});

% Send Data to the appropriate parameters
method = fileData{1};
switch method
    case 'Bisection'
        Methods.BisectionMethod.loadParameters(handles,fileData,startingLine);
        Methods.BisectionMethod.setFields(handles,'on');
    case 'Bisection (Steps)'
        Methods.BisectionMethodSteps.loadParameters(handles,fileData,startingLine);
        Methods.BisectionMethodSteps.setFields(handles,'on');
    case 'False Position'
        Methods.FalsePositionMethod.loadParameters(handles,fileData,startingLine);
         Methods.FalsePositionMethod.setFields(handles,'on');
    case 'Fixed Point'
        Methods.FixedPointMethod.loadParameters(handles,fileData,startingLine);
        Methods.FixedPointMethod.setFields(handles,'on');
    case 'Newton Raphson'
        Methods.NewtonRaphsonMethod.loadParameters(handles,fileData,startingLine);
        Methods.NewtonRaphsonMethod.setFields(handles,'on');
    case 'Secant'
        Methods.SecantMethod.loadParameters(handles,fileData,startingLine);
        Methods.SecantMethod.setFields(handles,'on');
    case 'Birge Vieta'
        Methods.BirgeVietaMethod.loadParameters(handles,fileData,startingLine);
        Methods.BirgeVietaMethod.setFields(handles,'on');
    case 'All'
        LoadAll(handles,fileData)
        set(handles.methodsMenu,'Value',8);
        setAllFields(handles,'on');
    case 'General Method'
end

function writeFile(handles)
tableData = get(handles.uitable1,'data');
fid = fopen('+Files/Output.txt', 'w');
disp(length(tableData))
try
    for i = 1:length(tableData)
        fprintf(fid, '%s\t', tableData{i,1:end-1});
        fprintf(fid, '%s\n', tableData{i,end});
    end
catch ME
    disp(ME.identifier);
end
fclose(fid);

function solveAll(hObject, eventdata, handles)
hold(handles.axes,'off');
cla(handles.axes2,'reset');
Methods.MethodsUtils.Solver.solveBisection(handles);
Methods.MethodsUtils.Solver.solveRegular(handles);
Methods.MethodsUtils.Solver.solveFixed(handles);
Methods.MethodsUtils.Solver.solveNewton(handles);
Methods.MethodsUtils.Solver.solveSecant(handles);
Methods.MethodsUtils.Solver.solveVieta(handles);

function LoadAll(handles,fileData)
line = 3;
line = line + Methods.BisectionMethod.loadParameters(handles,fileData,line);
line = line + Methods.FalsePositionMethod.loadParameters(handles,fileData,line);
line = line + Methods.FixedPointMethod.loadParameters(handles,fileData,line);
line = line + Methods.NewtonRaphsonMethod.loadParameters(handles,fileData,line);
line = line + Methods.SecantMethod.loadParameters(handles,fileData,line);
Methods.BirgeVietaMethod.loadParameters(handles,fileData,line);

function setAllFields(handles,mode)
set(handles.stepButton,'Visible','off');
Methods.BisectionMethod.setFields(handles,mode);
Methods.FalsePositionMethod.setFields(handles,mode);
Methods.FixedPointMethod.setFields(handles,mode);
Methods.NewtonRaphsonMethod.setFields(handles,mode);
Methods.SecantMethod.setFields(handles,mode);
Methods.BirgeVietaMethod.setFields(handles,mode);

% Matlab Functions
function axes_CreateFcn(hObject, eventdata, handles)

function solveButton_CreateFcn(hObject, eventdata, handles)

function equation_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function text1_CreateFcn(hObject, eventdata, handles)

function methodsMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xBisection_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xLBisection_CreateFcn(hObject, eventdata, handles)

function x1LBisection_CreateFcn(hObject, eventdata, handles)

function x1Bisection_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxBisection_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxLBisection_CreateFcn(hObject, eventdata, handles)

function eLBisection_CreateFcn(hObject, eventdata, handles)

function uitable1_CreateFcn(hObject, eventdata, handles)

function pushbutton2_CreateFcn(hObject, eventdata, handles)

function xRegular_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xLRegular_CreateFcn(hObject, eventdata, handles)

function x1LRegular_CreateFcn(hObject, eventdata, handles)

function x1Regular_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxRegular_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function eRegular_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxLRegular_CreateFcn(hObject, eventdata, handles)

function eLRegular_CreateFcn(hObject, eventdata, handles)

function xFixed_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xLFixed_CreateFcn(hObject, eventdata, handles)

function maxFixed_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function eFixed_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxLFixed_CreateFcn(hObject, eventdata, handles)

function eLFixed_CreateFcn(hObject, eventdata, handles)

function xNewton_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xLNewton_CreateFcn(hObject, eventdata, handles)

function maxNewton_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function eNewton_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxLNewton_CreateFcn(hObject, eventdata, handles)

function eLNewton_CreateFcn(hObject, eventdata, handles)

function xSecant_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xLSecant_CreateFcn(hObject, eventdata, handles)

function maxSecant_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function eSecant_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxLSecant_CreateFcn(hObject, eventdata, handles)

function eLSecant_CreateFcn(hObject, eventdata, handles)

function xVieta_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function xLVieta_CreateFcn(hObject, eventdata, handles)

function maxVieta_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function eVieta_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function maxLVieta_CreateFcn(hObject, eventdata, handles)

function eLVieta_CreateFcn(hObject, eventdata, handles)

function eBisection_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function equation_Callback(hObject, eventdata, handles)

function xBisection_Callback(hObject, eventdata, handles)

function x1Bisection_Callback(hObject, eventdata, handles)

function maxBisection_Callback(hObject, eventdata, handles)

function xRegular_Callback(hObject, eventdata, handles)

function x1Regular_Callback(hObject, eventdata, handles)

function maxRegular_Callback(hObject, eventdata, handles)

function eRegular_Callback(hObject, eventdata, handles)

function xFixed_Callback(hObject, eventdata, handles)

function maxFixed_Callback(hObject, eventdata, handles)

function eFixed_Callback(hObject, eventdata, handles)

function xNewton_Callback(hObject, eventdata, handles)

function maxNewton_Callback(hObject, eventdata, handles)

function eNewton_Callback(hObject, eventdata, handles)

function xSecant_Callback(hObject, eventdata, handles)

function maxSecant_Callback(hObject, eventdata, handles)

function eSecant_Callback(hObject, eventdata, handles)

function xVieta_Callback(hObject, eventdata, handles)

function maxVieta_Callback(hObject, eventdata, handles)

function eVieta_Callback(hObject, eventdata, handles)

function eBisection_Callback(hObject, eventdata, handles)

function x1Secant_Callback(hObject, eventdata, handles)

function x1Secant_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
