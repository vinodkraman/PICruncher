%Requires:NA
%Modifies:GUI
%Effect: Resets GUI, clearing all axes, and data structures 
function handles = resetGUI(handles)

    %Reset Axes
    cla(handles.axes1,'reset');

    %Clear Tables
    handles.selectCampaignTable.Data = [];
    handles.availableAttributeTable.Data = [];

    %Clear Pop-up Menus
    handles.locationSelectionMenu.String = ' ';
    handles.locationSelectionMenu.Value = 1;
    handles.attributeSelectionMenu.String = ' ';
    handles.attributeSelectionMenu.Value = 1;
    handles.campaignSelectionMenu.String = ' ';
    handles.campaignSelectionMenu.Value = 1;

    %Clear Figure Properties Panel
    handles = clearFigProps(handles);

    %Clear all Data Maps
    handles = clearDataStructures(handles);
    handles.test_selected_campaigns = {};
    handles.allAttributes = {};
    handles.selectedAttributes = {};

    %Clear Enter campaign Edit Text
    handles.edit4.String = '20170217-CSV-1A';

    %Clear axes and axes struct
    handles.axes_struct = gobjects(0);
    cla reset;
    set(handles.axes1,'Visible','on');
    handles.axes1.Position = [25 6 92.9333 21.6880];
    cla(handles.axes1,'reset')

    %Disable Slider
    handles.slider2.Enable = 'off';

    %Clear and Initialize Terminal Output
    handles.terminalEdit.String = '';
    handles.terminalEdit.Max = 500;
    handles.terminalEdit.Min = 0;

    %Initialize Plot Type
    if handles.trendChartOption.Value == 1 
        handles.uipanel9.Visible = 'off';
        handles.uipanel12.Visible = 'on';
    else
         handles.uipanel9.Visible = 'on';
         handles.uipanel12.Visible = 'off';
    end

    %Set Default Campaign Sort Option
    handles.radiobutton30.Value = 0;

end