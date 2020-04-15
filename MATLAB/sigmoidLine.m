function y = sigmoidLine(x,a,b,c)

y = zeros(size(x));

% This example includes a for-loop and if statement
% purely for example purposes.
for i = 1:length(x)
    %Logistic function
    y(i) = a+b/(1+exp(-c*x(i)));
        
    %Alternate form of logistic function
    %y(i) = a+b*exp(c*(x(i)-d))/(b+exp(c*(x(i)-d))); 
    
    %Generalized logistic function
    %y(i) = a+(1+exp(-b*(x(i)-c)))^(-d);
    
    %Alternate form of generalized logistic function
    %y(i) = a+b/(1+c*d^(-x(i)));

    %Arctan
    %y(i) = a+b*atan(c*(x(i)-d));
    
    %Algebraic sigmoid
    %y(i) = a+b*x(i)/sqrt(c+(x(i)-d)^2);

    %Another algebraic sigmoid
    %y(i) = a + b*x(i)/(1+c*abs(x(i)-d));
end
end