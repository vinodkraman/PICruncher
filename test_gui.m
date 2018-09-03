function varargout = test_gui(varargin)
% TEST_GUI MATLAB code for test_gui.fig
%      TEST_GUI, by itself, creates a new TEST_GUI or raises the existing
%      singleton*.
%
%      H = TEST_GUI returns the handle to a new TEST_GUI or the handle to
%      the existing singleton*.
%
%      TEST_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_GUI.M with the given input arguments.
%
%      TEST_GUI('Property','Value',...) creates a npushew TEST_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_gui

% Last Modified by GUIDE v2.5 05-Aug-2018 11:02:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @test_gui_OpeningFcn, ...
    'gui_OutputFcn',  @test_gui_OutputFcn, ...
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


% --- Executes just before test_gui is made visible.
function test_gui_OpeningFcn(hObject, eventdata, handles, varargin)

%----------------------Initialize Data Structures-------------------------%
warning off;
%Initialize editable bounds for view data
handles.uneditable_dimension_bounds = [];

%Initialize location array
location_labels = {};
handles.location_labels = location_labels;

%Initlalize Campaign_Lot# Maps
campaign_lot_map = containers.Map;
handles.campaign_lot_map = campaign_lot_map;

%Initlalize Campaign Quarter Map
campaign_quarter_map = containers.Map;
handles.campaign_quarter_map = campaign_quarter_map;

%Initialize Attribute Label cell array
handles.attribute_labels = {};

%Initialize axes struct
handles.axes_struct = gobjects(0);

%Initialize selected campaign cell array
handles.test_selected_campaigns = {};

% masterDataMap = containers.Map;
% handles.masterDataMap = masterDataMap;

%Initialize Campaign Coating and Raw Data Maps
handles.campaignCoatingMap = containers.Map;
handles.rawDataMap = containers.Map;

%Initialize Selected Attributes and Control Rule Cell Arrays
handles.selectedAttributes = {};
handles.allAttributes = {};
handles.selectedControlRules = {};

%Initialize Terminal Output
handles.terminal_output = {};

%Reset GUI to erase any preexisting data
resetGUI(handles);

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_gui (see VARARGIN)

% Choose default command line output for test_gui
handles.output = hObject;
handles.selected_indices = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






% --- Executes on button press in importCampaignButton.
function importCampaignButton_Callback(hObject, eventdata, handles)
% hObject    handle to importCampaignButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = writeToStatusBar('Busy...',handles);
 try
    %Check if Selected File Path is NOT Empty
    if isempty(handles.filePathText.String) == 0
        
        %Freeze GUI during execution and start execution timer
        tic
        oldpointer = get(handles.figure1, 'pointer');
        set(handles.figure1, 'pointer', 'watch')
        InterfaceObj=findobj(handles.figure1,'Enable','on');
        set(InterfaceObj,'Enable','off');
        drawnow;
        checkFolderContents(handles.campaignNameEdit.String,handles)
        %Import Data from PI if Excel Workbook not found in current directory
        if checkFolderContents(handles.campaignNameEdit.String,handles) == 0
            handles = writeToStatusBar(['Importing',' ',handles.campaignNameEdit.String,' ','from PI...'],handles);
            guidata(hObject,handles)
            importFromPI(strtrim(handles.campaignNameEdit.String),handles.filePathText.String);
        end
        
        
        if checkFolderContents(handles.campaignNameEdit.String,handles) == 0
            errordlg('Error: Invalid Campaign!')
            handles = writeToStatusBar('Error: Invalid Campaign!',handles);
        else
            
            %Add Specified Campaign to selectCampaignTable given it is not
            %currently present
            if isempty(handles.selectCampaignTable.Data) == 1 || isempty(find(cellfun(@(x)isequal(x,strtrim(handles.campaignNameEdit.String)),handles.selectCampaignTable.Data))) == 1
                completeRow = {strtrim(handles.campaignNameEdit.String),' ',' ',false};
                handles.selectCampaignTable.Data = [handles.selectCampaignTable.Data;completeRow];
                guidata(hObject, handles);
            end
        end
        
        %Unfreeze GUI after execution and write execution runtime to terminal
        set(handles.figure1, 'pointer', oldpointer)
        set(InterfaceObj,'Enable','on');
        y = toc;
        handles = writeToTerminal(['Finished in', ' ' , num2str(y), ' ','seconds'],handles);
        handles = writeToStatusBar(['Finished in', ' ' , num2str(y), ' ','seconds'],handles);
        guidata(hObject,handles)
    else
        errordlg('Error: Cannot import to unspecified path');
        handles = writeToStatusBar('Error: Cannot import to unspecified path',handles);
        guidata(hObject,handles)
    end
catch ME
    errordlg(ME.message);
    handles = writeToStatusBar(ME.message,handles);
    guidata(hObject,handles)
end














% --- Executes on key press with focus on selectCampaignTable and none of its controls.
function selectCampaignTable_KeyPressFcn(hObject, eventdata, handles)

% hObject    handle to selectCampaignTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in selectCampaignTable.
function selectCampaignTable_CellSelectionCallback(hObject, eventdata, handles)

handles.selected_indices = eventdata.Indices;
guidata(hObject,handles)


% hObject    handle to selectCampaignTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function selectCampaignTable_ButtonDownFcn(hObject, eventdata, handles)
disp('ButtonDownFcn')
% hObject    handle to selectCampaignTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function selectCampaignTable_CreateFcn(hObject, eventdata, handles)
set(hObject, 'Data', {});
% set(hObject, 'RowName', {'R1', 'R2', 'R3'}, 'ColumnName', {'C1', 'C2', 'C3'});
% hObject    handle to selectCampaignTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when entered data in editable cell(s) in selectCampaignTable.
function selectCampaignTable_CellEditCallback(hObject, eventdata, handles)
InterfaceObj=findobj(handles.figure1,'Enable','on');
oldpointer = get(handles.figure1, 'pointer');
try
    %Get selected row and column indices
    selectedRow = eventdata.Indices(1);
    selectedColumn = eventdata.Indices(2);
    
    %Check if column with checkboxes was selected
    if selectedColumn == 4
        handles = writeToStatusBar('Busy...',handles);

        %Freeze GUI during execution and start execution timer
        tic
        set(handles.figure1, 'pointer', 'watch')
        set(InterfaceObj,'Enable','off');
        drawnow;
        
        %Select Campaign if checkbox is unchecked
        if eventdata.PreviousData == 0
            handles = selectCampaign(selectedRow,handles);
            guidata(hObject, handles);
            
            %Update Status Bar
            selectedCampaignName = char(handles.selectCampaignTable.Data(selectedRow,1));
            handles = writeToStatusBar([selectedCampaignName,' ','selected!'],handles);
            guidata(hObject,handles);
            
            
            %Deselect Campaign if checkbox is checked
        elseif eventdata.PreviousData == 1
            handles = deselectCampaign(selectedRow,handles);
            guidata(hObject, handles);
            
            %Update Status Bar
            selectedCampaignName = char(handles.selectCampaignTable.Data(selectedRow,1));
            handles = writeToStatusBar([selectedCampaignName,' ','deselected!'],handles);
            guidata(hObject,handles);
            
        end
        
        %Unfreeze GUI after execution
        set(InterfaceObj,'Enable','on');
        set(handles.figure1, 'pointer', oldpointer)
        
        guidata(hObject,handles)
        
    %Allow for users to edit Section Column
    elseif selectedColumn == 3
        handles = editSectionColumn(selectedRow,eventdata,handles);
        guidata(hObject, handles);
        
        %Allow for users to edit Lot Column
    elseif selectedColumn == 2
        handles = editLotColumn(selectedRow,eventdata,handles);
        guidata(hObject, handles);
        
    end
catch ME
    
    errordlg(ME.message)
    
    %Update Status Bar
    handles = writeToStatusBar(ME.message,handles);
    guidata(hObject,handles);
    
    %Unfreeze GUI after execution
    set(InterfaceObj,'Enable','on');
    set(handles.figure1, 'pointer', oldpointer)
end




% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
if isempty(handles.selected_indices) == 0
    %Freeze GUI during execution
    InterfaceObj=findobj(handles.figure1,'Enable','on');
    set(InterfaceObj,'Enable','off');
    
    %Get unique row indicies of selected campaigns
    rowIndices = handles.selected_indices(:,1);
    rowIndices = unique(rowIndices);
    
    %Remove data for each selected campaign from data structures
    for i = 1:size(rowIndices,1)
        key = handles.selectCampaignTable.Data(rowIndices(i),1);
        handles = deleteCampaignData(char(key),handles);
        guidata(hObject, handles);
        handles.selectCampaignTable.Data(rowIndices(i),:) = {[]};
        handles = writeToStatusBar(['Removed', ' ' , char(key), '!'],handles);
        guidata(hObject,handles)
    end
    
    %Update selectCampaignTable
    newData = handles.selectCampaignTable.Data;
    newData = newData(~cellfun(@isempty, newData(:,1)), :);
    handles.selectCampaignTable.Data = newData;
    
    %If last campaign is deleted, clear location and attribute selection menus
    if size(getSelectedCampaigns(handles),2) == 0
        locationLabels = getLocationLabelsTest(getSelectedCampaigns(handles),handles);
        handles.locationSelectionMenu.String = locationLabels;
        handles.locationSelectionMenu.Value = 1;
        guidata(hObject, handles);
        handles = updateAttributeData(handles);
    end
    
    %Unfreeze GUI after execution
    set(InterfaceObj,'Enable','on');
    guidata(hObject, handles);
    handles.selected_indices = [];
end
catch ME
    errordlg(ME.message)
    
    %Unfreeze GUI after execution
    set(InterfaceObj,'Enable','on');
    guidata(hObject, handles);
    
    %Update Status bar
    handles = writeToStatusBar(ME.message,handles);
    guidata(hObject,handles)
    
end





%popupmenu1_Callback(handles.locationSelectionMenu, EventData, handles)
% --- Executes on selection change in locationSelectionMenu.
function locationSelectionMenu_Callback(hObject, eventdata, handles)
% % hObject    handle to locationSelectionMenu (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)

try
    %Get selected Location
    locationIndex = handles.locationSelectionMenu.Value;
    selectedLocation = handles.locationSelectionMenu.String(locationIndex);
    
    %Update Status Bar
    handles = writeToStatusBar(['Loading',' ',char(selectedLocation),'...'],handles);
    guidata(hObject, handles);
    
    %Freeze GUI during execution
    oldpointer = get(handles.figure1, 'pointer');
    set(handles.figure1, 'pointer', 'watch')
    drawnow;
    InterfaceObj=findobj(handles.figure1,'Enable','on');
    set(InterfaceObj,'Enable','off');
    
    %Update Attribite Data
    handles = updateAttributeData(handles);
    
    %Unfreeze GUI after execution
    set(handles.figure1, 'pointer', oldpointer)
    set(InterfaceObj,'Enable','on');
    guidata(hObject, handles);
    
    
    %Update Status Bar
    handles = writeToStatusBar([char(selectedLocation),' ','loaded!'],handles);
    guidata(hObject, handles);
catch ME
    errordlg(ME.message);
    handles = writeToStatusBar(ME.message,handles);
    guidata(hObject, handles);
end

% Hints: contents = cellstr(get(hObject,'String')) returns locationSelectionMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from locationSelectionMenu






% --- Executes on button press in exportDataButton.
function exportDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to exportDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    %Get selected location and selected campaign
    selectedLocation = handles.locationSelectionMenu.String(handles.locationSelectionMenu.Value);
    selectedCampaign = handles.campaignSelectionMenu.String(handles.campaignSelectionMenu.Value);
    
    
    %Check whether selected location is not empty
    if strcmp(char(selectedLocation), ' ') == 0
        tic
        %Freeze GUI during execution and start execution timer
        oldpointer = get(handles.figure1, 'pointer');
        set(handles.figure1, 'pointer', 'watch')
        InterfaceObj=findobj(handles.figure1,'Enable','on');
        set(InterfaceObj,'Enable','off');
        drawnow;
        
        %Open file selection dialog
        filter = {'*.xls';'*.xlsx';};
        [file, path] = uiputfile(filter);
        filename = fullfile(path,file);
        
        %Check if non-empty file name is entered
        if file ~= 0
            
            %Update Status Bar
            handles = writeToStatusBar(['Exporting all data for',' ',char(selectedLocation),'...'],handles);
            guidata(hObject,handles);
    
            %Get all attribute labels from availableAttribueTable
            allAttributeLabels = handles.availableAttributeTable.Data(:,1);
            
            %Get all selected campaigns
            selectedCampaigns = getSelectedCampaigns(handles);
            
            %Grab attribute data and populate Raw Data Map for each campaign in
            %case the Raw Data for a specific campaign has never been imported before
            for j = 1:size(selectedCampaigns,2)
                for i = 1:size(allAttributeLabels,1)
                    getAttributeData(selectedCampaigns{j},selectedLocation{1},allAttributeLabels{i},handles);
                end
            end
            
            
            %For each selected camapaign grab, all the attribute data associated
            %with the specified lcoation and append to cell array
            %allCampaignAttributeData
            columnLabels = {};
            allCampaignAttributeData = {};
            selectedCampaigns = getSelectedCampaigns(handles);
            for i = 1:size(selectedCampaigns,2)
                %Get location data map from campaign name key
                map1 = handles.rawDataMap(char(selectedCampaigns(i)));
                %Get all the attribute data from location data map
                locationRawData = map1(selectedLocation{1});
                %Extract just the columnLabels out for to be reconcatenated
                %later
                columnLabels = locationRawData(1,:);
                %Append extracted attribute data to the bottom of allCampaignAttributeData
                allCampaignAttributeData = [allCampaignAttributeData;locationRawData(2:end,:)];
            end
            
            %Add back the column labels
            allCampaignAttributeData = [columnLabels;allCampaignAttributeData];
            
            
            %Write extracted data into excel
            xlswrite(filename,allCampaignAttributeData);
            
            %Unfreeze GUI after execution completion 
            set(handles.figure1, 'pointer', oldpointer)
            set(InterfaceObj,'Enable','on');
            
            y = toc;
            handles = writeToTerminal(['Finished in', ' ' , num2str(y), ' ','seconds'],handles);
            handles = writeToStatusBar(['Finished in', ' ' , num2str(y), ' ','seconds'],handles);
            guidata(hObject,handles)
        else
            %Unfreeze GUI after execution completion 
            set(handles.figure1, 'pointer', oldpointer)
            set(InterfaceObj,'Enable','on');
            
        end
    end
catch ME
    errordlg(ME.message)
    
    %Update Status Bar
    handles = writeToStatusbar(ME.message,handles);
    guidata(hObject,handles);
    
    %Unfreeze GUI after execution completion
    set(handles.figure1, 'pointer', oldpointer)
    set(InterfaceObj,'Enable','on');
end



% --- Executes on button press in exportFigureButton.
function exportFigureButton_Callback(hObject, eventdata, handles)
% hObject    handle to exportFigureButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.axes_struct) == 0
    try
        %Freeze GUI during execution and start execution timer
        tic
        oldpointer = get(handles.figure1, 'pointer');
        set(handles.figure1, 'pointer', 'watch')
        InterfaceObj=findobj(handles.figure1,'Enable','on');
        set(InterfaceObj,'Enable','off');
        drawnow;
        
        %Open up file selection dialog window
        selpath = uigetdir;
        
        if selpath ~= 0
            %Update Status Bar
            handles.statusBarStaticText.String = ['Exporting', ' ' , handles.axes1.Title.String,'...'];
            
            %Create new figure and set visibility off
            fig = figure;
            leg = handles.axes1.Legend;
            copyobj([leg,handles.axes1], fig);
            set(fig,'Visible', 'off');
            set(gcf,'Position',[0 0 700 400])
            fig.Color='w';
            
            %Create file name by appending axes title to file path
            filename = strcat(selpath,'\',handles.axes1.Title.String);
            
            %Export figure to file type based on option selected
            if handles.jpgOption.Value == 1
                export_fig(fig,filename,'-jpg');
            elseif handles.pngOption.Value == 1
                export_fig(fig,filename,'-png');
            elseif handles.pdfOption.Value == 1
                %             set(fig,'Units','Inches');
                %             pos = get(fig,'Position');
                %             set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
                %             print(fig,handles.axes1.Title,'-dpdf','-r0')
                %export_fig(fig,handles.axes1.Title.String,'-pdf');
            else
                savefig(fig,strcat(filename,'.fig'))
            end
            
            %Unfreeze GUI and write execution runtime to terminal
            set(handles.figure1, 'pointer', oldpointer)
            set(InterfaceObj,'Enable','on');
            
            y = toc;
            handles = writeToTerminal(['Finished in', ' ' , num2str(y), ' ','seconds'],handles);
            handles.statusBarStaticText.String = ['Finished in', ' ' , num2str(y), ' ','seconds'];
            guidata(hObject,handles)
            
            %Close figure created
            close(fig)
        else
            set(handles.figure1, 'pointer', oldpointer)
            set(InterfaceObj,'Enable','on');
        end
        
    catch ME
        errordlg(ME.message)
        
        %Update Status Bar
        handles = writeToStatusbar(ME.message,handles);
        guidata(hObject,handles);
        
        %Unfreeze GUI after execution completion
        set(handles.figure1, 'pointer', oldpointer)
        set(InterfaceObj,'Enable','on');
    end
end




% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.checkbox17.Value == 1
    handles.selectedControlRules(end+1) = {'n4'};
else
    handles.selectedControlRules(ismember(handles.selectedControlRules,'n4')) = [];
end
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of checkbox17


% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.checkbox14.Value == 1
    handles.selectedControlRules(end+1) = {'n3'};
else
    handles.selectedControlRules(ismember(handles.selectedControlRules,'n3')) = [];
end
guidata(hObject,handles)

% Hint: get(hObject,'Value') returns toggle state of checkbox14


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.checkbox11.Value == 1
    handles.selectedControlRules(end+1) = {'n1'};
else
    handles.selectedControlRules(ismember(handles.selectedControlRules,'n1')) = [];
end
guidata(hObject,handles)




% --- Executes on button press in plotControlChartButton.
function plotControlChartButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotControlChartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = writeToStatusBar('Busy...',handles);
try
    %Check whether at least 5 campaigns have been selected
    if size(getSelectedCampaigns(handles),2) < 5
        errordlg('Error: At least 5 Campaigns must be selected!')
        handles = writeToStatusBar('Error: At least 5 Campaigns must be selected!',handles);
        guidata(hObject,handles)
    else
        %Freeze GUI during execution and start execution timer
        tic
        oldpointer = get(handles.figure1, 'pointer');
        set(handles.figure1, 'pointer', 'watch')
        InterfaceObj=findobj(handles.figure1,'Enable','on');
        set(InterfaceObj,'Enable','off');
        drawnow;
        
        %Update handles struct, clear axes, and set slider value to 1
        handles = guidata(hObject);
        cla(handles.axes1,'reset');
        axes(handles.axes1);
        handles.slider2.Value = 1;
        
        %Close all invisible figures
        figHandles = findobj('Type', 'figure','Visible','off');
        close(figHandles);
        
        %         %Check plot option selected and call corresponding plot function
        %         if handles.individualPlotOption.Value == 1
        %             handles = plotIndividualAttribute('Control',handles);
        %             guidata(hObject,handles);
        %         elseif handles.allPlotOption.Value == 1
        %             handles = plotAllAttributes('Control',handles);
        %             guidata(hObject,handles);
        %         else
        %             handles = plotSelectedData('Control',handles);
        %             guidata(hObject,handles);
        %         end
        handles = writeToStatusBar('Hello',handles);
        handles = plotAttributeData('Control',handles);
        guidata(hObject,handles);
        
        %Unfreeze GUI after execution completion and write execution runtime to
        %terminal
        set(handles.figure1, 'pointer', oldpointer)
        set(InterfaceObj,'Enable','on');
        
        y = toc;
        handles = writeToTerminal(['Finished in', ' ' , num2str(y), ' ','seconds'],handles);
        handles.statusBarStaticText.String = ['Finished in', ' ' , num2str(y), ' ','seconds'];
        guidata(hObject,handles)
    end
catch ME
    errordlg(ME.message)
    
    handles = writeToStatusBar(ME.message,handles);
    guidata(hObject,handles)
    
    set(handles.figure1, 'pointer', oldpointer)
    set(InterfaceObj,'Enable','on');
end



% --- Executes on button press in checkbox24.
function checkbox24_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.checkbox24.Value == 1
    handles.selectedControlRules(end+1) = {'n2'};
else
    handles.selectedControlRules(ismember(handles.selectedControlRules,'n2')) = [];
end
guidata(hObject,handles)

% Hint: get(hObject,'Value') returns toggle state of checkbox24






% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Toggle Control Chart/Trend Chart uipanel based on selected option
if handles.trendChartOption.Value == 1
    handles.uipanel9.Visible = 'off';
    handles.uipanel12.Visible = 'on';
elseif handles.controlChartOption.Value == 1
    handles.uipanel9.Visible = 'on';
    handles.uipanel12.Visible = 'off';
else
end





function LLEdit_Callback(hObject, eventdata, handles)
% hObject    handle to LLEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = updateLimits('LL',handles);
guidata(hObject, handles);



function ULEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ULEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = updateLimits('UL',handles);
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of ULEdit as text
%        str2double(get(hObject,'String')) returns contents of ULEdit as a double




% --- Executes on button press in plotTrendChartButton.
function plotTrendChartButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotTrendChartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = writeToStatusBar('Busy...',handles);
 try
    %Check whether at least 2 campaigns have been selected
    if size(getSelectedCampaigns(handles),2) < 2
        errordlg('Error: At least 2 Campaigns must be selected!')
        handles = writeToStatusBar('Error: At least 2 Campaigns must be selected!',handles);
        guidata(hObject,handles)
    else
        tic
        %Freeze GUI during execution and start execution timer
        oldpointer = get(handles.figure1, 'pointer');
        set(handles.figure1, 'pointer', 'watch')
        InterfaceObj=findobj(handles.figure1,'Enable','on');
        set(InterfaceObj,'Enable','off');
        drawnow;
        
        %Update handles struct, clear axes,close invisible figures, and set slider value to 1
        handles = guidata(hObject);
        cla(handles.axes1,'reset');
        axes(handles.axes1);
        handles.slider2.Value = 1;
        
        %Close all invisible figures
        figHandles = findobj('Type', 'figure','Visible','off');
        close(figHandles);
        
        handles = plotAttributeData('Variability',handles);
        guidata(hObject,handles);
        
        %         %Check plot option selected and call corresponding plot function
        %         if handles.individualPlotOption.Value == 1
        %             handles = plotIndividualAttribute('Variability',handles);
        %             guidata(hObject,handles);
        %         elseif handles.allPlotOption.Value == 1
        %             handles = plotAllAttributes('Variability',handles);
        %             guidata(hObject,handles);
        %         else
        %             handles = plotSelectedData('Variability',handles);
        %             guidata(hObject,handles);
        %         end
        
        %Unfreeze GUI after execution completion and write execution runtime to
        %terminal
        set(handles.figure1, 'pointer', oldpointer)
        set(InterfaceObj,'Enable','on');
        
        y = toc;
        handles = writeToTerminal(['Finished in', ' ' , num2str(y), ' ','seconds'],handles);
        handles = writeToStatusBar(['Finished in', ' ' , num2str(y), ' ','seconds'],handles);
        guidata(hObject,handles)
    end
catch ME
    
    errordlg(ME.message)
    handles = writeToStatusBar(ME.message,handles);
    guidata(hObject,handles)
    
    set(handles.figure1, 'pointer', oldpointer)
    set(InterfaceObj,'Enable','on');
end








function plotYLLimEdit_Callback(hObject, eventdata, handles)
% hObject    handle to plotYLLimEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.axes_struct) == 0
    handles = updateYAxis(handles);
    guidata(hObject, handles);
end

% Hints: get(hObject,'String') returns contents of plotYLLimEdit as text
%        str2double(get(hObject,'String')) returns contents of plotYLLimEdit as a double






function plotYLabelEdit_Callback(hObject, eventdata, handles)
% hObject    handle to plotYLabelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.axes_struct) == 0
    %Update Ylabel of specified axes in the axes struct
    handles.axes_struct(getAxesIndex(handles)).YLabel.String = handles.plotYLabelEdit.String;
    
    %Copy axes in the axes_struct to handles.axes1
    ax = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
    handles.axes1 = ax;
    
    guidata(hObject, handles);
end





function plotXLabelEdit_Callback(hObject, eventdata, handles)
% hObject    handle to plotXLabelEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Allows for any changes in fig properties data to remain constant

if isempty(handles.axes_struct) == 0
    %Update Xlabel of specified axes in the axes struct
    handles.axes_struct(getAxesIndex(handles)).XLabel.String = handles.plotXLabelEdit.String;
    
    %Copy axes in the axes_struct to handles.axes1
    handles.axes1 = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
    
    guidata(hObject, handles);
end


% Hints: get(hObject,'String') returns contents of plotXLabelEdit as text
%        str2double(get(hObject,'String')) returns contents of plotXLabelEdit as a double






function plotTitleEdit_Callback(hObject, eventdata, handles)
% hObject    handle to plotTitleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.axes_struct) == 0
    %Update Title of specified axes in the axes struct
    handles.axes_struct(getAxesIndex(handles)).Title.String = handles.plotTitleEdit.String;
    
    %Copy axes in the axes_struct to handles.axes1
    ax = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
    handles.axes1 = ax;
    
    guidata(hObject, handles);
end

% Hints: get(hObject,'String') returns contents of plotTitleEdit as text
%        str2double(get(hObject,'String')) returns contents of plotTitleEdit as a double




% --- Executes when selected object is changed in uibuttongroup3.
function uibuttongroup3_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup3
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Toggle attribute selection menu and slider based on plot option selected
if handles.individualPlotOption.Value == 1
    handles.attributeSelectionMenu.Enable = 'on';
    handles.slider2.Enable = 'off';
else
    handles.attributeSelectionMenu.Enable = 'off';
    %handles.slider2.Enable = 'on';
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get index of new axes
axesIndex = getAxesIndex(handles);

%Copy axes from axes_struct into handles.axes1
handles.axes1 = copyaxes(handles.axes_struct(axesIndex),handles.axes1);

%Update Figure Properties
handles = updateFigureProperties(handles);

guidata(hObject, handles);


% --- Executes on button press in exportAllFiguresButton.
function exportAllFiguresButton_Callback(hObject, eventdata, handles)
% hObject    handle to exportAllFiguresButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.axes_struct) == 0
    try
        %Freeze GUI during execution and start execution timer
        tic
        oldpointer = get(handles.figure1, 'pointer');
        set(handles.figure1, 'pointer', 'watch')
        InterfaceObj=findobj(handles.figure1,'Enable','on');
        set(InterfaceObj,'Enable','off');
        drawnow;
        
        %Open up file selection dialog window
        selpath = uigetdir;
        
        if selpath ~= 0
            
            %Loop through all axes in axes_struct
            allAxes = handles.axes_struct;
            for i = 1:size(allAxes,2)
                
                %Update Status Bar
                handles.statusBarStaticText.String = ['Exporting', ' ' ,allAxes(i).Title.String,'...'];
                
                %Initlaize new figure and set visibibilty to 'off'
                fig = figure;
                leg = allAxes(i).Legend;
                copyobj([leg,allAxes(i)], fig);
                set(fig,'Visible', 'off');
                set(gcf,'Position',[0 0 700 400])
                fig.Color='w';
                
                %Create file name by appending axes title to file path
                filename = strcat(selpath,'\',allAxes(i).Title.String);
                
                %Export axes to specified file type
                if handles.jpgOption.Value == 1
                    export_fig(fig,filename,'-jpg');
                elseif handles.pngOption.Value == 1
                    export_fig(fig,filename,'-png');
                elseif handles.pdfOption.Value == 1
                    %export_fig(fig,allAxes(i).Title.String,'-pdf');
                    %                 set(fig,'Units','Inches');
                    %                 pos = get(fig,'Position');
                    %                 set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
                    %                 print(fig,allAxes(i).Title.String,'-dpdf','-r0')
                elseif handles.figOption.Value == 1
                    savefig(fig,strcat(selpath,'\',strcat(allAxes(i).Title.String,'.fig')));
                end
                
                %Close figure opened
                close(fig)
            end
            
            %Unfreeze GUI after excution completion and write execution runtime to
            %terminal
            set(handles.figure1, 'pointer', oldpointer)
            set(InterfaceObj,'Enable','on');
            
            y = toc;
            handles = writeToTerminal(['Finished in', ' ' , num2str(y), ' ','seconds'],handles);
            handles.statusBarStaticText.String = ['Finished in', ' ' , num2str(y), ' ','seconds'];
            guidata(hObject,handles)
        end
    catch ME
        errordlg(ME.message)
        
        %Update Status Bar
        handles = writeToStatusbar(ME.message,handles);
        guidata(hObject,handles);
        
        %Unfreeze GUI after execution completion
        set(handles.figure1, 'pointer', oldpointer)
        set(InterfaceObj,'Enable','on');
    end
end


% --- Executes on button press in expandButton.
function expandButton_Callback(hObject, eventdata, handles)
% hObject    handle to expandButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.axes_struct) == 0
    %Initilaize Figure window
    expandFig = figure(10);
    clf(expandFig,'reset');
    
    %Create axes in figure
    figAxes = axes();
    
    %Copy axes in handles.axes1 into the axes of expand_fig
    ax = copyaxes(handles.axes1,figAxes);
    guidata(hObject, handles);
end



% --- Executes on button press in viewDataButton.
function viewDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    %Check if selected location is not empty
    if strcmp(char(handles.locationSelectionMenu.String(handles.locationSelectionMenu.Value)),' ') == 0
        
        %Initialize new figure, reset all data, and turn visibilty off for now
        handles = writeToStatusBar('Initializing Figure Window...',handles);
        guidata(hObject,handles)
        
        f = figure('Visible','off');
        f.Visible = 'off';
        %clf(f,'reset');
        f.Position = [300   150   800   600];
        handles.appendFigure = f;
        guidata(hObject, handles);
        set(f, 'MenuBar', 'none');
        set(f, 'ToolBar', 'none');
        
        handles = writeToStatusBar('Extracting and Writing Attribute Data...',handles);
        guidata(hObject,handles)
        %Get selected location and campaign
        selectedLocation = handles.locationSelectionMenu.String(handles.locationSelectionMenu.Value);
        selectedCampaign = handles.campaignSelectionMenu.String(handles.campaignSelectionMenu.Value);
        
        %Grab attribute data in case Raw Data Map has not been populated yet
        allAttributeLabels = handles.availableAttributeTable.Data(:,1);
        for i = 1:size(allAttributeLabels,1)
            getAttributeData(selectedCampaign{1},selectedLocation{1},allAttributeLabels{i},handles);
        end
        
        %Extract all attribute data for specified location into
        %cell array locationRawData
        map1 = handles.rawDataMap(selectedCampaign{1});
        locationRawData = map1(selectedLocation{1});
        
        %Add UITable
        handles.appendDataTable = uitable(f,'Position',[75 25 700 550],'Tag','AppendDataTable');
        
        %Check if Coater A/B is selected
        if strcmp(selectedLocation{1},'Coater A/B')
            %Get index of column labelled Pan Load(kg)
            [~,panLoadColumn] = find(cellfun(@(x)isequal(x,'Pan Load(kg)'),locationRawData));
            
            %Create vector of 0s
            editableColumns = zeros(1,size(locationRawData,2));
            
            %Set value at index corresponding to panload column to 1 indicating
            %ediatble status
            editableColumns(panLoadColumn) = 1;
            
            %Set editable status of panload column to true
            set(handles.appendDataTable,'ColumnEditable',logical(editableColumns));
        else
            %Set all columns as uneditable
            handles.appendDataTable.ColumnEditable = false;
        end
        
        %Update handles struct and copy locationRawData into appendDataTable
        guidata(hObject, handles);
        handles.appendDataTable.Data = locationRawData;
        
        
        %Get uneditable dimension bounds if not already established
        if isempty(handles.uneditable_dimension_bounds)
            handles.uneditable_dimension_bounds = [size(locationRawData,1),size(locationRawData,2)];
            guidata(hObject, handles);
        end
        
        %Initialize Table Callback functions
        handles.appendDataTable.CellEditCallback = {@append_uitable_CellEditCallback,handles,handles.uneditable_dimension_bounds};
        handles.appendDataTable.CellSelectionCallback = {@append_uitable_CellSelectionCallback,handles};
        guidata(hObject,handles);
        
        
        handles = writeToStatusBar('Adding all UI Objects...',handles);
        guidata(hObject,handles)
        %Create Add Row UIButton
        importData = uicontrol('Parent',f,'Style','pushbutton',...
            'String','Import','Position',[3,525,70,25],...
            'Callback',{@importdatabutton_Callback,handles});
        
        
        %Create Delete Row UIButton
        deleteRow = uicontrol('Parent',f,'Style','pushbutton',...
            'String','Delete Row','Position',[3,500,70,25],...
            'Callback',{@deleterowbutton_Callback,handles,handles.uneditable_dimension_bounds});
        
        %Create Save UIButton
        saveData = uicontrol('Parent',f,'Style','pushbutton',...
            'String','Save','Position',[3,475,70,25],...
            'Callback',{@savedatabutton_Callback,handles});
        
        %Create Close UIButton
        closeFig = uicontrol('Parent',f,'Style','pushbutton',...
            'String','Close','Position',[3,450,70,25],...
            'Callback',@closefigbutton_Callback);
        guidata(hObject, handles);
        
        %Create Import Pan Load button if location Coater A/B is selected
        if strcmp(selectedLocation{1},'Coater A/B')
            importPanLoad = uicontrol('Parent',f,'Style','pushbutton',...
                'String','Pan Load','Position',[3,425,70,25],...
                'Callback',{@importpanload_Callback,handles});
            guidata(hObject, handles);
        end
        
        %Turn visibility of figure back on once all actions have been completed
        f.Visible = 'on';
        handles = writeToStatusBar('Complete!',handles);
        guidata(hObject,handles)
    end
catch ME
    errordlg(ME.message)
    
    handles = writeToStatusBar(ME.message,handles);
    guidata(hObject,handles)
    
end

%allows for user to import panload data from an excel sheet
function importpanload_Callback(hObject,eventdata,handles)

%Open File Selection Dialog Window
[filename,path] = uigetfile('*.xls','MultiSelect', 'off'); %filters for .exdml files only and does not allow for multiselection
if filename == 0
    return;
end
%addpath(path)

%Read data in selected Excel file into raw
filepath = fullfile(path,filename);
[~,~,raw] = xlsread(filepath);

%Clean imported data of NaN values
%out = raw(any(cellfun(@(x)any(~isnan(x)),raw),2),:);

%Extract only numeric attribute data 
importedData = raw(2:end,:);
%converts cell array to matrix


if validatePanLoadData(importedData,size(handles.appendDataTable.Data,1) - 1) == 1
    %Add Extracted Data to current Data in Table
    currentData = handles.appendDataTable.Data;
    [~,panLoadColumn] = find(cellfun(@(x)isequal(x,'Pan Load(kg)'),currentData));
    currentData(2:end,panLoadColumn) = importedData;
    handles.appendDataTable.Data = currentData;
else
    errordlg('Error: Unable to append data. Make sure proper formatting is used!')
end
guidata(hObject, handles);


function closefigbutton_Callback(hObject,eventdata)
handles = guidata(hObject);

%Erase data in appendDataTable
handles.appendDataTable.Data = [];

%Close figure window
close(hObject.Parent);

function savedatabutton_Callback(hObject,eventdata,handles)
handles = guidata(hObject);
%Grab current data in appendDataTable and place in updatedAttributeData
%cell array
updatedAttributeData = handles.appendDataTable.Data;

%Get selected location and selected campaign
selectedLocation = handles.locationSelectionMenu.String(handles.locationSelectionMenu.Value);
selectedCampaign = handles.campaignSelectionMenu.String(handles.campaignSelectionMenu.Value);

%Update rawDataMap with updatedAttributeData
map1 = handles.rawDataMap(selectedCampaign{1});
map1(selectedLocation{1}) = updatedAttributeData;
handles.rawDataMap(selectedCampaign{1}) = map1;

guidata(hObject, handles);


function deleterowbutton_Callback(hObject,eventdata,handles,uneditable_bounds)
handles = guidata(hObject);

%get currentData from appendDataTable
currentData = handles.appendDataTable.Data;
handles = guidata(hObject);

%get index of selected row
selectedRow = handles.appendDataTableSelectionIndex(1);

%Check whether row is wuthin uneditble bounds
if selectedRow <= uneditable_bounds(1)
    errordlg('Error:Cannot delete pre-existing data!');
else
    %Remove selected row from currentData
    currentData(selectedRow,:) = [];
    %Update appendDataTable
    handles.appendDataTable.Data = currentData;
    guidata(hObject, handles);
end
guidata(hObject, handles);

function importdatabutton_Callback(hObject,eventdata,handles)
%Open File Selection Dialog Window
[filename,path] = uigetfile('*.xls','MultiSelect', 'off'); %filters for .exdml files only and does not allow for multiselection
if filename == 0
    return;
end
%addpath(path)

%Read data in selected Excel file into raw
filepath = fullfile(path,filename);
[~,~,raw] = xlsread(filepath);

%Clean imported data of NaN values
out = raw(any(cellfun(@(x)any(~isnan(x)),raw),2),:);

%Extract only numeric attribute data
appendedData = out(2:end,:);

%Validate appended_data
if validateAppendedData(appendedData,handles.appendDataTable.Data) == 1
    
    %Add Extracted Data to current Data in Table
    currentData = handles.appendDataTable.Data;
    currentData = [currentData;appendedData];
    handles.appendDataTable.Data = currentData;
else
    errordlg('Error: Unable to append data. Make sure proper formatting is used!')
end
guidata(hObject, handles);


function append_uitable_CellEditCallback(hObject,eventdata,handles,dimension_bounds)
handles = guidata(hObject);

%get selected row and column
selectedRow = eventdata.Indices(1);
selectedColumn = eventdata.Indices(2);

%adsd = isnan(str2double(eventdata.NewData));

%Check whether user input is non-numeric on NaN
if isempty(str2num(eventdata.NewData)) == 1
    handles.appendDataTable.Data{selectedRow,selectedColumn} = eventdata.PreviousData;
    errordlg('Error: Invalid Input!')
    guidata(hObject, handles);
end

handles = guidata(hObject);
guidata(hObject, handles);


function append_uitable_CellSelectionCallback(hObject,eventdata,handles)
%Get indices of selected cell in appendDataTable
handles.appendDataTableSelectionIndex = eventdata.Indices;
guidata(hObject,handles)



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axesList = findall(gcf,'type','axes');
delete(axesList);
% Hint: delete(hObject) closes the figure
delete(hObject);



% --- Executes on button press in clearFigureButton.
function clearFigureButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearFigureButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
%Clear and Reset handles.axes1
cla(handles.axes1,'reset');

%Close all invisible figures
figHandles = findobj('Type', 'figure','Visible','off');
close(figHandles);

%Remove all axes from axes_struct
handles.axes_struct = gobjects(0);

%Disbale Slider
handles.slider2.Enable = 'off';

%Clear Fig Properties UIPanel
clearFigProps(handles);
guidata(hObject, handles);

%Update Status Bar
handles = writeToStatusBar('All Plots Cleared!',handles);
guidata(hObject,handles)

catch ME
    errordlg(ME.message)
    
    %Update Status Bar
    handles = writeToStatusBar(ME.message,handles);
    guidata(hObject,handles)
end





function plotYULimEdit_Callback(hObject, eventdata, handles)
% hObject    handle to plotYULimEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.axes_struct) == 0
    handles = updateYAxis(handles);
    guidata(hObject, handles);
end





% --- Executes on button press in defaultButton.
function defaultButton_Callback(hObject, eventdata, handles)
% hObject    handle to defaultButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
%Check that axes_struct is not empty
if isempty(handles.axes_struct) == 0
    
    %Freeze GUI during execution and start execution timer
    tic
    oldpointer = get(handles.figure1, 'pointer');
    set(handles.figure1, 'pointer', 'watch')
    InterfaceObj=findobj(handles.figure1,'Enable','on');
    set(InterfaceObj,'Enable','off');
    drawnow;
    
    %Get selected attribute
    if handles.individualPlotOption.Value == 1
        index = handles.attributeSelectionMenu.Value;
        selectedAttribute = handles.attributeSelectionMenu.String(index);
    elseif handles.allPlotOption.Value == 1
        selectedAttribute = handles.attributeSelectionMenu.String(getAxesIndex(handles));
    else
        selectedAttributes = getSelectedAttributes(handles);
        selectedAttribute = selectedAttributes(getAxesIndex(handles));
    end
    
    %Get selected location
    index = handles.locationSelectionMenu.Value;
    selectedLocation = handles.locationSelectionMenu.String(index);
    
    %Get selected attribute data for all campaigns
    allCampaignAttributeData = getAttributeDataAllCampaigns(getSelectedCampaigns(handles),selectedLocation,selectedAttribute,handles);
    
    %Call corresponding chart function based on option selected
    if handles.trendChartOption.Value == 1
        defaultAxes = trendChartData(allCampaignAttributeData,handles);
    else
        defaultAxes = controlChartData(allCampaignAttributeData,handles);
    end
    
    %Copy default axes to corresponding axes in axes_struct
    ax =  copyaxes(defaultAxes,handles.axes_struct(getAxesIndex(handles)));
    handles.axes_struct(getAxesIndex(handles)) = ax;
    
    %Copy axes in axes_struct to visible axes handles.axes1
    ax = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
    handles.axes1 = ax;
    
    
    %
    %     %Inidividual Plot Option
    %     if handles.individualPlotOption.Value == 1
    %
    %         %Get selected attribute
    %         index = handles.attributeSelectionMenu.Value;
    %         selectedAttribute = handles.attributeSelectionMenu.String(index);
    %
    %         %Get selected location
    %         index = handles.locationSelectionMenu.Value;
    %         selectedLocation = handles.locationSelectionMenu.String(index);
    %
    %         %Get selected attribute data for all campaigns
    %         allCampaignAttributeData = getAttributeDataAllCampaigns(handles.test_selected_campaigns,selectedLocation,selectedAttribute,handles);
    %
    %         %Call corresponding chart function based on option selected
    %         if handles.trendChartOption.Value == 1
    %             default_axes = Copy_of_trend_chart_data(allCampaignAttributeData,handles);
    %         else
    %             default_axes = controlChartData(allCampaignAttributeData,handles);
    %         end
    %
    %         %Copy default axes to corresponding axes in axes_struct
    %         ax =  copyaxes(default_axes,handles.axes_struct(getAxesIndex(handles)));
    %         handles.axes_struct(getAxesIndex(handles)) = ax;
    %
    %         %Set visible axes(handles.axes1) equal to recently copied default
    %         %axes
    %         handles.axes1 = ax;
    %
    %     %All or Selected Plot Option
    %     else
    %         if handles.allPlotOption.Value == 1
    %             current_attribute = handles.attributeSelectionMenu.String(getAxesIndex(handles));
    %         else
    %             current_attribute = handles.selectedAttributes(getAxesIndex(handles));
    %         end
    %
    %         index = handles.locationSelectionMenu.Value;
    %         selectedLocation = handles.locationSelectionMenu.String(index);
    %
    %         allCampaignAttributeData = getAttributeDataAllCampaigns(handles.test_selected_campaigns,selectedLocation,current_attribute,handles);
    %
    %         if handles.trendChartOption.Value == 1
    %             default_axes = Copy_of_trend_chart_data(allCampaignAttributeData,handles);
    %         else
    %             default_axes = controlChartData(allCampaignAttributeData,handles);
    %         end
    %
    %         ax =  copyaxes(default_axes,handles.axes_struct(getAxesIndex(handles)));
    %         handles.axes_struct(getAxesIndex(handles)) = ax;
    %
    %         %Allows for any changes in YLim data to remain constant
    %         ax = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
    %         handles.axes1 = ax;
    %     end
    
    %Update Figure Properties
    handles = updateFigureProperties(handles);
    guidata(hObject, handles);
    
    %Unfreeze GUI after execution completion and write execution runtime to
    %terminal
    set(handles.figure1, 'pointer', oldpointer)
    set(InterfaceObj,'Enable','on');
    
    y = toc;
    handles = writeToTerminal(['Finished in', ' ' , num2str(y), ' ','seconds'],handles);
    handles.statusBarStaticText.String = ['Finished in', ' ' , num2str(y), ' ','seconds'];
    guidata(hObject,handles)
end
catch ME
    errordlg(ME.message);
    
    %Unfreeze GUI after execution completion and write execution runtime to
    %terminal
    set(handles.figure1, 'pointer', oldpointer)
    set(InterfaceObj,'Enable','on');
    
    %Update Status Bar
    handles = writeToStatusBar(ME.message,handles);
    guidata(hObject,handles)
end



% --- Executes on button press in addFilePathButton.
function addFilePathButton_Callback(hObject, eventdata, handles)
% hObject    handle to addFilePathButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try

%Freeze GUI during execution
InterfaceObj=findobj(handles.figure1,'Enable','on');
set(InterfaceObj,'Enable','off');

%try
%Open up file selection dialog window
selpath = uigetdir;

if selpath ~= 0
    %Add selected file path to
    %addpath(selpath);
    
    %Udpate filePathText with updated path
    handles.filePathText.String = selpath;
    guidata(hObject,handles);
    
    %Update Status Bar
    handles = writeToStatusBar([selpath,' ','chosen!'],handles);
    guidata(hObject,handles);
    
    %reset GUI
    handles = resetGUI(handles);
    guidata(hObject,handles)
end
set(InterfaceObj,'Enable','on');
catch ME
    errordlg(ME.message)
    
    %Unfreeze GUI
    set(InterfaceObj,'Enable','on');
    
    %Update Status Bar
    handles = writeToStatusBar([selpath,' ','chosen!'],handles);
    guidata(hObject,handles);
end
%     %Add selected file path to
%     addpath(selpath);
%
%     %Udpate filePathText with updated path
%     handles.filePathText.String = selpath;
%     guidata(hObject,handles);
%
%     set(InterfaceObj,'Enable','on');
% catch
%     set(InterfaceObj,'Enable','on');






function plotYBoxEdit_Callback(hObject, eventdata, handles)
% hObject    handle to plotYBoxEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get handles to section boxes
if isempty(handles.axes_struct) == 0
    sectionGroup = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','Section Box');
    
    %Iterate through each section box for a given plot and update the Y
    %Position
    for i = 1:size(sectionGroup.Children,1)
        textBox = sectionGroup.Children(i);
        currentX = textBox.Position(1);
        newY = str2num(handles.plotYBoxEdit.String);
        textBox.Position = [currentX newY];
    end
    
    %Copy axes from axes_struct to handles.axes1
    ax = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
    handles.axes1 = ax;
    
    guidata(hObject, handles);
end



% --- Executes on button press in resetGUIButton.
function resetGUIButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetGUIButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
handles = resetGUI(handles);

%Update Status Bar
handles = writeToStatusBar('Ready!',handles);
guidata(hObject, handles);
catch ME
    errordlg(ME.message)
    
    %Update Status Bar
    handles = writeToStatusBar(ME.message,handles);
    guidata(hObject,handles)
end

% --- Executes on button press in radiobutton30.
function radiobutton30_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.radiobutton30.Value == 1
    data = handles.selectCampaignTable.Data;
    handles.original_copy = data;
    sorted_data = sortrows(data,1);
    handles.selectCampaignTable.Data = sorted_data;
    guidata(hObject, handles);
else
    handles.selectCampaignTable.Data = handles.original_copy;
end


% Hint: get(hObject,'Value') returns toggle state of radiobutton30

% --- Executes on button press in boxplotToggleButton.
function boxplotToggleButton_Callback(hObject, eventdata, handles)
% hObject    handle to boxplotToggleButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Check whether axes_struct is not empty
if isempty(handles.axes_struct) == 0
    %Find handles to all boxplots in current axes
    bxPlot = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','Boxplot');
    
    %Check to see value of boxplot toggle button and turn visibility on or
    %off based on value
    if handles.boxplotToggleButton.Value == 0
        for i = 1:size(bxPlot,1)
            bxPlot(i).Visible = 'off';
        end
    else
        for i = 1:size(bxPlot,1)
            bxPlot(i).Visible = 'on';
        end
    end
    
    %Copy axes from axes_struct to handles.axes1
    handles.axes1 = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
    
end




guidata(hObject, handles);


% --- Executes on button press in flipBoxRadioButton.
function flipBoxRadioButton_Callback(hObject, eventdata, handles)
% hObject    handle to flipBoxRadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Check that the axes_struct is NOT Empty
if isempty(handles.axes_struct) == 0
    %Get handles to section boxes
    sectionGroup = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','Section Box');
    
    %Based on current value of flipBoxRadioButton, rotate each section box
    %to 90 degrees or 0 degrees
    if handles.flipBoxRadioButton.Value == 1
        for i = 1:size(sectionGroup.Children,1)
            textBox = sectionGroup.Children(i);
            textBox.Rotation = 90;
        end
    else
        for i = 1:size(sectionGroup.Children,1)
            textBox = sectionGroup.Children(i);
            textBox.Rotation = 0;
        end
    end
    
    
    %Copy axes from axes_struct to handles.axes1
    ax = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
    handles.axes1 = ax;
    
end
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of flipBoxRadioButton


% --- Executes when entered data in editable cell(s) in availableAttributeTable.
function availableAttributeTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to availableAttributeTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

% %Get selected row
% selectedRow = eventdata.Indices(1);
%
% %Case 1: Check Box was previously unchecked
% if eventdata.PreviousData == 0
%
%     %Get attribute label of selected row
%     attributeLabel = handles.availableAttributeTable.Data(selectedRow,1);
%
%     %Check that attributeLabel does not exist in vector selectedAttributes
%     %and if not append attributeLabel to vector selectedAttributes
%     selectedAttributes = getSelectedAttributes(handles);
%     if sum(ismember(selectedAttributes,attributeLabel)) == 0
%         handles.selectedAttributes(end+1) = attributeLabel;
%     end
%     guidata(hObject, handles);
%
%     %Case 2: Check Box was previously checked
% elseif eventdata.PreviousData == 1
%
%     %Get attribute label of selected row
%     attributeLabel = handles.availableAttributeTable.Data(selectedRow,1);
%
%     %Remove attribute label from vector selectedAttributes
%     handles.selectedAttributes(ismember(handles.selectedAttributes,attributeLabel)) = [];
%     guidata(hObject, handles);
% end
% guidata(hObject, handles);




% --- Executes on button press in selectMultCampButton.
function selectMultCampButton_Callback(hObject, eventdata, handles)
% hObject    handle to selectMultCampButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    if isempty(handles.selected_indices) == 0
        %Get indices of selected cell(s)
        selectedIndices = handles.selected_indices;
        
        %Freeze GUI during execution
        oldpointer = get(handles.figure1, 'pointer');
        set(handles.figure1, 'pointer', 'watch')
        InterfaceObj=findobj(handles.figure1,'Enable','on');
        set(InterfaceObj,'Enable','off');
        drawnow;
        
        %For each selected row of selectCampaignTable, check whether it is
        %unchecked, and if so call selectCampaign
        for i = 1:size(selectedIndices,1)
            if handles.selectCampaignTable.Data{selectedIndices(i,1),4} == false
                handles.selectCampaignTable.Data{selectedIndices(i,1),4} = true;
                handles = selectCampaign(selectedIndices(i,1),handles);
                guidata(hObject, handles);
            end
        end
        
        handles.selected_indices = [];
        
        %Unfreeze GUI after execution completion
        set(InterfaceObj,'Enable','on');
        set(handles.figure1, 'pointer', oldpointer)
        
        %Update Status Bar
        handles = writeToStatusBar([num2str(size(selectedIndices,1)),' ','Campaigns selected!'],handles);
        guidata(hObject,handles);
    end
catch ME
    errordlg(ME.message)
    
    %Update Status Bar
    handles = writeToStatusBar(ME.message,handles);
    guidata(hObject,handles);
    
    %Unfreeze GUI after execution completion
    set(InterfaceObj,'Enable','on');
    set(handles.figure1, 'pointer', oldpointer)
end


% --- Executes on button press in delselectMultCampButton.
function delselectMultCampButton_Callback(hObject, eventdata, handles)

try 
if isempty(handles.selected_indices) == 0
    %Get indices of selected cell(s)
    selectedIndices = handles.selected_indices;
    
    %Freeze GUI during execution
    oldpointer = get(handles.figure1, 'pointer');
    set(handles.figure1, 'pointer', 'watch')
    InterfaceObj=findobj(handles.figure1,'Enable','on');
    set(InterfaceObj,'Enable','off');
    drawnow;
    
    %For each selected row of selectCampaignTable, check whether it is
    %checked, and if so call deselectCampaign
    for i = 1:size(selectedIndices,1)
        if handles.selectCampaignTable.Data{selectedIndices(i,1),4} == true
            handles.selectCampaignTable.Data{selectedIndices(i,1),4} = false;
            handles = deselectCampaign(selectedIndices(i,1),handles);
            guidata(hObject, handles);
        end
    end
    
    handles.selected_indices = [];
    
    %Unfreeze GUI after execution completion
    set(InterfaceObj,'Enable','on');
    set(handles.figure1, 'pointer', oldpointer)
    guidata(hObject, handles);
    
    %Update Status Bar
    handles = writeToStatusBar([num2str(size(selectedIndices,1)),' ','Campaigns deselected!'],handles);
    guidata(hObject,handles);
end
catch ME
    errordlg(ME.message)
    
    %Unfreeze GUI after execution completion
    set(InterfaceObj,'Enable','on');
    set(handles.figure1, 'pointer', oldpointer)
    
    %Update Status Bar
    handles = writeToStatusBar(ME.message,handles);
    guidata(hObject,handles);
    
end

% hObject    handle to delselectMultCampButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in campaignSelectionMenu.
function campaignSelectionMenu_Callback(hObject, eventdata, handles)
% hObject    handle to campaignSelectionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns campaignSelectionMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from campaignSelectionMenu


% --- Executes on selection change in attributeSelectionMenu.
function attributeSelectionMenu_Callback(hObject, eventdata, handles)
% hObject    handle to attributeSelectionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns attributeSelectionMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from attributeSelectionMenu



function terminalEdit_Callback(hObject, eventdata, handles)
% hObject    handle to terminalEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of terminalEdit as text
%        str2double(get(hObject,'String')) returns contents of terminalEdit as a double
