function y = wca(x,epsilon,Sigma)
%%The LJ potential

y = zeros(size(x));
for i = 1:length(x)
    if x(i) < 2^(1/6)*Sigma
        y(i) = 4*epsilon*((Sigma/x(i))^12-(Sigma/x(i))^6)+epsilon;
    else
        y(i) = 0;
    end

end
end