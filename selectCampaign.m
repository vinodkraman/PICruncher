%Requires: selectedRow to be a numeric value
%Modifies: NA
%Effects: Allows for a selected campaign to be checked(selected) and
%         and updates relevant data structures

function handles = selectCampaign(selectedRow,handles)
    %CASE1: Unspecified Lot# --> throw error
    if handles.selectCampaignTable.Data{selectedRow,2} == ' '
        handles.selectCampaignTable.Data(selectedRow,4)= {false};
        ME = MException('MATLAB:unspecifiedLot',['Error: Unspecified Lot# for:',' ',handles.selectCampaignTable.Data{selectedRow,1}]);
        throw(ME);
    elseif isempty(handles.selectCampaignTable.Data{selectedRow,2})
        handles.selectCampaignTable.Data(selectedRow,4) = {false};
        ME = MException('MATLAB:unspecifiedLot',['Error: Unspecified Lot# for:',' ',handles.selectCampaignTable.Data{selectedRow,1}]);
        throw(ME);
    %CASE2: Unspecified Section --> throw error
    elseif handles.selectCampaignTable.Data{selectedRow,3} == ' '
        handles.selectCampaignTable.Data(selectedRow,4)= {false};
        ME = MException('MATLAB:unspecifiedSection',['Error: Unspecified Section for:',' ',handles.selectCampaignTable.Data{selectedRow,1}]);
        throw(ME);
    elseif isempty(handles.selectCampaignTable.Data{selectedRow,3})
        handles.selectCampaignTable.Data(selectedRow,4) = {false};
        ME = MException('MATLAB:unspecifiedSection',['Error: Unspecified Section for:',' ',handles.selectCampaignTable.Data{selectedRow,1}]);
        throw(ME);
    %CASE3: Specified Lot# and Section
    else
        selectedCampaign = handles.selectCampaignTable.Data(selectedRow,1);
            %Upate data structures
            lot = handles.selectCampaignTable.Data(selectedRow,2);
            section = handles.selectCampaignTable.Data(selectedRow,3);
            handles.campaign_lot_map(char(selectedCampaign)) = lot;
            handles.campaign_quarter_map(char(selectedCampaign)) = section;
            %handles.test_selected_campaigns(end + 1) = selectedCampaign;
            
            %Update location and attribute data for rest of the GUI if this
            %is the first campaign to be selected
            if size(getSelectedCampaigns(handles),2) == 1 
                locationLabels = getLocationLabelsTest(getSelectedCampaigns(handles),handles);
                handles.locationSelectionMenu.String = locationLabels;
                handles.locationSelectionMenu.Value = 1;
                handles = updateAttributeData(handles);
            end
            
            %Update Cooater Data if the current location is 'Coater A
            locationIndex = handles.locationSelectionMenu.Value;
            location = handles.locationSelectionMenu.String(locationIndex);

            if strcmp(char(location),'Coater A/B') == 1
                handles = updateCoatingData(handles);
            end
    end