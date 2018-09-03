%Requires: NA
%Modifies: NA
%Effects: 
function handles = clearDataStructures(handles)
    handles.location_labels = {};
    remove(handles.campaign_lot_map,keys(handles.campaign_lot_map));
    remove(handles.campaign_quarter_map,keys(handles.campaign_quarter_map));
    remove(handles.rawDataMap,keys(handles.rawDataMap));
    handles.test_selected_campaigns = {};
    handles.allAttributes = {};
    handles.selectedAttributes = {};
end