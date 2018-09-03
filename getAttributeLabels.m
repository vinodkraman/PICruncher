%Requires: selectedCampaigns to be cell array, location to be of value str
%or char
%Modifies: NA
%Effect: returns attribute labels for a selected location

function attributeLabels = getAttributeLabels(selectedCampaigns,location,handles)
    %Check if selected location is Coater A?B
    if strcmp(location,'Coater A/B') == 1
        %Only use the data from the first campaign
        coatingData = handles.campaignCoatingMap(selectedCampaigns{1});
        %Find column index of coater status
        [~,coaterStatus] = find(cellfun(@(x)isequal(x,'Coater Online or Offline'),coatingData));
        attributeStartIndex = coaterStatus + 1;
        %Extract attribute labels
        attributeLabels = coatingData(1,attributeStartIndex:end);
    else
        %read raw data from Excel sheet
        filename = strcat(selectedCampaigns{1},'.xlsx');
        filepath = fullfile(handles.filePathText.String,filename);
        [~,txt,~] = xlsread(filepath,location,'A1:Z1');
        
        %Find index of 'EndTime' column
        [~,endTimeIndex] = find(cellfun(@(x)isequal(x,'EndTime'),txt));
        attributeStartIndex = endTimeIndex + 1;
        %Extract attribute labels
        attributeLabels = txt(1,attributeStartIndex:end);
    end
end


