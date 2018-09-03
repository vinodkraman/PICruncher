%Required: Input campaignName be of type str or char, Input filePath be a
%           valid file path and of type char or str
%Modifies: Current Folder(Adds an Excel File)
%Effect: Imports a data for a given campaign fromt the PI Database into an
%        Excel workbook saved to the specified file path
function importFromPI(campaignName,filePath)
    asmpath= '\\vertex-3\vertex-3\Continuous Manufacturing\PISynTQ\PIData\DLLs';
    asmname='PIData.dll';
    asm=NET.addAssembly(fullfile(asmpath,asmname));
    cls=PIData.Core.Main;
    strtrim(campaignName)
    strcat(filePath,'\')
    r=RetrievePiSynTQAttributes(cls,strtrim(campaignName),strtrim(campaignName),strcat(filePath,'\'));
%'C:\Users\ramanv\Desktop\matlab_scripts\GUI\'
end

