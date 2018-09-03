
function processed_coating_array  = process_coating_wheel_updated(coater_type,raw)

%Extracting Coater Type
%coater_type = 'A';

%Extracting Column Index of First Relevant Attribute
raw_copy = raw;
%Finds indices of all cells containing data of type char
nan_indices = cellfun(@ischar,raw);
%Replaces all cells containing chars with NaN values
raw_copy(nan_indices) = {nan};
%Converts raw cell array to numeric matrix
raw_num = cell2mat(raw_copy);
%Finds column indices of all non-NaN data in numeric raw matrix
[~, col] = find(~isnan(raw_num(2,:)));
%Sets attribute start index to the second element in row
attribute_start_index = col(2);

%Extracting Column Index of Campaign Names
[~,Campaign_column] = find(cellfun(@(x)isequal(x,'CampaignName'),raw));

%Extracting Column Index of ProductKey
[~,PK_column] = find(cellfun(@(x)isequal(x,'ProductKey'),raw));

%Eliminate repeating coating data by deleting every third row
truncate_raw_mat = [raw(1,:);raw(2:3:end,:)];

%Construct Empty Coater Type column
coater_col = cell(size(truncate_raw_mat(2:end,:),1),1);
coater_col(:) = {coater_type};
coater_col = ['Coater';coater_col];

%Construct Empty Online column
online_col = cell(size(truncate_raw_mat(2:end,:),1),1);
online_col(:) = {'online'};
online_col = ['Coater Online of Offline';online_col];

%Contruct Empty Pan load column
panload_col = cell(size(truncate_raw_mat(2:end,:),1),1);
panload_col(:) = {[]};
panload_col = ['Pan Load(kg)';panload_col];

%Construct Empty Coating Run Column
coating_run_col = cell(size(truncate_raw_mat(2:end,:),1),1);
coating_run_col(:) = {[]};
coating_run_col = ['Coating Run#';coating_run_col];

%Combine all relevant coating data
processed_coating_array = [truncate_raw_mat(:,PK_column), truncate_raw_mat(:,Campaign_column) coating_run_col coater_col online_col...
    panload_col truncate_raw_mat(:,attribute_start_index:end)];
end