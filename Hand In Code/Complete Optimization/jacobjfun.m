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
    dfdx = zeros(11,1);
    % Determine coefficients
    c1 = build_cost/(capital_loan_duration*8760)+energy_cost;
    % Calculate the analytical derivatives.
    dfdx(1) = c1(1) + subsidies(1);
    dfdx(2) = x(2) * c1(2) + c1(2) + subsidies(2);
    dfdx(3) = c1(3) + subsidies(3);
    dfdx(4) = x(4) * c1(4) + c1(4) + subsidies(4);
    dfdx(5) = c1(5) + subsidies(5);
    dfdx(6) = c1(6) + subsidies(6);
    dfdx(7) = 12 * c1(7) * x(7)^2 - 8 * c1(7) * x(7) + 2 * c1(7) + ...
        subsidies(7); % Linearly increasing multiplication factor
    dfdx(8) = -2 * x(8) * c1(8) + (2 * c1(8) + subsidies(8));
    dfdx(9) = 12 * c1(9) * x(9)^2 - 8 * c1(9) * x(9) + 2 * c1(9) + ...
        subsidies(9); % Linearly increasing multiplication factor
    dfdx(10) = 12 * c1(10) * x(10)^2 - 8 * c1(10) * x(10) + 2 * c1(10) + ...
        subsidies(10); % Parabolic multiplication factor
    dfdx(11) = 12 * c1(11) * x(11)^2 - 8 * c1(11) * x(11) + 2 * c1(11) + ...
        subsidies(11); % Parabolic multiplication factor
end