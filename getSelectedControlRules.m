function rules = getSelectedControlRules(handles)
rules = {};
    if handles.checkbox11.Value == 1
        rules(end+1) = {'n1'};
    end
    if handles.checkbox24.Value == 1
        rules(end+1) = {'n2'};
    end
    if handles.checkbox14.Value == 1
        rules(end+1) = {'n3'};
    end
    if handles.checkbox17.Value == 1
        rules(end+1) = {'n4'};
    end
end