
function joinedArray = joinCellArray(cell_array,columnIndices)
    joinedArray = cell(size(columnIndices,1),1);
    updatedJoinIndices = [columnIndices;(size(cell_array,1)+1)];
    for i = 1:size(columnIndices,1)
        joinedArray{i} = cell_array(updatedJoinIndices(i):updatedJoinIndices(i+1)-1); 
    end
end

