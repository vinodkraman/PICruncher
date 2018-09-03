%Requires: NA
%Modifies: NA
%Effects: Enable Editing of Section Column  in selectCampaignTable

function handles = editSectionColumn(selectedRow,eventdata,handles)
    %Get selected campaign
    selectedCampaign = handles.selectCampaignTable.Data(selectedRow,1);
    
    %Check whether selected campaign is checked
    if cell2mat(handles.selectCampaignTable.Data(selectedRow,4)) == 1
        %Throw error if edited data is empty string or null
        if handles.selectCampaignTable.Data{selectedRow,3}== ' '
            errordlg('Error: Section cannot be empty');
            handles.selectCampaignTable.Data{selectedRow,3} = eventdata.PreviousData;
        elseif isempty(handles.selectCampaignTable.Data{selectedRow,3})
            errordlg('Error: Section cannot be empty');
            handles.selectCampaignTable.Data{selectedRow,3} = eventdata.PreviousData;
        else
            %Check that axes_struct is NOT Empty
            if isempty(handles.axes_struct) == 0
                %Update current axes and data structures with updated Section values
                selectedSectionBox = getSelectedSectionBox(eventdata.PreviousData,handles);
                if selectedSectionBox ~= 0 
                    selectedSectionBox.String{1} = eventdata.EditData;
                end
            end
                sectionValue = handles.selectCampaignTable.Data(selectedRow,3);
                handles.campaign_quarter_map(char(selectedCampaign)) = sectionValue;
        end    
    end
end