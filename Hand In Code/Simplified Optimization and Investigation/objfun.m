% Made by Toon Stolk and Pieter Bijl as part of the course Engineering Optimization
% at Delft University of Technology
% 
% objfun.m
% The obj.m function is the function that evaluates the cost per kWh
% given a current market state x (11x1) vector. It takes the global
% variables energy_cost, capital_loan_duration build_cost and subsidies to
% calculate what according to those variables cost would be.
% It returns that state along with the gradient to be used in fmincon().
% Dependencies:
% jacobjfun.m

function [f, g] = objfun(x)
    global energy_cost capital_loan_duration build_cost subsidies
    % Calculate the multplication factor
    M_f = ones(2,1);
    M_f(2) = 4*x(2)^2-4*x(2)+2;
    new_cost = x.*(M_f.*(build_cost/(capital_loan_duration*8760)+energy_cost)+subsidies');
    % Calculate the cost
    f = sum(new_cost);
    % Calculate the gradient
    g = jacobjfun(x);
end