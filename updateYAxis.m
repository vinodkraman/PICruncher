%Effect: Update YAxis and associated objects
function handles = updateYAxis(handles)
   %Check that String in the plotYLLimEdit Box is not empty
    if isempty(handles.plotYLLimEdit.String) == 0
        %Change the YLim of the current viewable axes in the axes_struct
        handles.axes_struct(getAxesIndex(handles)).YLim = [str2num(handles.plotYLLimEdit.String),str2num(handles.plotYULimEdit.String)];
        
        %Update the length of each seperator line by first getting the
        %handles to the object through its tag, and then changing its YData
        seperatorLine = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','Seperator');
        for i = 1:size(seperatorLine,1)
            seperatorLine(i).YData = [str2num(handles.plotYLLimEdit.String) str2num(handles.plotYULimEdit.String)];
        end
    
        %Update locations of section boxes on axes
        sectionGroup = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','Section Box');
        for i = 1:size(sectionGroup.Children,1)
            sectionBox = sectionGroup.Children(i);
            currentX = sectionBox.Position(1);
            ULPos = str2num(handles.ULEdit.String);
            newY = (str2num(handles.plotYULimEdit.String) + ULPos)/2;
            sectionBox.Position = [currentX newY];
            handles.plotYBoxEdit.String = num2str(newY);
        end

        %Update X-axis Label Location
        handles.axes_struct(getAxesIndex(handles)).XLabel.Position =...
            [handles.axes_struct(getAxesIndex(handles)).XLim(2) ...
            handles.axes_struct(getAxesIndex(handles)).YLim(1)];

        %Copy current axes from the axes_struct into the viewable axes
        %handles.axes1
        handles.axes1 = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);

    else
        handles.plotYLLimEdit.String = 'NaN';
    end
end