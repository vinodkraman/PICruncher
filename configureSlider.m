%Requires: NA
%Modifies: NA
%Effects: Enables plot slider and sets the small step size and large step
%         size based on number of attribute labels
function handles = configureSlider(handles) 
    
    numAttributeLabels = size(handles.axes_struct,2);
    
    if numAttributeLabels > 1
        handles.slider2.Enable = 'on';
        maxSliderValue = get(handles.slider2, 'Max');
        minSliderValue = get(handles.slider2, 'Min');
        range = maxSliderValue - minSliderValue;
        smallStepSize = 1/(numAttributeLabels - 1);
        steps = [smallStepSize,2*smallStepSize];
        set(handles.slider2, 'SliderStep', steps);
    end
end