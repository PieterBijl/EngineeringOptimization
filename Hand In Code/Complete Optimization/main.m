% Made by Toon Stolk and Pieter Bijl as part of the course Engineering Optimization
% at Delft University of Technology
% 
% main.m
% The main.m script is the top level script where the genetic algorithm,
% plotting is called from. The global variables and inputs are defined
% here. In the first section the genetic algorithm is called and its output plotted
% The second section deals with the robustness checks.
%
% Dependencies:
% PowerPlant.m
% Power Plant Data.xlsx

clc; clear all;

[powerplants, cost, carbon] = PowerPlant(); % Get the data about the powerplants from the excel sheet
% Set global variables to be used in functions
global x0 w_dollar energy_cost capital_loan_duration dt build_cost CO2_cost P plot_on w_CO2
build_cost = cost(:,1);
energy_cost = cost(:,2);
CO2_cost = carbon;
w_dollar = 0.5;
capital_loan_duration = 20; % Necessary to calculate costs in the market function
w_CO2 = 50/1000; % dollars per kg CO2
plot_on = 0; % Do not plot in the scenario function
dt = 1; 
P = 30*10^6; % Power in kW
% Initial state, based on the Netherlands.
x0 = [0.5; 0; 0.27; 0; 0.03; 0.04; 0.02; 0.01; 0.05; 0.05; 0.03];

%% GA
global plot_on
plot_on = 0; % Set to 0 or your computer will crash because of all the plots
options = optimoptions('ga','Display','iter','MaxGenerations',1000,'PlotFcn', @gaplotbestf,'CrossoverFraction', 0.8)
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [energy_cost(1) energy_cost(2) energy_cost(3) energy_cost(4) energy_cost(5) energy_cost(6) energy_cost(7) energy_cost(8) energy_cost(9) energy_cost(10) energy_cost(11),... 
    energy_cost(1) energy_cost(2) energy_cost(3) energy_cost(4) energy_cost(5) energy_cost(6) energy_cost(7) energy_cost(8) energy_cost(9) energy_cost(10) energy_cost(11),...
    energy_cost(1) energy_cost(2) energy_cost(3) energy_cost(4) energy_cost(5) energy_cost(6) energy_cost(7) energy_cost(8) energy_cost(9) energy_cost(10) energy_cost(11),...
    energy_cost(1) energy_cost(2) energy_cost(3) energy_cost(4) energy_cost(5) energy_cost(6) energy_cost(7) energy_cost(8) energy_cost(9) energy_cost(10) energy_cost(11),...
    energy_cost(1) energy_cost(2) energy_cost(3) energy_cost(4) energy_cost(5) energy_cost(6) energy_cost(7) energy_cost(8) energy_cost(9) energy_cost(10) energy_cost(11),...
    energy_cost(1) energy_cost(2) energy_cost(3) energy_cost(4) energy_cost(5) energy_cost(6) energy_cost(7) energy_cost(8) energy_cost(9) energy_cost(10) energy_cost(11)];%[0 0 0 0 0 -max_subsidy -max_subsidy -max_subsidy -max_subsidy -max_subsidy];
nonlcon = [];
tic;
x_test = ga(@scenario,66,A,b,Aeq,beq,lb,ub,nonlcon,options)
toc;
global plot_on
plot_on = 1;
scenario(x_test)
global plot_on
plot_on = 0;

%% Robustness

% Fill in your subsidies/excises to check the robustness
x_check = [0.00913242	0.017776804	0.004153627	-0.02030619	0.016255845	0.019170224	0.015825092	0.003408676	-0.007707334	0.012557078	-0.007342384	0.00913242	0.016067819	0.003717588	-0.017376503	0.016240607	0.017274109	0.015833973	0.003408676	-0.006425596	0.012557078	0.000276749	0.00913242	-0.013473196	0.004159589	-0.017254432	0.016255845	0.019129876	-0.034947277	0.003397128	0.003980898	0.012170616	-0.001609716	0.007884118	-0.006784162	0.004159589	-0.017254432	0.014602931	0.019181598	-0.035079041	0.003363633	0.002693583	0.012557078	-0.000700539	-0.031139683	0.012917454	-0.011802847	0.008990685	-0.052225601	-0.027693402	0.015833262	-0.030771012	-0.01166343	-0.05026832	0.001726111	0.002784764	-0.051953511	0.002206464	0.008988962	0.016255845	-0.030958826	0.015833973	-0.029870743	-0.021074034	-0.049942922	-0.005339211
];
mean_x = abs(mean(abs(x_check))); % Obtain the mean absolute value
std_noise = 10/100*mean_x; % Create the standard deviation for the standard noise 10% is taken here
plot_on = 0;
f_robust = zeros(1,1000);
noise_mean = zeros(1,1000);
for i =1:1000
    noise = randn(1,66)*(std_noise);
    new_x = x_check+noise;
    f_robust(i) = scenario(new_x);
    noise_std(i) = std(noise);
end
f_robust_mean = mean(f_robust)
%% Plot Histogram of the Robustness Check
figure;
histogram(f_robust)
title(['Histogram of input with Gaussian noise sigma = ',num2str(std_noise),' $/kWh, n = 1000'])
xlabel("Total Cost in USD")
ylabel("frequency")