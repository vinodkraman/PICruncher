%Requires: Input 'raw' to be a nx2 cell array with the first column
%          containing the campaign name as type str or char and the second column
%          with a numeric type. Note that first row of input 'raw' must be
%          column headers of type str or char. 
%
%Example Input:      'CampaignName'    'Blender Speed'
%                    '20170217-CSV-1A'      65.9975
%                    '20170217-CSV-1A'      70.0342
%                           ...               ...         
%Modfies:NA
%Effects: Returns an axes contaning a control chart of specified input

function newAxes = controlChartData(raw,handles)

%Initialize invisible figure
fig = figure();
fig.Visible = 'off';

%Create new axes and set parent to fig
newAxes = axes('Parent',fig);
%new_axes = axes('Parent',handles.uipanel17);
%new_axes.Position = handles.axes1.Position;

%Extract column of campaign labels from raw input
allCampaignLabels = raw(2:end,1);

%Extracts a attribute column(w/ headers) to test
attribute_column_test = raw(:,1:2);

%Extract the label of the attribute and use as the tag for the axes
attributeLabel = raw(1,2);
newAxes.Tag = attributeLabel{1};

%Extract and convert campaign labels to Batch#
[uniqueCampaignLabels,ia,~] = unique(allCampaignLabels(2:end,1),'stable');
ia = ia.';
uniqueBatchLabels = cell(size(uniqueCampaignLabels,1),1);

for i = 1:size(uniqueCampaignLabels)
    uniqueBatchLabels{i} = char(handles.campaign_lot_map(uniqueCampaignLabels{i}));
end

%Split attribute data into seperate cell arrays according to campaign number
splitAttributeData = splitCellArray(raw(2:end,2),ia);

%Calculate Mean of data in each Campaign
meanAttributeData =[];
for i = 1:size(splitAttributeData,1)
    meanAttributeData(i) = mean(cell2mat(splitAttributeData{i}));
end

%Plot Control Chart
meanAttributeData = meanAttributeData.';
[stats,plotgroup] = controlchart(meanAttributeData,'charttype','i','rules',handles.selectedControlRules,'Parent',newAxes);
newAxes.Legend.Location = 'southwest';


%Set XTickLabels
lots = 1:1:size(uniqueCampaignLabels,1);
xticks(lots);
set(gca,'XTickLabel',uniqueBatchLabels);
xtickangle(45);

%Set Plot Title and X/YLabels
title(attributeLabel{1}(1:end));
ylabel(attributeLabel{1}(1:end));
xL = xlabel('Lot#');
xL.Position = [newAxes.XLim(2) newAxes.YLim(1)];
xL.HorizontalAlignment = 'left';

%Add Section Seperators and Text Boxes
%Obtain Section Labels from campaign quarter_map
sectionLabels = cell(size(uniqueCampaignLabels,1),1);
for i = 1:size(uniqueCampaignLabels,1)
    sectionLabels{i} = char(handles.campaign_quarter_map(uniqueCampaignLabels{i}));
end

%Find  unique section labels
[uniqueSectionLabels, ia, ~] = unique(sectionLabels,'stable');
sectionIndices = ia;


%Add Campaign Seperator Line
if size(uniqueSectionLabels,1) > 1
    seperatorIndices = ia(2:end) - .5;
    for i = 1:size(seperatorIndices)
        l = line([seperatorIndices(i) seperatorIndices(i)],  newAxes.YLim,'Tag','Seperator');
    end
    
    %Find Indices of section boxes
    sectionBoxLandmarks = [newAxes.XLim(1) seperatorIndices.' newAxes.XLim(2)];
    
    for i = 1:size(sectionBoxLandmarks,2) - 1
        sectionBoxindex(i) = (sectionBoxLandmarks(i)+ sectionBoxLandmarks(i+1))/2;
    end
else
    sectionBoxindex = (1+size(box_plot_x_cell,1))/(size(box_plot_x_cell,1));
end


%Add Section Box to Control Chart
sg = hggroup('Tag','Section Box','Parent',newAxes);
for i = 1:size(sectionIndices)
    str = {uniqueSectionLabels{i}};
    txt = text(sectionBoxindex(i),(newAxes.YLim(2)+plotgroup.ucl(1))/2,str...
        ,'HorizontalAlignment','center','EdgeColor','k','FontSize',8,'FontWeight',...
        'bold','Parent',sg);
    height = txt.Extent(4);
    txt.Position(2) = plotgroup.ucl(1) - (height/1.5);
    txt.Margin = 0.2;
    txt.Rotation = 0;
end

%We do this so that the order of the graphics objects added to group is the
%same as the order by which they are added
flipud(sg);
