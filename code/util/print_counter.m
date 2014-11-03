function  print_counter( counter )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    reverseStr = repmat(sprintf('\b'), 1, length(num2str(counter-1)));
    fprintf(1,strcat(reverseStr,'%d'),counter);
    
end

