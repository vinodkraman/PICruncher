%Requires: NA
%Modifies: NA
%Effects: Clears all Figure Properties in UIPanel
function handles = clearFigProps(handles)
    handles.plotTitleEdit.String = ' ';
    handles.plotXLabelEdit.String = ' ';
    handles.plotYLabelEdit.String = ' ';
    handles.plotYLLimEdit.String = ' ';
    handles.plotYULimEdit.String = ' ';
    handles.plotYBoxEdit.String = ' ';
end