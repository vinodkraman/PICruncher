%Requires: campaign,location, and attribute to by of type char or str
%Modifies: NA
%Efects: returns a nx2 cell array of the specified attribute data from the
%        specified location and campaign.
%Example Input: getAttributeData('20170217-CSV-1A','Blender 1','VX661
%                                Percent Target',handles)
%Example Output:      'CampaignName'    'Blender Speed'
%                    '20170217-CSV-1A'      65.9975
%                    '20170217-CSV-1A'      70.0342
%                           ...               ...    

function attributeData = getAttributeData(campaign,location,attribute,handles)
    try
%         %Check whether location is set to coater A/B
%         if strcmp(location,'Coater A/B') == 1
%             allCoaterData = handles.campaignCoatingMap(campaign);
%             attributeData = extractAttributeDataFromSource(allCoaterData,attribute);
%         else
            %CASE 1: campaign is not in rawDataMap
            if isKey(handles.rawDataMap,campaign) == 0 
                filename = strcat(campaign,'.xlsx');
                filepath = fullfile(handles.filePathText.String,filename);
                %Read Raw data from Excel sheet
                [~,~,raw] = xlsread(filepath,location);
                %Add key-value pair to rawDataMap
                handles.rawDataMap(campaign) = containers.Map(location,raw);
                attributeData = extractAttributeDataFromSource(raw,attribute);
            else
                map1 = handles.rawDataMap(campaign);
                %CASE 2: campaign is in rawDataMap but location is not a
                %key in map1(value for specified campaign in rawDataMap)
                if isKey(map1,location) == 0
                   filename = strcat(campaign,'.xlsx');
                   filepath = fullfile(handles.filePathText.String,filename);
                   %Read Raw data from Excel sheet
                   [~,~,raw] = xlsread(filepath,location);
                   %Add key-value pair to map1
                   map1(location) = raw;
                   handles.rawDataMap(campaign) = map1;
                   attributeData = extractAttributeDataFromSource(raw,attribute);
                
                %CASE3: campaign is in rawDataMap and location is in map1
                else
                   locationRawData = map1(location);
                   attributeData = extractAttributeDataFromSource(locationRawData,attribute);
                end
            end
    catch ME
        errordlg(ME.message)
        return;
    end
end