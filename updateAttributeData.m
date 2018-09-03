%Requires: NA
%Modifies: NA
%Effects: updates availableAttributes Table, attributeSelectionMenu, and
%         campaignSelectionMenu based on selectedLocation 

function handles = updateAttributeData(handles)
    %Get selected Location
    locationIndex = handles.locationSelectionMenu.Value;
    selectedLocation = handles.locationSelectionMenu.String(locationIndex);

    %If location is 'Coater A/B', update coating data
    if strcmp(char(selectedLocation),'Coater A/B') == 1
        handles = updateCoatingData(handles);
    end

    %Check that location is not empty
    if strcmp(char(selectedLocation),' ') ~= 1
        %Get attribute labels from selected location
        attributeLabels = getAttributeLabels(getSelectedCampaigns(handles),char(selectedLocation),handles);
        handles.selectedAttributes = {};
        
        %Update handle data
        handles.allAttributes = attributeLabels;

        %Fill in appropriate UIControls with empty attribute data
        attributeLabels = attributeLabels.';
        selectionValue = num2cell(false(size(attributeLabels,1),1));
        handles.availableAttributeTable.Data = [attributeLabels selectionValue];
        handles.attributeSelectionMenu.String = [attributeLabels];
        handles.attributeSelectionMenu.Value = 1;
        handles.campaignSelectionMenu.String = getSelectedCampaigns(handles);
        handles.campaignSelectionMenu.Value = 1;
    else
        attributeLabels = {' '};

        %Update Handle Data
        handles.allAttributes = attributeLabels;

        %Fill in appropriate UIControls with empty attribute data
        handles.availableAttributeTable.Data = attributeLabels.';
        handles.attributeSelectionMenu.String = [attributeLabels.'];
        handles.attributeSelectionMenu.Value = 1;
        handles.campaignSelectionMenu.String = {' '};
        handles.campaignSelectionMenu.Value = 1;
    end
end