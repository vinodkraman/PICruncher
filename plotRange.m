%Requires: index be of numeric type, data be a numeric vector
%Modifies: NA
%Effects: Returns a group object that acts as a range bar for a scatter
%         plot of data

function hggroup_range = plotRange(index,data)
    hggroup_range = hggroup;
    %Center Vertical bar
    line([index index],[min(data) max(data)],'LineWidth',1.5,'Color','k','Parent',hggroup_range);
    %Top horizontal Cap
    line([(index - .05) (index + .05)], [max(data) max(data)],'LineWidth',1.5,'Color','k','Parent',hggroup_range)
    %Botton horizontal Cap
    line([(index - .05) (index + .05)], [min(data) min(data)],'LineWidth',1.5,'Color','k','Parent',hggroup_range)
end