function y = expShiftLine(x,a,b,c)

y = zeros(size(x));

% This example includes a for-loop and if statement
% purely for example purposes.
for i = 1:length(x)
    %exp1 Exponential plus shift
    y(i) = a*exp(b*(x(i)))+c;
end
end