%Effects: Updates Figure Properties UIPanel
function handles = updateFigureProperties(handles)

    %Updates all edit texboxes
    handles.plotTitleEdit.String = handles.axes1.Title.String;
    handles.plotXLabelEdit.String = handles.axes1.XLabel.String;
    handles.plotYLabelEdit.String = handles.axes1.YLabel.String;
    handles.plotYLLimEdit.String = handles.axes1.YLim(1);
    handles.plotYULimEdit.String = handles.axes1.YLim(2); 
    
    %Update Section Boxes
    sectionGroup = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','Section Box');
    sectionBox = sectionGroup.Children(1);
    handles.plotYBoxEdit.String = num2str(sectionBox.Position(2));
    if handles.flipBoxRadioButton.Value == 1
        for i = 1:size(sectionGroup.Children,1)
            sectionBox = sectionGroup.Children(i);
            sectionBox.Rotation = 90;
        end
    else 
        for i = 1:size(sectionGroup.Children,1)
            sectionBox = sectionGroup.Children(i);
            sectionBox.Rotation = 0;
        end
    end
    
    %Update Upper and Lower Limits
    if handles.trendChartOption.Value == 1 
        UL = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','UL');
        handles.ULEdit.String = num2str(UL.YData(1));

        LL = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','LL'); 
        handles.LLEdit.String = num2str(LL.YData(1));

        boxplot = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','Boxplot'); 
        if strcmp(boxplot(1).Visible,'on') == 1
            handles.boxplotToggleButton.Value = 1;
        else 
            handles.boxplotToggleButton.Value = 0;
        end
    end
end