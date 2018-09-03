%Effects: Updates Title of viewable axes
function handles = updateAxesTitle(handles)
    %Update Title of axes in the axes_struct
    handles.axes_struct(getAxesIndex(handles)).Title.String = handles.plotTitleEdit.String;
    %copy the axes in the axes_struct to the viewable axes handles.axes1
    ax = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
    handles.axes1 = ax;
end