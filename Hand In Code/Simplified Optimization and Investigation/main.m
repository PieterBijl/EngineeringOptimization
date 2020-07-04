% Made by Toon Stolk and Pieter Bijl as part of the course Engineering Optimization
% at Delft University of Technology
% 
% main.m
% This is the main file for the 2D optimalization. In this file the market
% function and the scenario function are plotted for 2 dimensions. Also the
% various optimization functions are exectued here.
% 
% Dependencies:
% PowerPlant.m
% Power Plant Data.xlsx

clc; clear all;

[powerplants, cost, carbon] = PowerPlant();
global x0 w_dollar energy_cost capital_loan_duration dt build_cost CO2_cost P plot_on w_CO2
build_cost = [cost(1,1); cost(10,1)];
energy_cost = [cost(1,2); cost(10,2)];
CO2_cost = [carbon(1,1); carbon(10,1)];
w_dollar = 0.5;
capital_loan_duration = 20;
w_CO2 = 50/1000; % dollars per kg CO2
plot_on = 0; % Do not plot in the scenario function
dt = 1; 
P = 30*10^6; % Power in kW
x0 = [0.5; 0.5];

%% Create Market Function Plot
% This part creates a 3D plot of the market function
x = linspace(0,1,100); % Coal
y = linspace(0,1,100); % Wind
z = zeros(100,100);
global subsidies
subsidies = [0 0];
for i = 1:length(x)
    for j = 1:length(y)
        [z(i,j),g] = objfun([x(i); y(j)]);
    end
end
figure
grid on
surf(100*x,100*y,z)
title("Market cost function with Coal and Wind energy")
xlabel("Coal % of power supply")
ylabel("Wind % of power supply")
zlabel("Market cost")

%% Create Scenario Space
% This section creates a 3D plot of how the total cost of a scenario
% changes based on the subsidies/excises of the goverment as input.
x = linspace(-energy_cost(1),energy_cost(1),100);
y = linspace(-energy_cost(2),energy_cost(2),100);
z = zeros(100,100);
for i = 1:length(x)
    for j = 1:length(y)
        z(i,j) = scenario2D([x(i) y(j)]);
    end
end
%% Plotting
figure
grid on
surf(x,y,z)
title("Scenario Cost Function Depending on Subsidies")
xlabel("Subsidy/Excise Coal $/kWh")
ylabel("Subsidy/Excise Offshore Wind $/kWh")
zlabel("Total Cost")

%% Perform self made top level optimization

c1 = build_cost/(capital_loan_duration*8760)+energy_cost;
x0_sub = [0, 0]; % 0 subsidies for both coal and wind energy

lb = [];
ub = [energy_cost(1) energy_cost(2)];

% Optimization initialisation
cycle = 0;
max_iter = 3;       % Maximum number of iterations
dx = 1e-5;         % Finite-difference step
plot_on = 0;

while cycle < max_iter
    cycle = cycle + 1;
    
    % finite difference approximation
    fx1 = scenario2D(x0_sub);
    fxplush1 = scenario2D([x0_sub(1)+dx, x0_sub(2)]);
    h1 = (fxplush1-fx1)./dx;
    fx2 = scenario2D(x0_sub);
    fxplush2 = scenario2D([x0_sub(1), x0_sub(2)+dx]);
    h2 = (fxplush2-fx2)./dx
    % Gradient vector
    grad = [h1, h2];
    
    x_sub_new = linprog(grad, [], [], [], [], lb, ub)
    
    x0_sub = x_sub_new';
end


plot_on = 1;
scenario2D(x0_sub)
plot_on = 0;

%% Perform Fmincon
plot_on = 0; 
x0_fmincon = [0 0];
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [energy_cost(1) energy_cost(2)];
nonlcon = []
options = optimoptions(@fmincon,'Algorithm','sqp','Display','iter');
[x_fmincon,f_fmincon] = fmincon(@scenario2D,x0_fmincon,A,b,Aeq,beq,lb,ub,nonlcon,options)
plot_on = 1;
scenario2D(x_fmincon)
plot_on = 0;

%% Perform GA
% This section performs a genetic algorithm optimization on the 2D problem
% and plots the result. It uses the same settings as fmincon()
plot_on = 0;
options = optimoptions('ga','Display','iter','MaxGenerations',100,'PlotFcn', @gaplotbestf,'CrossoverFraction', 0.8)
tic;
x_test = ga(@scenario2D,2,A,b,Aeq,beq,lb,ub,nonlcon,options)
toc;
global plot_on
plot_on = 1;
scenario2D(x_test)
global plot_on
plot_on = 0;