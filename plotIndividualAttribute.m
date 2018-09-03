%Requires: chartType to be either 'Variability' or 'Control'. 
%Modifies: handles.axes1,handles.axes_struct
%Effects: Given the location,campaign,attribute,chartType specified, this
%         function compiles all the attribute data required and generates a single
%         axes for selected attribute in the location. It will then copy this axes 
%         onto the viewable axes handles.axes1


function handles = plotIndividualAttribute(chartType,handles,varargin)
     try
        
        %Clear axes_struct
        handles.axes_struct = gobjects(0);
        
        %Get selected attribute from atttribute selection menu
        index = handles.attributeSelectionMenu.Value;
        selectedAttribute = handles.attributeSelectionMenu.String(index);

        %Get selected location from location selection menu
        locationIndex = handles.locationSelectionMenu.Value;
        selectedLocation = handles.locationSelectionMenu.String(locationIndex);
        
        %Write to Plot Status Bar
        handles.statusBarStaticText.String = 'Compiling Data..';
   
        %Grab all data for specified attribute over all campaigns
        allCampaignAttributeData = getAttributeDataAllCampaigns(getSelectedCampaigns(handles),selectedLocation,selectedAttribute,handles);

        %Make sure that no NaN or empty values exist in extracted data
        if checkRawData(allCampaignAttributeData,handles) == true
            %Based on chartType specified,call trendChartData or
            %controlChartData and append axes_struct with the newly created
            %axes
            handles.statusBarStaticText.String = ['Plotting',' ',char(selectedAttribute),' ...'];
            if strcmp(chartType,'Variability') == 1
                 handles.axes_struct(end+1) = trendChartData(allCampaignAttributeData,handles);
            elseif strcmp(chartType,'Control') == 1
                handles.axes_struct(end+1) = controlChartData(allCampaignAttributeData,handles);
            end
            
            handles.statusBarStaticText.String = 'Copying to Axes..';
            %Based on index of slider, copy the axes in corresponding spot
            %in axes_struct in the viewable handles.axes1
            handles.axes1 = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
            
            %Update the Figure Properties Panel
            handles.statusBarStaticText.String = 'Updating Figure Properties...';
            handles = updateFigureProperties(handles);
            handles.statusBarStaticText.String = 'Complete';
        end

     catch ME
        errordlg(ME.message)
        return;
    end

end

    