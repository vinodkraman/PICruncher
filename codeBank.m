%     key = handles.select_campaign_table.Data(selected_row,1);
%     if cell2mat(handles.select_campaign_table.Data(selected_row,4)) == 1
%         if handles.select_campaign_table.Data{selected_row,selected_column}== ' '
%             errordlg('Error: Cell cannot be empty');
%             handles.select_campaign_table.Data{selected_row,selected_column} = eventdata.PreviousData;
%         elseif isempty(handles.select_campaign_table.Data{selected_row,selected_column})
%             errordlg('Error: Cell cannot be empty');
%             handles.select_campaign_table.Data{selected_row,selected_column} = eventdata.PreviousData;
%         else
%             if isempty(handles.axes_struct) == 0
%                 selected_quarter_text = getSelectedQuarterText(eventdata.PreviousData,handles);
%                 selected_quarter_text.String{1} = eventdata.EditData;
%                 quarter_value = handles.select_campaign_table.Data(selected_row,3);
%                 handles.campaign_quarter_map(char(key)) = quarter_value;
%                 guidata(hObject, handles);
%             end
%         end
%     end


%        key = handles.select_campaign_table.Data(selected_row,1);
%        if cell2mat(handles.select_campaign_table.Data(selected_row,4)) == 1
%         if handles.select_campaign_table.Data{selected_row,selected_column}== ' '
%             errordlg('Error: Cell cannot be empty');
%             handles.select_campaign_table.Data{selected_row,selected_column} = eventdata.PreviousData;
%         elseif isempty(handles.select_campaign_table.Data{selected_row,selected_column})
%             errordlg('Error: Cell cannot be empty');
%             handles.select_campaign_table.Data{selected_row,selected_column} = eventdata.PreviousData;
%         else
%             if isempty(handles.axes_struct) == 0
%                 handles.axes1.XTickLabel{selected_row} = eventdata.EditData;
%                 lot_value = handles.select_campaign_table.Data(selected_row,2);
%                 handles.campaign_lot_map(char(key)) = lot_value;    
%                 guidata(hObject, handles);
%             end
%         end    
%        end




% %initilaize activeX server, workbook, and sheet
% e = handles.eactx;
% e.DisplayAlerts = 0;
% ewb = handles.ebook;
% 
% %get column columns
% selected_location = handles.popupmenu1.String(handles.popupmenu1.Value);
% selected_campaign = handles.popupmenu7.String(handles.popupmenu7.Value);
% map1 = handles.rawDataMap(selected_campaign{1});
% locationRawData = map1(selected_location{1});
% labels = locationRawData(1,:);
% 
% %Determine end range letter
% alphabet = 'A':'Z';
% end_letter = alphabet(size(labels,2));
% range = strcat('A1:',strcat(end_letter,'100'));
% 
% %Read Data from Excel Sheet
% eRange = get(handles.eactx,'Range',range);
% appended_data = eRange.Value;
% 
% %Clean appended_data
% out = appended_data(any(cellfun(@(x)any(~isnan(x)),appended_data),2),:);
% %Extract only numeric attribute data
% appended_data = out(2:end,:);
% guidata(hObject, handles);
% 
% %Validate appended_data
% if validateAppendedData(appended_data,handles.appendDataTable.Data) == 1
% %Add Extracted Data to current Data in Table
% current_data = handles.appendDataTable.Data;
% current_data = [current_data;appended_data];
% handles.appendDataTable.Data = current_data;
% else
%     errordlg('Error: Incorrect Input types entered')
% end



% % current_data = handles.appendDataTable.Data;
% % new_row = cell(1,size(current_data,2));
% % current_data = [current_data;new_row];
% % handles.appendDataTable.Data = current_data;
% e = actxserver('Excel.Application');
% eWorkbook = e.Workbooks.Add;
% e.Visible = 1;
% e.DisplayAlerts = 0;
% handles.ebook = eWorkbook;
% eSheets = e.ActiveWorkbook.Sheets;
% eSheet1 = eSheets.get('Item',1);
% eSheet1.Activate
% handles.esheet = eSheet1;
% handles.eactx = e;
% 
% selected_location = handles.popupmenu1.String(handles.popupmenu1.Value);
% selected_campaign = handles.popupmenu7.String(handles.popupmenu7.Value);
% map1 = handles.rawDataMap(selected_campaign{1});
% locationRawData = map1(selected_location{1});
% labels = locationRawData(1,:);
% 
%  alphabet = 'A':'Z';
%  end_letter = alphabet(size(labels,2));
%  range = strcat('A1:',strcat(end_letter,'1'));
% 
% eActivesheetRange = get(e.Activesheet,'Range',range);
% eActivesheetRange.Value = labels;



% if selected_row <= dimension_bounds(1)
%     [~,pan_load_column] = find(cellfun(@(x)isequal(x,'Pan Load(kg)'),data));
%     if isempty(pan_load_column) == 1
%         data{selected_row,selected_column} = eventdata.PreviousData;
%         handles.appendDataTable.Data = data; 
%         guidata(hObject, handles);%{selected_row,selected_column} = eventdata.PreviousData;
%         errordlg('Error: Cannot edit selected data!')
%         guidata(hObject, handles);
%     elseif selected_column ~= pan_load_column
%         data{selected_row,selected_column} = eventdata.PreviousData;
%         handles.appendDataTable.Data = data; 
%         guidata(hObject, handles);%{selected_row,selected_column} = eventdata.PreviousData;
%         errordlg('Error: Cannot edit selected data!')
%         guidata(hObject, handles);
%     elseif isnan(str2double(eventdata.NewData))== 1
%         data{selected_row,selected_column} = eventdata.PreviousData;
%         handles.appendDataTable.Data = data; 
%         guidata(hObject, handles);
%         errordlg('Error: Invalid Input!')
%         guidata(hObject, handles);
%     end
% elseif isnan(str2double(eventdata.NewData))== 1
%     if validateInput(eventdata.NewData,eventdata.Indices,handles.appendDataTable.Data)== false
%         handles.appendDataTable.Data{selected_row,selected_column} = eventdata.PreviousData;
%         errordlg('Error: Invalid Input!')
%         guidata(hObject, handles);
%     end
% elseif isnan(str2double(eventdata.NewData))== 0
%     if validateInput(str2double(eventdata.NewData),eventdata.Indices,handles.appendDataTable.Data)== false
%         handles.appendDataTable.Data{selected_row,selected_column} = eventdata.PreviousData;
%         errordlg('Error: Invalid Input!')
%         guidata(hObject, handles);
%     end
% end


% if isempty(handles.IPC_UL_edit.String)
%     handles.IPC_UL_edit.String = '9999';
% end
% if isempty(handles.axes_struct) == 0
%     UL_line = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','UL');
%     UL_line.YData(:) = str2num(handles.IPC_UL_edit.String);
%     
%     if str2num(handles.IPC_UL_edit.String) > str2num(handles.edit55.String)
%         handles.edit55.String = num2str(1.01*str2num(handles.IPC_UL_edit.String));
%         handles = updateYAxis(handles);
%         guidata(hObject, handles);
%     end
% 
%     %Saves edits into corresponding axes in axes_struct. Allows for changed fig
%     %properties to remain when using slider
%     if handles.radiobutton9.Value ~= 1
%        ax = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
%         handles.axes1 = ax;
%     end
%      guidata(hObject, handles);
%end



% if isempty(handles.edit38.String)
%     handles.edit38.String = '-100000';
% end
% if isempty(handles.axes_struct) == 0
%     LL_line = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','LL');
%     LL_line.YData(:) = str2num(handles.edit38.String);
%     
%     if str2num(handles.edit38.String) < str2num(handles.edit53.String)
%         handles.edit53.String = num2str(.97*str2num(handles.edit38.String));
%         handles = updateYAxis(handles);
%         guidata(hObject, handles);
%     end
% 
%     %Saves edits into corresponding axes in axes_struct. Allows for changed fig
%     %properties to remain when using slider
%     if handles.radiobutton9.Value ~= 1
%        ax = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
%         handles.axes1 = ax;
%     end




%     if handles.radiobutton4.Value == 1
%         if handles.radiobutton9.Value == 1
%             handles.axes_struct = gobjects(0);
%             index = handles.popupmenu4.Value;
%             selected_attribute = handles.popupmenu4.String(index);
% 
%             location_index = handles.popupmenu1.Value;
%             location = handles.popupmenu1.String(location_index);
% 
%             oldpointer = get(handles.figure1, 'pointer'); 
%             set(handles.figure1, 'pointer', 'watch') 
%             drawnow;
%             InterfaceObj=findobj(handles.figure1,'Enable','on');
%             set(InterfaceObj,'Enable','off');
% 
% 
%     %         for i = 1:size(handles.test_selected_campaigns,2)
%     %             data = Copy_of_getAttributeData(handles.test_selected_campaigns{i},char(location),char(selected_attribute),handles); %gets data for specified campaign, location, and attribute
%     %             column_labels = data(1,:);
%     %             allCampaignAttributeData = [allCampaignAttributeData;data(2:end,:)];
%     %         end
%     %         
%     %         %delete(asda);
%     %         allCampaignAttributeData = [column_labels;allCampaignAttributeData];
%             %handles.allCampaignAttributeData(selected_attribute{1}) = allCampaignAttributeData;
%             %selectedLocation,selectedAttribute,handles
%             allCampaignAttributeData = getAttributeDataAllCampaigns(handles.test_selected_campaigns,location,selected_attribute,handles);
%             if sum(sum((cellfun(@(x)any(isnan(x)),allCampaignAttributeData)))) > 0
%                 errordlg('Error: Selected Attribute Data contains NaN values!')
%             elseif sum(sum((cellfun(@(x)any(isempty(x)),allCampaignAttributeData)))) > 0
%                 errordlg('Error: Selected Attribute Data contains empty values!')
%             else
%                 handles.axes1 = copyaxes(Copy_of_trend_chart_data(allCampaignAttributeData,handles),handles.axes1);
%                 handles.axes_struct(end+1) = handles.axes1;
%                 handles = updateFigureProperties(handles);
%                 set(handles.figure1, 'pointer', oldpointer)
%                 set(InterfaceObj,'Enable','on');
%                 guidata(hObject,handles);
%             end
%         elseif handles.radiobutton11.Value == 1 
%             oldpointer = get(handles.figure1, 'pointer'); 
%             set(handles.figure1, 'pointer', 'watch')
%             drawnow;
%             InterfaceObj=findobj(handles.figure1,'Enable','on');
%             set(InterfaceObj,'Enable','off');
% 
%             handles.axes_struct = gobjects(0);
%             test_attribute_labels = handles.popupmenu4.String;
%             location_index = handles.popupmenu1.Value;
%             location = handles.popupmenu1.String(location_index);
% 
%             for i = 1:size(test_attribute_labels,1) 
%                 allCampaignAttributeData = getAttributeDataAllCampaigns(handles.test_selected_campaigns,location,test_attribute_labels(i),handles);
%                 handles.axes_struct(end+1) = Copy_of_trend_chart_data(allCampaignAttributeData,handles);
%             end
%             set(handles.figure1, 'pointer', oldpointer)
%             set(InterfaceObj,'Enable','on');
% 
%     %THIS IS IMPORTANT KEEP THIS AS REFERENCE!!!!
%     %         all_attribute_labels = handles.attribute_labels;
%     % 
%     %         for i = 1:size(all_attribute_labels,2)
%     %             attribute_data = handles.attribute_data_map(char(all_attribute_labels(i)));
%     %             if sum(sum((cellfun(@(x)any(isnan(x)),attribute_data)))) > 0
%     %                 errordlg('Error: Selected Attribute Data contains NaN values!')
%     %             elseif sum(sum((cellfun(@(x)any(isempty(x)),attribute_data)))) > 0
%     %                 errordlg('Error: Selected Attribute Data contains empty values!')
%     %             else
%     %                 handles.axes_struct(end+1) = Copy_of_trend_chart_data(attribute_data,handles);
%     %             end
%     %         end
% 
% 
% 
% 
%     %         handles.slider2.Enable = 'on';
%     %         maxSliderValue = get(handles.slider2, 'Max');
%     %         minSliderValue = get(handles.slider2, 'Min');
%     %         theRange = maxSliderValue - minSliderValue;
%     %         num_attribute_labels = size(handles.attribute_labels,2);
%     %         small_step_size = 1/(num_attribute_labels - 1);
%     %         steps = [small_step_size,2*small_step_size];
%     %         set(handles.slider2, 'SliderStep', steps);    
%               handles = configureSlider(handles);
%               guidata(hObject,handles);
% 
%              axes_index = ceil((1-handles.slider2.Value) * size(handles.attribute_labels,2));
%              if axes_index == 0
%                  axes_index = 1;
%              end
%              handles.axes1 = copyaxes(handles.axes_struct(axes_index),handles.axes1);
%              handles = updateFigureProperties(handles);
%              guidata(hObject, handles);
%         else   
%             if isempty(handles.selectedAttributes) == 0
%                 oldpointer = get(handles.figure1, 'pointer'); 
%                 set(handles.figure1, 'pointer', 'watch') 
%                 InterfaceObj=findobj(handles.figure1,'Enable','on');
%                 set(InterfaceObj,'Enable','off');
%                 drawnow;
% 
%                 handles.axes_struct = gobjects(0);
%                 attributeLabels = handles.selectedAttributes;
%                 locationIndex = handles.popupmenu1.Value;
%                 location = handles.popupmenu1.String(locationIndex);
% 
%                 for i = 1:size(attributeLabels,2) 
%                     allCampaignAttributeData = getAttributeDataAllCampaigns(handles.test_selected_campaigns,location,attributeLabels(i),handles);
%                     handles.axes_struct(end+1) = Copy_of_trend_chart_data(allCampaignAttributeData,handles);
%                 end
%                 set(handles.figure1, 'pointer', oldpointer)
%                 set(InterfaceObj,'Enable','on');
% 
%                 handles = configureSlider(handles);
%                 guidata(hObject,handles);
% 
%         %          axes_index = ceil((1-handles.slider2.Value) * size(handles.attribute_labels,2));
%         %          if axes_index == 0
%         %              axes_index = 1;
%         %          end
%                  handles.axes1 = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
%                  handles = updateFigureProperties(handles);
%                  guidata(hObject, handles);
%             end
%         end
%     end



% index = handles.popupmenu4.Value;
% selected_attribute = handles.popupmenu4.String(index);
% location_index = handles.popupmenu1.Value;
% location = handles.popupmenu1.String(location_index);
% allCampaignAttributeData = {};
% for i = 1:size(handles.test_selected_campaigns,2)
%     allCampaignAttributeData = [allCampaignAttributeData;getAttributeData(handles.test_selected_campaigns{i},char(location),char(selected_attribute),handles)];
% end



% if isempty(handles.edit53.String) == 0
%     handles.axes_struct(getAxesIndex(handles)).YLim = [str2num(handles.edit53.String),str2num(handles.edit55.String)]; 
%     seperator_line = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','Seperator');
%     for i = 1:size(seperator_line,1)
%         seperator_line(i).YData = [str2num(handles.edit53.String) str2num(handles.edit55.String)];
%     end
%     %seperator_line.YData = [str2num(handles.edit53.String) str2num(handles.edit55.String)];
% 
%     quarter_info_group = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','Quarter Info');
%     for i = 1:size(quarter_info_group.Children,1)
%         text_box = quarter_info_group.Children(i);
%         current_x = text_box.Position(1);
%         new_y = str2num(handles.edit55.String) - 5;
%         text_box.Position = [current_x new_y];
%     end
% 
%     %Allows for any changes in YLim data to remain constant
% 
%     if handles.radiobutton9.Value ~= 1
%        handles.axes1 = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
%     end
% else
%     handles.edit53.String = 'NaN';
% end



% if isempty(handles.edit55.String) == 0
%     handles.axes_struct(getAxesIndex(handles)).YLim = [str2num(handles.edit53.String),str2num(handles.edit55.String)]; 
% 
%     seperator_line = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','Seperator');
%     %seperator_line.YData = [str2num(handles.edit53.String) str2num(handles.edit55.String)];
%     for i = 1:size(seperator_line,1)
%         seperator_line(i).YData = [str2num(handles.edit53.String) str2num(handles.edit55.String)];
%     end
%     
%     quarter_info_group = findobj(handles.axes_struct(getAxesIndex(handles)),'Tag','Quarter Info');
%     for i = 1:size(quarter_info_group.Children,1)
%         text_box = quarter_info_group.Children(i);
%         current_x = text_box.Position(1);
%         new_y = str2num(handles.edit55.String) - 5;
%         text_box.Position = [current_x new_y];
%     end
% 
%     %Allows for any changes in YLim data to remain constant
%     % ax = copyaxes(handles.axes1,handles.axes_struct(getAxesIndex(handles)));
%     % handles.axes_struct(getAxesIndex(handles)) = ax;
%     % 
%     if handles.radiobutton9.Value ~= 1
%        ax = copyaxes(handles.axes_struct(getAxesIndex(handles)),handles.axes1);
%         handles.axes1 = ax;
%     end
% else
%     handles.edit55.String = 'NaN';
% end




        %end
%         elseif handles.radiobutton5.Value == 1
%             handles.axes_struct = gobjects(0);
%             index = handles.popupmenu4.Value;
%             selected_attribute = handles.popupmenu4.String(index);
% 
%             location_index = handles.popupmenu1.Value;
%             location = handles.popupmenu1.String(location_index);
% 
%             oldpointer = get(handles.figure1, 'pointer'); 
%             set(handles.figure1, 'pointer', 'watch') 
%             InterfaceObj=findobj(handles.figure1,'Enable','on');
%             set(InterfaceObj,'Enable','off');
%             drawnow;
% 
%             allCampaignAttributeData = getAttributeDataAllCampaigns(handles.test_selected_campaigns,location,selected_attribute,handles);
%             if sum(sum((cellfun(@(x)any(isnan(x)),allCampaignAttributeData)))) > 0
%                 errordlg('Error: Selected Attribute Data contains NaN values!')
%             elseif sum(sum((cellfun(@(x)any(isempty(x)),allCampaignAttributeData)))) > 0
%                 errordlg('Error: Selected Attribute Data contains empty values!')
%             else
%                 handles.axes1 = copyaxes(controlChartData(allCampaignAttributeData,handles),handles.axes1);
%                 handles.axes_struct(end+1) = handles.axes1;
%                 handles = updateFigureProperties(handles);
%                 set(handles.figure1, 'pointer', oldpointer)
%                 set(InterfaceObj,'Enable','on');
%             end
%         end
        

%         elseif handles.radiobutton5.Value == 1
%             oldpointer = get(handles.figure1, 'pointer'); 
%             set(handles.figure1, 'pointer', 'watch')
%             drawnow;
%             InterfaceObj=findobj(handles.figure1,'Enable','on');
%             set(InterfaceObj,'Enable','off');
% 
%             handles.axes_struct = gobjects(0);
%             test_attribute_labels = handles.popupmenu4.String;
%             location_index = handles.popupmenu1.Value;
%             location = handles.popupmenu1.String(location_index);
% 
%             for i = 1:size(test_attribute_labels,1) 
%                 allCampaignAttributeData = getAttributeDataAllCampaigns(handles.test_selected_campaigns,location,test_attribute_labels(i),handles);
%                 if sum(sum((cellfun(@(x)any(isnan(x)),allCampaignAttributeData)))) > 0
%                     errordlg(strcat('Error: ',test_attribute_labels{i},' Attribute Data contains NaN values!'))
%                     set(handles.figure1, 'pointer', oldpointer)
%                     set(InterfaceObj,'Enable','on');
%                     return;
%                 elseif sum(sum((cellfun(@(x)any(isempty(x)),allCampaignAttributeData)))) > 0
%                     errordlg(strcat('Error: ',test_attribute_labels{i},' Attribute Data contains empty values!'))
%                     set(handles.figure1, 'pointer', oldpointer)
%                     set(InterfaceObj,'Enable','on');
%                     return;
%                 else
%                     handles.axes_struct(end+1) = controlChartData(allCampaignAttributeData,handles);
%                     set(handles.figure1, 'pointer', oldpointer)
%                     set(InterfaceObj,'Enable','on');
%                 end
%             end
%      
%             if size(handles.axes_struct,2) > 0
%                 handles = configureSlider(handles);
%                 handles.axes1 = copyaxes(handles.axes_struct(axes_index),handles.axes1);
%                 handles = updateFigureProperties(handles);
%             end












if isempty(handles.axes_struct) == 0
    if handles.radiobutton9.Value == 1
        
        currentAttribute = handles.popupmenu4.String(index);
        if handles.radiobutton4.Value == 1
            handles = defaultAxes('Variability',currentAttribute,handles);
        else
            handles = defaultAxes('Control',currentAttribute,handles);
        end
    elseif handles.radiobutton11.Value == 1
        if handles.radiobutton4.Value == 1
            handles = defaultAxes('Variability',currentAttribute,handles);
        else
            handles = defaultAxes('Control',currentAttribute,handles);
        end
    elseif handles.radiobutton34.Value == 1
        if handles.radiobutton4.Value == 1
            handles = defaultAxes('Variability',currentAttribute,handles);            
        else
            handles = defaultAxes('Control',currentAttribute,handles);
        end
    end
    
    
    
    source_children = get(source,'Children');
%copyobj([source_children],destination);
copyobj([leg,source],destination.Parent)

% copyobj(leg,destination);
destination.XTick = source.XTick;
destination.XTickLabel = source.XTickLabel;
destination.XLabel = source.XLabel;
destination.YLabel = source.YLabel;
destination.YLim = source.YLim;
destination.XLim = source.XLim;
destination.Title.String = source.Title.String;
destination.Box = 'on';