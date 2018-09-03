%Required: Input rawA and rawB are cell arrays with proper formatting

%Example Input:
%CampaignName	ProductKey	StartTime	EndTime	Coater AirFlow Rate	Coater Inlet Temp	Coater Percent Coating	Coater Spray Rate	Coater Spray Time
%20180227-24235-01A	2	2018-02-27 16:36:16	2018-02-27 16:52:48	220.0387795	84.92957115	3.006246574	54.98060106	13.59373172
%... -> 

%Modifies:NA
%Effect: Merges,sorts, and cleans data from Coater A and Coater B 
%        to produce single cell array Coater A/B composed of all online
%        Coating Data


function processedCoatingArray = mergeCoatingWheels(rawA,rawB)
% [~,~,raw_a] = xlsread('20170710-24235-01A.xlsx','Coater 1 Wheel');
% [~,~,raw_b] = xlsread('20170710-24235-01A.xlsx','Coater 2 Wheel');

%Add Coater A label to Coater A data
coaterA = cell(size(rawA,1),1);
coaterA(:) = {'A'};
coaterA(1) = {'Coater'};
rawA = [rawA(:,1) coaterA rawA(:,2:end)];


%Add Coater B label to Coater A data
coaterB = cell(size(rawB,1),1);
coaterB(:) = {'B'};
coaterB(1) = {'Coater'};
rawB = [rawB(:,1) coaterB rawB(:,2:end)];

%Extracting Column Index of First Relevant Attribute
rawCopy = rawB;
%Finds indices of all cells containing data of type char
nanIndices = cellfun(@ischar,rawB);
%Replaces all cells containing chars with NaN values
 rawCopy(nanIndices) = {nan};
 % Converts raw cell array to numeric matrix
 rawNum = cell2mat(rawCopy);
%Finds column indices of all non-NaN data in numeric raw matrix
[~, col] = find(~isnan(rawNum(2,:)));
%Sets attribute start index to the second element in row
attributeStartIndex = col(2);

%Merge, sort, and extract only unique rows from Coater A and Coater B data
merge = [rawA(2:end,:);rawB(2:end,:)];
sorted = sortrows(merge,3);
[~,ia,~]  = unique(cell2mat(sorted(:,attributeStartIndex:end)),'rows','stable');
uniqueSorted = sorted(ia,:);

%Add back column labels:
uniqueSorted = [rawA(1,:);uniqueSorted];

%Extracting Column Index of Campaign Names
[~,campaignColumn] = find(cellfun(@(x)isequal(x,'CampaignName'),uniqueSorted));

%Extracting Column Index of Coater Type
[~,coaterColumn] = find(cellfun(@(x)isequal(x,'Coater'),uniqueSorted));

%Construct Online column
onlineCol = cell(size(uniqueSorted,1),1);
onlineCol(:) = {'online'};
onlineCol(1) = {'Coater Online or Offline'};

%Contruct Empty Pan load column
panloadCol = cell(size(uniqueSorted,1),1);
panloadCol(:) = {[]};
panloadCol(1) = {'Pan Load(kg)'};

%Construct Coater Run column
%Detect changes in campaign
[~,b,~] = unique(uniqueSorted(2:end,1));
index = [b;size(uniqueSorted(2:end,1),1)];
index(2:end-1) = index(2:end-1) - 1;
index(1) = 0;

coaterRunCol = [];

for i = 1:size(index,1) - 1 
    coaterRunCol(index(i)+1:index(i+1)) = linspace(1,(index(i+1)) - index(i),(index(i+1)) - index(i));
end
coaterRunCol = coaterRunCol.';

coaterRunCol = ['Coater Run#';num2cell(coaterRunCol)];

%Combine Relevant Columns into final array
processedCoatingArray = [uniqueSorted(:,campaignColumn) coaterRunCol  uniqueSorted(:,coaterColumn) onlineCol...
    panloadCol uniqueSorted(:,attributeStartIndex:end)];

%Final processing to remove any remaining NaN values
logical = cellfun(@(x)all(isnan(x)),processedCoatingArray(:,attributeStartIndex:end));
[row,~] = find(logical(:,1));
processedCoatingArray(row,:) = [];
processedCoatingArray(cellfun(@(x)all(isnan(x)),processedCoatingArray)) = {[]};
end







