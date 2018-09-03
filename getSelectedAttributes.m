%Requires:NA
%Modifies:NA
%Effects:Returns column-wise cell array of all campaigns selected in
%        campaignSelecttable
function selectedAttributes = getSelectedAttributes(handles)
    data = handles.availableAttributeTable.Data;
    log = logical(sum(cellfun(@(x)isequal(x,1),data),2));
    selectedAttributes = data(log,1).';  
end