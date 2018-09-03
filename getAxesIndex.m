%Requires:NA
%Modifies:NA
%Effect: returns the index in axes_struct of the current visible
%        axes(handles.axes1)
 
function axes_index = getAxesIndex(handles) 

    numAttributes = size(handles.axes_struct,2);
    axes_index = ceil((1-handles.slider2.Value) * numAttributes);
    
    %Since you cannot index starting with 0
    if handles.individualPlotOption.Value == 1
        axes_index = 1;
    elseif axes_index == 0
        axes_index = 1;
    end
end