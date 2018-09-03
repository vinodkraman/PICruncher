%Requires: Input content and data to both be cell arrays with equal number
%          of columns
%Modifies:NA
%Effects: Determines whether appendedData is valid input by comparing each row of
%         the appended dataset to the last row of the current data and
%         checking whether the same data types exist in every column. If
%         the data types of each column in the appendedData do not match
%         the data type of the corresponding column in the current data,
%         valid is set to false
function valid = validateAppendedData(appendedData,currentData)
    valid = true;
    lastDataRow = currentData(end,:);
    for j = 1:size(appendedData,1)
        for i = 1:size(appendedData,2)
            variable_type = class(appendedData{j,i});
            if isa(lastDataRow{i},variable_type) == 0
                valid = false;
                break;
            end
        end
    end
end