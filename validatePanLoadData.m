function valid = validatePanLoadData(importedData,currentDataSize)

    try
    %convert cell array to numeric matrix 
    importedData = cell2mat(importedData);
    valid = false;
        if size(importedData,1) == currentDataSize
            valid = true;
        end
    
    catch
        valid = false;
    end

end