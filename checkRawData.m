
%Requires: Input raw to be a 1D nested cell array, with each inner cell
%          array corresponding to attribute data for a specific campaign
%Modifies: NA
%Effects: Checkss for whether raw data can be plotted. Returns true if no
%         NaN or empty values are found, returns false if found
function valid = checkRawData(raw,handles)
    valid = true;
    for i = size(raw,2)
        if sum(sum((cellfun(@(x)any(isnan(x)),raw{i})))) > 0
            %errordlg('Error: Selected Attribute Data contains NaN values!')
            valid = false;
            
           % handles.statusBarStaticText.String = 'Error: Selected Attribute Data contains NaN values!';
            break;
        elseif sum(sum((cellfun(@(x)any(isempty(x)),raw{i})))) > 0
            %errordlg('Error: Selected Attribute Data contains empty values!')
            valid = false;
            %handles.statusBarStaticText.String = 'Error: Selected Attribute Data contains empty values!';
            break;
        end
    end
end