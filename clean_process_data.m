tic
[status,sheets,xlFormat] = xlsfinfo('20170217-CSV-1A.xlsx');
toc
%We populate the Available Attribute Popup Menu with these 12 options
%Location labels fills in popup menu
locations_labels = sheets(2:end);
num_locations = size(sheets(2:end),2);
location_data = {};


for i = 1:num_locations 
    [~,~,raw] = xlsread('20170217-CSV-1A.xlsx',locations_labels{i});
    location_data{i} = raw;
end

keySet = locations_labels;
valueSet = location_data;
location_data_map = containers.Map(keySet,valueSet);

%this is after you select locatio
Blender_1_Inlet = location_data_map('Blender 1 inlet');
[~,end_time_index] = find(cellfun(@(x)isequal(x,'EndTime'),Blender_1_Inlet));
attribute_start_index = end_time_index + 1;

%attribute_labels fills in the table and all the popup menu
attribute_labels = Blender_1_Inlet(1,attribute_start_index:end);

%Now what happens when you select an attribute, you should get the data in
%a way such that is a m x 2 where the two columns are the campaign name and
%the data and the number of rows go by PK. We can by having a selected
%attribute matrix as a struct in handles, and to get that data we just find
%the column index of that attribte, find the column index of the campaign
%column, and only extract those two columns out.

selected_attribute = 'Blender Speed';
tets = extract_selected_data(Blender_1_Inlet,selected_attribute);





%So to get the attributes we just need to find the EndTime column index,
%and then go go from 1+ that index to the totla number of columns in that
%array


%Then if use selects one of these attributes, we need to get to that data
%sheet which we can do using a map(key:value pair where the key is location
%and the value is the processed array!)



