%Requires: chartType to be either 'Variability' or 'Control'. 
%Modifies: handles.axes1,handles.axes_struct
%Effects: Given the location,campaigns, and chartType specified, this
%function compiles all the attribute data required and generates a single
%axes for each attribute in the location. It append these axes in
%axes_struct and copies the axes specified by the slider to be shown on
%handles.axes1


function handles = plotAllAttributes(chartType,handles,varargin)
    try
        %Empty axes_struct
        handles.axes_struct = gobjects(0);

        %grab all attribute labels from attribute selection menu
        attributeLabels = handles.attributeSelectionMenu.String;
        locationIndex = handles.locationSelectionMenu.Value;
        selectedLocation = handles.locationSelectionMenu.String(locationIndex);

        %For each atttribute in the specified location, grab data over all
        %campaigns
        for i = 1:size(attributeLabels,1)
             %Write to Plot Status Bar
            handles.statusBarStaticText.String = ['Compiling Data for',' ',char(attributeLabels(i)),'...'];
            allCampaignAttributeData = getAttributeDataAllCampaigns(getSelectedCampaigns(handles),selectedLocation,attributeLabels(i),handles);
            if checkRawData(allCampaignAttributeData) == true
                %Based on chartType indicated, plot either the trend
                %chart of the variability chart
                handles.statusBarStaticText.String = ['Plotting',' ',char(attributeLabels(i)),' ...'];
                if strcmp(chartType,'Variability') == 1
                    handles.axes_struct(end+1) = trendChartData(allCampaignAttributeData,handles);
                elseif strcmp(chartType,'Control') == 1
                    handles.axes_struct(end+1) = controlChartData(allCampaignAttributeData,handles);
                end
            else
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
    catch ME
        errordlg(ME.message);
        return;
    end
end

        
    