%Required: Input selectedCampaigns be of type cell array
%Modifies:NA
%Effect: Returns unique location labels for a given set of campaigns

function uniqueLocationLabels = getLocationLabelsTest(selectedCampaigns,handles)
    %Initilaize empty cell array
    allLocationLabels = {};
    
    %Iterate through selectedCampaigns, extracing and appending attribute labels, 
    %to allLocationLabels
    for i = 1:size(selectedCampaigns,2)
        filename = strcat(selectedCampaigns{i},'.xlsx');
        filepath = fullfile(handles.filePathText.String,filename);
        %Extract cell array of sheet names for current campaign
        [~,sheets,~] = xlsfinfo(filepath);
        %Append attribute labels to allLocationLabels
        allLocationLabels{end + 1}  = sheets(2:end);
    end

    %Check that allLocationLabels is not empty
    if isempty(allLocationLabels) == 0
        %Manually Add 'Coater A/B' location to allLocationLabels
        allLocationLabels{1}{end+1} = 'Coater A/B';
        %Extracting all unique locations from allLocationLabels
       uniqueLocationLabels = unique(allLocationLabels{1});
    else 
        uniqueLocationLabels = {' '};
    end
end