%Requires: Inputs selectedCampaigns, selectedLocation, and
%selectedAttribute must be cell arrays
%Modifies:NA
%Effects: Returns an 1xn nested cell array(allCampaignAttributeData) where
%each nested cell array contains attribute data for a specific campaign
%returned by getAttributeData

%Sample Output: allCampaignAttributeData = {Campaign1Data   Campaign2Data
%...}
    

function allCampaignAttributeData = getAttributeDataAllCampaigns(selectedCampaigns,selectedLocation,selectedAttribute,handles)
    %Initialize empty cell arrays
    allCampaignAttributeData = {};
    
    %Iterate through each campaign in selectedCampaigns
    for i = 1:size(selectedCampaigns,2)
        %Get nx2 cell array of attribute data for current campaign
        data = getAttributeData(selectedCampaigns{i},char(selectedLocation),char(selectedAttribute),handles); %gets data for specified campaign, location, and attribute  
        %Append cell array of extracted attribute data into
        %allCampaignAttributeData as its own cell
        allCampaignAttributeData{end+1} = data;
    end
    %allCampaignAttributeData = [column_labels;allCampaignAttributeData];
end