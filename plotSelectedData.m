%Requires: chartType to be either 'Variability' or 'Control'. 
%Modifies: handles.axes1,handles.axes_struct
%Effects: Given the location,campaigns,attributes, and chartType specified, this
%function compiles all the attribute data required and generates a single
%axes for each attribute checked in the availableAttributes Table. It append these axes in
%axes_struct and copies the axes specified by the slider to be shown on
%handles.axes1


function handles = plotSelectedData(chartType,handles,varargin)
    try
        %Check that vector selectedAttributes is NOT empry
        if isempty(getSelectedAttributes(handles)) == 0
            %Empty axes_struct
            handles.axes_struct = gobjects(0);

            %Get attrubute labels from selectedAttributes
            selectedAttributes = getSelectedAttributes(handles);

            %Get selected location
            locationIndex = handles.locationSelectionMenu.Value;
            selectedLocation = handles.locationSelectionMenu.String(locationIndex);

            %For each checked atttribute in the availableAttributeTable , grab data over all
            %campaigns
            for i = 1:size(selectedAttributes,2)
                handles.statusBarStaticText.String = ['Compiling Data for',' ',char(selectedAttributes(i)),'...'];
                allCampaignAttributeData = getAttributeDataAllCampaigns(getSelectedCampaigns(handles),selectedLocation,selectedAttributes(i),handles);
                %Check that none of the data contains NaN or empty value
                if checkRawData(allCampaignAttributeData) == true
                    %Generate axes based on chartType and append to
                    %axes_struct
                    handles.statusBarStaticText.String = ['Plotting',' ',char(selectedAttributes(i)),' ...'];
                    if strcmp(chartType,'Variability') == 1
                        handles.axes_struct(end+1) = trendChartData(allCampaignAttributeData,handles);
                    elseif strcmp(chartType,'Control') == 1
                        handles.axes_struct(end+1) = controlChartData(allCampaignAttributeData,handles);
                    end
                else
                    return;
                end
            end

            %Check that axes_struct is NOT empty
            if size(handles.axes_struct,2) > 0 
                %Configure slider based on number of selected attributes
                handles = configureSlider(handles);
                %Copy the axes from the axes_struct to the viewable handles.axes1 corresponding to the value of
                %the slider
                handles.statusBarStaticText.String = 'Copying to Axes..';
                handles.axes1 = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
                handles = updateFigureProperties(handles);
                handles.statusBarStaticText.String = 'Complete';
            end
        end
    catch ME
        errordlg(ME.message);
    end
end
           

        
    