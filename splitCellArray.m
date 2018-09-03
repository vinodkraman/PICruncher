%Requires:Input cellArray to be a nx2 cell array with the data organized
%         by column 1
%Modifies: NA
%Effects: Splits an input nx2 cell array based on values in 1st column

function splitArray = splitCellArray(cellArray,columnIndex)
    splitArray = cell(size(columnIndex,2),1);
    updatedColumnIndex = [columnIndex size(cellArray,1)];

    for i = 1:size(updatedColumnIndex,2)-1
        splitArray{i} = cellArray(updatedColumnIndex(i):updatedColumnIndex(i+1));
        updatedColumnIndex(i+1) = updatedColumnIndex(i+1) + 1;
    end
end


