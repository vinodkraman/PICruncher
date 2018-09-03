function valid = validateInput(input,index,data)
    input_variable_type = class(input);
    valid = isa(data{index(1)-1,index(2)},input_variable_type);
end
