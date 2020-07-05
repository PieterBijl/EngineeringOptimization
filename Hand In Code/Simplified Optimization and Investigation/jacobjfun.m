function dfdx = jacobjfun(x)
% Made by Toon Stolk and Pieter Bijl as part of the course Engineering Optimization
% at Delft University of Technology
% 
% jacobjfun.m
% jacobjfun.m is a function to determine the analytical derivatives of the
% cost functions at a point x.
% input:
% State vector x
% Dependencies:
% None
    global energy_cost capital_loan_duration build_cost subsidies
    dfdx = zeros(2,1);
    
    % Determine coefficient
    c1 = build_cost/(capital_loan_duration*8760)+energy_cost;
    dfdx(1) = c1(1) + subsidies(1); % Constant multiplication factor
    dfdx(2) = 12 * c1(2) * x(2)^2 - 8 * c1(2) * x(2) + 2 * c1(2) + ...
        subsidies(2); % Parabolic multiplication factor
end