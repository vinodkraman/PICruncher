%Effects: Combines Coater1 and Coater2 data using mergeCoatingWheels for each selected campaign and
%         adds the corresponding processed data into the rawDataMapy with
%         key 'Coater A/B'
function handles = updateCoatingData(handles)
    %get all selected campaigns
    selectedCampaigns = getSelectedCampaigns(handles);
    %Iterate through each selected campaign
    for i = 1:size(selectedCampaigns,2)
        %Check that campaign is NOT in campaignCoatingMap
        if isKey(handles.campaignCoatingMap,char(selectedCampaigns(i))) == 0
            %Get filename of campaign workbook
            filename = strcat(char(selectedCampaigns(i)),'.xlsx');
            %Get raw data for Coater 1 Wheel
            filepath = fullfile(handles.filePathText.String,filename);
            [~,~,coater1Data] = xlsread(filepath,'Coater 1 Wheel');
            %Get raw data for Coater 2 Wheel
            filepath = fullfile(handles.filePathText.String,filename);
            [~,~,coater2Data] = xlsread(filepath,'Coater 2 Wheel');
            
            %Merge Coater 1 and Coater 2 data
            mergeData = mergeCoatingWheels(coater1Data,coater2Data);
            
            %Update rawDataMap and campaignCoatingMap
            handles.rawDataMap(char(selectedCampaigns(i))) = containers.Map('Coater A/B',mergeData);
            handles.campaignCoatingMap(char(selectedCampaigns(i))) = mergeData;
        end
    end
end