%Requires: NA
%Modifies: NA
%Effects: Enable Editing of Lot # in selectCampaignTable

function handles = editLotColumn(selectedRow,eventdata,handles)
    %Get selected campaign
    selectedCampaign = handles.selectCampaignTable.Data(selectedRow,1);
    
    %Check whether selected campaign is checked
    if cell2mat(handles.selectCampaignTable.Data(selectedRow,4)) == 1
        %Throw error if edited data is empty string or null
        if handles.selectCampaignTable.Data{selectedRow,2}== ' '
            errordlg('Error: Lot cannot be empty');
            handles.selectCampaignTable.Data{selectedRow,2} = eventdata.PreviousData;
        elseif isempty(handles.selectCampaignTable.Data{selectedRow,2})
            errordlg('Error: Lot cannot be empty');
            handles.selectCampaignTable.Data{selectedRow,2} = eventdata.PreviousData;
        else
            %Check that axes_struct is NOT Empty
            if isempty(handles.axes_struct) == 0
                %Update current axes and data structures with updated Lot values
                handles.axes1.XTickLabel{selectedRow} = eventdata.EditData;
            end
                lot_value = handles.selectCampaignTable.Data(selectedRow,2);
                handles.campaign_lot_map(char(selectedCampaign)) = lot_value;    
        end    
    end
end