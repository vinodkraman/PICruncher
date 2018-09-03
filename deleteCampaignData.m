%Requires: NA
%Modifies: NA
%Effects: Deletes all data corresponding to a specified campaign from data
%         structures

function handles = deleteCampaignData(campaign_name,handles)
    remove(handles.campaign_lot_map,campaign_name);
    remove(handles.campaign_quarter_map,campaign_name);
    handles.test_selected_campaigns(ismember(handles.test_selected_campaigns,campaign_name)) = [];    
    remove(handles.rawDataMap,campaign_name);
end