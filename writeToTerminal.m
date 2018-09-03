function handles = writeToTerminal(message,handles)  
  handles.terminal_output{end+1,1} = strcat('>> ',message);
  handles.terminalEdit.String = handles.terminal_output;
end