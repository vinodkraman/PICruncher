%Effect: update upper and lower limits
function handles = updateLimits(limit,handles)
%Check that axes_struct is not empty
if isempty(handles.axes_struct) == 0
    %Check if limit modified is the UL
    if strcmp(limit,'UL')
        %Get handle to ULLine object using its associated Tag
        ULLine = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','UL');
        
        %Check whether the String in ULEdit is empty, if so turn visibility of the UL
        %to off
        if isempty(handles.ULEdit.String)
            handles.ULEdit.String = '100000';
            ULLine.Visible = 'off';
            
        %Update ULLine and the YLim as needed
        else
            ULLine.Visible = 'on';
            ULLine.YData(:) = str2num(handles.ULEdit.String);
            
            if str2num(handles.ULEdit.String) > str2num(handles.plotYULimEdit.String)
                handles.plotYULimEdit.String = num2str(1.01*str2num(handles.ULEdit.String));
                handles = updateYAxis(handles);
            end
        end
        
    %Check if limit modified is the LL
    elseif strcmp(limit,'LL')
        
        %Get handle to ULLine object using its associated Tag
        LL_line = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','LL');
        
        %Check whether the String in LLEdit is empty, if so turn visibility of the UL
        %to off
        if isempty(handles.LLEdit.String)
            handles.LLEdit.String = '-100000';
            LL_line.Visible = 'off';
        
        %Update ULLine and the YLim as needed
        else
            LL_line.Visible = 'on';
            LL_line.YData(:) = str2num(handles.LLEdit.String);
            
            if str2num(handles.LLEdit.String) < str2num(handles.plotYLLimEdit.String)
                handles.plotYLLimEdit.String = num2str(.97*str2num(handles.LLEdit.String));
                handles = updateYAxis(handles);
            end
        end
    end
    
    %Copy corresponding axes from the axes_struct into the viewable
    %handles.axes1
    ax = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
    handles.axes1 = ax;
    
end