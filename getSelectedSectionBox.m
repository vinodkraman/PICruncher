%Required: Input sectionName be of type char or str
%Modifies: NA
%Effect: returns Section Box Object whose text matches sectionName
function obj = getSelectedSectionBox(sectionName,handles)
    %Intialization 
    obj = 0;
    %Get section box group from tag
    sectionBoxGroup = findobj(handles.axes1,'Tag','Section Box');
    
    %Iterate through each section box and return the box that contains same
    %text as sectionName
    for i = 1:size(sectionBoxGroup.Children,1)
        sectionBox = sectionBoxGroup.Children(i);
        sectionBoxString = sectionBox.String{1};
        
        if strcmp(sectionName,sectionBoxString) == 1
            obj = sectionBox;
            break;
        end
    end
    
end