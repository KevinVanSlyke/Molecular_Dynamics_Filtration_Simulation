function y = genExpLine(x,a,b,c,d)

y = zeros(size(x));

% This example includes a for-loop and if statement
% purely for example purposes.
for i = 1:length(x)
    %Robust Exponential
    y(i) = a+b*exp(-c*(x(i)-d));
       
end
end