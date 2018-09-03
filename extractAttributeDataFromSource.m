%Requires: Input source contains column titled "CampaignName" and column
%with the title of the attribute. Input attribute be of type str or char.
%Modifies: NA
%Effects: returns a nx2 cell array with the first column containing the
%campaign name and the second containing the attribute data

function data = extractAttributeDataFromSource(source,attribute,handles)
    [~,attribute_index] = find(cellfun(@(x)isequal(x,attribute),source));
    [~,campaign_index] = find(cellfun(@(x)isequal(x,'CampaignName'),source));
    data = [source(:,campaign_index) source(:,attribute_index)];
end