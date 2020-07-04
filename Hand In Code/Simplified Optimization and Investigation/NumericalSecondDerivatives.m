% Made by Toon Stolk and Pieter Bijl as part of the course Engineering Optimization
% at Delft University of Technology
% 
% NumericalDerivatives.m
% The Numerical Derivatives file is a standalone file that computes the
% second order derivatives of the cost function of the market model. The 
% derivatives are computed using a forward finite-difference approximation. 
% The derivatives are represented on a logarithmic plot to determine the 
% stable regime of step sizes used for the numerical differentiation.
% 
% Dependencies:
% PowerPlant.m
% Power Plant Data.xlsx

clc; clear all;

% Load power plant data based on coal
[powerplants, cost, carbon] = PowerPlant();
build_cost = cost(1,1);                     % Build cost ($/kW)
energy_cost = cost(1,2);                    % Variable cost ($/kWh)
capital_loan_duration = 20;                 % Standard loan duration (years)

% Determine coefficients c1 and c2
c1 = build_cost/(capital_loan_duration*8760) + energy_cost;
c2 = 0;                                     % Subsidy equal to 0.

% Analytical formulas (polynomials) of first order derivatives
p1 = [0, 0, c1+c2];                         % Constant case
p2 = [0, 2*c1, c1+c2];                      % Linearly increasing case
p3 = [0, -2*c1, 2*c1+c2];                   % Linearly decreasing case
p4 = [12*c1, -8*c1, 2*c1+c2];               % Parabolic case

% Set up derivative initialisation
x0=0.5;             % x around which the derivative is approximated
n = 1000;           % Number of discretized steps between 10^-20 and 1

% Analytical solution of second order derivatives
d1 = 0;                                     % Constant case
d2 = 2 * c1;                                % Linearly increasing case
d3 = -2 * c1;                               % Linearly decreasing case
d4 = 24 * c1 * x0 - 8 * c1;                 % Parabolic case

% Set up matrices for plotting data
hx = logspace(-20,0,n);         % finite-difference steps
ds(1,1:n) = d1;                 % Analytical solution
ds(2,1:n) = d2;
ds(3,1:n) = d3;
ds(4,1:n) = d4;
dfdx = zeros(4,100);            % Second order dervivative approximation

for i = 1:1:length(hx)
    hxi = hx(i);                % finite-difference stepsize
    
    % Constant case
    fx1 = polyval(p1, x0);          
    fxplush1 = polyval(p1, x0+hxi);
    dfdx(1,i) = (fxplush1-fx1)./hxi;    % Forward finite-difference
    % Linearly increasing case
    fx2 = polyval(p2, x0);
    fxplush2 = polyval(p2, x0+hxi);
    dfdx(2,i) = (fxplush2-fx2)./hxi;
    % Linearly decreasing case
    fx3 = polyval(p3, x0);
    fxplush3 = polyval(p3, x0+hxi);
    dfdx(3,i) = (fxplush3-fx3)./hxi;
    % Linearly increasing case
    fx4 = polyval(p4, x0);
    fxplush4 = polyval(p4, x0+hxi);
    dfdx(4,i) = (fxplush4-fx4)./hxi;
end

% Set up plotting settings
colorspec = {[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]; ...
    [0.9290 0.6940 0.1250]; [0.4940 0.1840 0.5560]};    % Line colors
figure;
set(gca,'xscale','log')
hold on
for i = 1:4
    semilogx(hx, dfdx(i,:), hx, ds(i,:), '--', 'color', colorspec{i});
end
ylabel("Second Order Derivative")
xlabel("Delta x")
legend("Case 1 Approximation", "Case 1", "Case 2 Approximation", "Case 2", ...
    "Case 3 Approximation", "Case 3", "Case 4 Approximation", "Case 4")