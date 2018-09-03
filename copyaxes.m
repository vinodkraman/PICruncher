%Requires: sournce and destination be handles to undeleted axes
%Modifies: destination
%Effects: Copies source axes into destination axes and returns handle to copied axes. 
%Note that for some reason pass-by-refernce does not work here and so you must reassign
%desination to the output of copyaxes.

%Example Usage: 
%handles.axes1 = copyaxes(handles.axes2,handles.axes1,handles)
%Notice how we must reassign the destination axes to the output of copyaxes

function newHandleAxes = copyaxes(source,destination,handles)


%Obtain Destination Info
destPos = destination.Position;
destParent = destination.Parent;
destUnits = destination.Units;

%Copy source axes w/ legend
%leg = source.Legend;
leg = findobj(source.Parent, 'Type', 'Legend');
def = get(source,'default');
newHandle = copyobj([leg source], destParent);

%Set source axes properties to destination properties
newHandle(2).Parent = destParent;
newHandle(1).Parent = destParent;
newHandle(2).Units = destUnits;
newHandle(2).Position = destPos;
set(newHandle(2),'default',def)
newHandleAxes = newHandle(2);

%Delete destination axis
delete(destination)
end