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
    M_f = ones(11,1);
    M_f(2) = x(2)+1;
    M_f(4) = x(4)+1;
    M_f(7) = 4*x(7)^2-4*x(7)+2;
    M_f(8) = 2-x(8);
    M_f(9) = 4*x(9)^2-4*x(9)+2;
    M_f(10) = 4*x(10)^2-4*x(10)+2;
    M_f(11) = 4*x(11)^2-4*x(11)+2;
    % Calculate the cost
    new_cost = x.*(M_f.*(build_cost/(capital_loan_duration*8760)+energy_cost)+subsidies');
    f = sum(new_cost);
    % Calculate the gradient
    g = jacobjfun(x);
end