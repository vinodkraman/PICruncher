function handles = plotAttributeData(chartType,handles)
%Empty axes_struct
handles.axes_struct = gobjects(0);

%Get attribute labels needing to be plot based on plot type selected
if handles.individualPlotOption.Value == 1
    index = handles.attributeSelectionMenu.Value;
    selectedAttributes = handles.attributeSelectionMenu.String(index);
    
elseif handles.allPlotOption.Value == 1
    selectedAttributes = handles.attributeSelectionMenu.String;
else
    %Get attrubute labels from selectedAttributes
    selectedAttributes = getSelectedAttributes(handles).';
end

%Get selected location
locationIndex = handles.locationSelectionMenu.Value;
selectedLocation = handles.locationSelectionMenu.String(locationIndex);

%For each atttribute in the specified location, grab data over all
%campaigns
for i = 1:size(selectedAttributes,1)
    %Write to Plot Status Bar
    handles.statusBarStaticText.String = ['Compiling Data for',' ',char(selectedAttributes(i)),'...'];
    allCampaignAttributeData = getAttributeDataAllCampaigns(getSelectedCampaigns(handles),selectedLocation,selectedAttributes(i),handles);
    if checkRawData(allCampaignAttributeData) == true
        %Based on chartType indicated, plot either the trend
        %chart of the variability chart
        handles.statusBarStaticText.String = ['Plotting',' ',char(selectedAttributes(i)),' ...'];
        if strcmp(chartType,'Variability') == 1
            handles.axes_struct(end+1) = trendChartData(allCampaignAttributeData,handles);
        elseif strcmp(chartType,'Control') == 1
            handles.axes_struct(end+1) = controlChartData(allCampaignAttributeData,handles);
        end
    else
        ME = MException('MATLAB:invalidData','Error: Selected Attribute Data contains empty values!');
        throw(ME);
        return;
    end
end

%Check if axes_struct is not empty
if size(handles.axes_struct,2) > 0
    %Based on the size of axes_struct configuure the slider
    handles = configureSlider(handles);
    %Copy the axes from the axes_struct to the viewable handles.axes1 corresponding to the value of
    %the slider
    handles.statusBarStaticText.String = 'Copying to Axes..';
    handles.axes1 = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
    
    %Update the Figure Properties Panel
    handles.statusBarStaticText.String = 'Updating Figure Properties...';
    handles = updateFigureProperties(handles);
    
    handles.statusBarStaticText.String = 'Complete';
end
end
