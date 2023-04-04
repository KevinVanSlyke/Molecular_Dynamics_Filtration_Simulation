function y = lj(x,epsilon,Sigma)
%%The LJ potential

y = zeros(size(x));
for i = 1:length(x)
        y(i) = 4*epsilon*((Sigma/x(i))^12-(Sigma/x(i))^6);
end
end