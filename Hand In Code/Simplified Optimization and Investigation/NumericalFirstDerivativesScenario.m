% Made by Toon Stolk and Pieter Bijl as part of the course Engineering Optimization
% at Delft University of Technology
% 
% NumericalFirstDerivativesScenario.m
% The Numerical First Derivatives Scenario file that computes the
% second order derivatives of the cost function of the scenario model. The 
% derivatives are computed using a forward finite-difference approximation. 
% The derivatives are represented on a logarithmic plot to determine the 
% stable regime of step sizes used for the numerical differentiation.
% 
% Dependencies:
% PowerPlant.m
% Power Plant Data.xlsx
% objfun.m
% jacobjfun.m
% scenario2D.m

clc; clear all;

[powerplants, cost, carbon] = PowerPlant();
global x0 w_dollar energy_cost capital_loan_duration dt build_cost CO2_cost P plot_on w_CO2
build_cost = [cost(1,1); cost(10,1)];
energy_cost = [cost(1,2); cost(10,2)];
CO2_cost = [carbon(1,1); carbon(10,1)];
w_dollar = 0.5;
capital_loan_duration = 20;     % A standard loan duration of a power plant.
w_CO2 = 50/1000;        % dollars per kg CO2
plot_on = 0;            % Do not plot in the scenario function
dt = 1;                 % Timestep of 1 hour for the objective function
P = 30*10^6;            % Power in kW

% Set up derivative initialisation
x0_sub = [0, 0];    % x around which the derivative is approximated
n = 1000;           % Number of discretized steps between 10^-20 and 1

% Set up matrices for plotting data
hx = logspace(-20,0,n);     % finite-difference steps
scenariox = zeros(2,n);
for i = 1:1:length(hx)
    dx = hx(i);
    
    % Forward finite-difference approximation
    fx1 = scenario2D(x0_sub);
    fxplush1 = scenario2D([x0_sub(1)+dx, x0_sub(2)]);
    scenariox(1,i) = (fxplush1-fx1)./dx;
    fx2 = scenario2D(x0_sub);
    fxplush2 = scenario2D([x0_sub(1), x0_sub(2)+dx]);
    scenariox(2,i) = (fxplush2-fx2)./dx;
end

% Plot the results
figure;
set(gca,'xscale','log')
semilogx(hx, scenariox)
ylabel("First Order Derivative of Scenario Model")
xlabel("Delta x")
legend("Partial Derivative with respect to subsidy 1", ...
    "Partial Derivative with respect to subsidy 2")
