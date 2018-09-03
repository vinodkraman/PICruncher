%Requires: NA
%Modifies: NA
%Effects: Removes specified campaign from selectedCampaigns vector and
%         relevant data maps
function handles = deselectCampaign(selected_row,handles)
   
    %Remove data for specified camapign from relevant data maps
    key = handles.selectCampaignTable.Data(selected_row,1);
    remove(handles.campaign_lot_map,char(key));
    remove(handles.campaign_quarter_map,char(key));
    
    %Remove campaign name from selectedCampaigns vector
    handles.test_selected_campaigns(ismember(handles.test_selected_campaigns,key)) = []; 
    
    %Clear location and attribute select menus when last campaign is
    %deselected
    if size(getSelectedCampaigns(handles),2) == 0 
       location_labels_test = getLocationLabelsTest(getSelectedCampaigns(handles),handles);
       handles.locationSelectionMenu.String = location_labels_test;
       handles.locationSelectionMenu.Value = 1;
       handles = updateAttributeData(handles);
    end
end