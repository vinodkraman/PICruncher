%Requires: campaign_name to be of type str or char
%Modifies: NA
%Effects: checks whether an Excel workbook with the filename specified by
%         campaign_name exists in specified path. Returns true if found, else
%         returns false

function contains = checkFolderContents(campaign_name,handles)

    filename = strcat(strtrim(campaign_name),'.xlsx');
    fullpath = fullfile(handles.filePathText.String,filename);
    d = dir(fullpath);

    if size(d,1) > 0
        contains = true;
    else 
        contains = false;
    end
end