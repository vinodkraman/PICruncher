function handles = defaultAxes(chartType,currentAttribute,handles)
    location_index = handles.popupmenu1.Value;
    location = handles.popupmenu1.String(location_index);
    
    if strcmp(chartType,'Variability') == 1
        allCampaignAttributeData = getAttributeDataAllCampaigns(getSelectedCampaigns(handles),location,currentAttribute,handles);
        default_axes = trendChartData(allCampaignAttributeData,handles);
        ax =  copyaxes(default_axes,handles.axes_struct(getAxesIndex(handles)));
        handles.axes_struct(getAxesIndex(handles)) = ax;
        handles.axes1 = ax;
    elseif strcmp(chartType,'Control') == 1
        allCampaignAttributeData = getAttributeDataAllCampaigns(getSelectedCampaigns(handles),location,currentAttribute,handles);
        default_axes = controlChartData(allCampaignAttributeData,handles);
        ax =  copyaxes(default_axes,handles.axes_struct(getAxesIndex(handles)));
        handles.axes_struct(getAxesIndex(handles)) = ax;
        handles.axes1 = ax;
    end

end