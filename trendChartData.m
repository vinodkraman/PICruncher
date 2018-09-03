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
%Effects: Returns an axes contaning a trend chart of specified input

function newAxes = trendChartData(raw,handles)

fig = figure();
fig.Visible = 'off';
newAxes = axes('Parent',fig);
% 
% %Create new axes and set Parent to uipanel17
% newAxes = axes('Parent',handles.uipanel17);
% newAxes.Position = handles.axes1.Position;



%Extract column of campaign labels from raw input
allCampaignLabels = raw(2:end,1);

%Extracts a attribute column(w/ headers) to test
attribute_column_test = raw(:,1:2);

%Extract the label of the attribute and use as the tag for the axes
%attributeLabel = raw(1,2);
attributeLabel = raw{1}(1,2);
newAxes.Tag = char(attributeLabel);


%Extract and convert campaign labels to Batch#
campaignLabels = {};
for j = 1:size(raw,2)
    campaignLabels(end+1) = raw{j}(2,1);
end

batchLabels = cell(size(campaignLabels,2),1);

for i = 1:size(campaignLabels,2)
    batchLabels{i} = char(handles.campaign_lot_map(campaignLabels{i}));
end

%Split attribute data into seperate cell arrays according to campaign number
%splitAttributeData = splitCellArray(raw(2:end,2),ia);


hold on;

%Initialize box plot data cell arrays
boxPlotX = {};
boxPlotY = {};

%Iterate through and scatter plot each campaign(cell) in splitAttributeData
%to newAxes. For each campaign, populate a cell in boxPlotX with attribute data, and the corresponding cell in boxPlotY
%with the current index of the campaign
for i = 1:size(raw,2)
    rawNum = raw{i}(2:end,2);
    attributeMat = cell2mat(rawNum);
    xAxis = ones(size(attributeMat,1),1);
    randNum = (i-.1) + rand(size(xAxis,1),1)*((i+.1)-(i-.1));
    xAxisJitter = randNum.*xAxis;
    y =  plot(xAxisJitter,attributeMat,'.','Color','k','MarkerSize', 10,'Parent',newAxes);
    y.LineStyle = 'none';
    
    boxPlotX{end+1} = attributeMat;
    boxPlotY{end+1} = [i*ones(size(attributeMat))];
end

boxPlotX = boxPlotX.';
boxPlotY = boxPlotY.';

%Plot Range bars over scatter plot of each campaign
for i = 1:size(boxPlotX,1)
    plotRange(i,cell2mat(boxPlotX(i)));
end

%Plot boxplot
bx = boxplot(cell2mat(boxPlotX),cell2mat(boxPlotY),'Color','r','Symbol','k.','OutlierSize',10,'Widths',0.2);
set(bx,'LineWidth',2);
set(bx,'Tag','Boxplot');
if handles.boxplotToggleButton.Value == 0
    set(bx,'Visible','off');
else
    set(bx,'Visible','on');
end

%Set XTickLabels
set(findobj(gcf,'-regexp','Tag','\w*Whisker'),'LineStyle','-');
newAxes.XTickLabelMode = 'manual';
set(gca,'XTickLabel',batchLabels);
xtickangle(45);


%Combine attribute data from all campaigns
allAttributeData = {};
for j = 1:size(raw,2)
    allAttributeData = [allAttributeData;raw{j}(2:end,2)];
end

%Calculate and Plot Average Line
avg = mean(cell2mat(allAttributeData));
xAvgAxis = linspace(newAxes.XLim(1),newAxes.XLim(2),100);
yAvg = zeros(size(xAvgAxis,2),1);
yAvg(:) = avg;
g = plot(xAvgAxis,yAvg,':','Color','k');

%Create Legend
leg = legend([g],{strcat('Overall Avg = ',num2str(round(avg,1)))},'Location','southeast');
legend('boxoff')
%set(leg,'Parent',newAxes.Parent);

%Plot USL and LSL(Upper Spec Limit and Lower Spec Limit)
UL  = max(cell2mat(allAttributeData));
LL = min(cell2mat(allAttributeData));

xULAxis = linspace(newAxes.XLim(1),newAxes.XLim(2),100);
yUL = zeros(size(xULAxis,2),1);
yUL(:) = UL;
yLL = zeros(size(xULAxis,2),1);
yLL(:) = LL;

ul = plot(xULAxis,yUL,'-','Color','r','Tag','UL');
ll = plot(xULAxis,yLL,'-','Color','r','Tag','LL');


%Set y axis limits
maxVal = max(cell2mat(allAttributeData));
minVal = min(cell2mat(allAttributeData));
range = maxVal - minVal;
y_ub = maxVal + range;
y_lb = minVal - range;

ylim([y_lb y_ub])

%Set Plot Title and X/YLabels
title(attributeLabel{1}(1:end));
ylabel(attributeLabel{1}(1:end));
xL = xlabel('Lot#');
xL.Position = [newAxes.XLim(2) newAxes.YLim(1)];
xL.HorizontalAlignment = 'left';

%Add Section Seperators and Section Boxes
%Obtain Section names from campaign_quarter_map
sectionLabels = cell(size(campaignLabels,2),1);
for i = 1:size(campaignLabels,2)
    sectionLabels{i} = char(handles.campaign_quarter_map(campaignLabels{i}));
end

%Find unique section names
[uniqueSectionLabels, ia, ~] = unique(sectionLabels,'stable');
sectionIndices = ia;


%Compute section Averages
dataBySection = joinCellArray(boxPlotX(1:end),sectionIndices);
dataBySectionAverages = zeros(size(dataBySection,1),1);
for k = 1:size(dataBySection)
    dataBySectionAverages(k) = mean(cell2mat(dataBySection{k}));
end

%Add Campaign Seperator Line
if size(uniqueSectionLabels,1) > 1
    seperatorIndices = ia(2:end) - .5;
    for i = 1:size(seperatorIndices)
        l = line([seperatorIndices(i) seperatorIndices(i)],  newAxes.YLim,'Tag','Seperator');
    end
    
    %Find Indices of section boxes
    sectionBoxLandmarks = [newAxes.XLim(1) seperatorIndices.' newAxes.XLim(2)];
    
    for i = 1:size(sectionBoxLandmarks,2) - 1
        sectionBoxIndex(i) = (sectionBoxLandmarks(i)+ sectionBoxLandmarks(i+1))/2;
    end
else
    sectionBoxIndex = (size(boxPlotX,1)-2)*.5 + 1.5;
end


%Add Section Box with Section Text and Section Avg
sg = hggroup('Tag','Section Box','Parent',newAxes);
for i = 1:size(sectionIndices)
    str = {uniqueSectionLabels{i},strcat('Avg =  ',' ',num2str(round(dataBySectionAverages(i),1)))};
    txt = text(sectionBoxIndex(i),(newAxes.YLim(2)+ UL)/2,str,'HorizontalAlignment','center','EdgeColor','k','FontSize',8,'FontWeight','bold','Parent',sg);
    txt.Margin = 0.1;
    if handles.flipBoxRadioButton.Value == 0
        txt.Rotation = 0;
    else
        txt.Rotation = 90;
    end
end

%We do this so that the order of the graphics objects added to group is the
%same as the order by which they are added
flipud(sg);

%Close the invisible figure we created
% close(fig)
end
