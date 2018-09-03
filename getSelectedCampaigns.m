%Requires:NA
%Modifies:NA
%Effects:Returns column-wise cell array of all campaigns selected in
%        campaignSelecttable
function selectedCampaigns = getSelectedCampaigns(handles)
    data = handles.selectCampaignTable.Data;
    if isempty(data) == 0
        log = logical(sum(cellfun(@(x)isequal(x,1),data),2));
        selectedCampaigns = data(log,1).';
    else
        selectedCampaigns = {};
    end
end