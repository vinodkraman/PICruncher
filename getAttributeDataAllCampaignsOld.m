%Requires: Inputs selectedCampaigns, selectedLocation, and
%selectedAttribute must be cell arrays
%Modifies:NA
%Effects: returns an nx2 cell array containing data of a specified
%attribute over all campaigns in selectedCampaigns

function allCampaignAttributeData = getAttributeDataAllCampaignsOld(selectedCampaigns,selectedLocation,selectedAttribute,handles)
    %Initialize empty cell arrays
    allCampaignAttributeData = {};
    column_labels = {}; 
    
    %Iterate through each campaign in selectedCampaigns, get an nx2 cell array
    %of the corresponding attribute data, and append that data to
    %allCampaignAttributeData
    for i = 1:size(selectedCampaigns,2)
        data = getAttributeData(selectedCampaigns{i},char(selectedLocation),char(selectedAttribute),handles); %gets data for specified campaign, location, and attribute
        column_labels = data(1,:);
        allCampaignAttributeData = [allCampaignAttributeData;data(2:end,:)];
    end
    allCampaignAttributeData = [column_labels;allCampaignAttributeData];
end