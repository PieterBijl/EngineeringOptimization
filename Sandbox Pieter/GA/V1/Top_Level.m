[powerplants, cost, carbon] = PowerPlant();
global x0 w_dollar energy_cost capital_loan_duration dt build_cost CO2_cost P plot_on w_CO2
build_cost = [cost(1,1); cost(3,1); cost(9,1); cost(11,1); cost(5,1)];
energy_cost = [cost(1,2); cost(3,2); cost(9,2); cost(11,2); cost(5,2)];
CO2_cost = [carbon(1,1); carbon(3,1); carbon(9,1); carbon(11,1); carbon(5,1)];
w_dollar = 0.5;
capital_loan_duration = 20;
w_CO2 = 1000/1000; % dollars per kg CO2
plot_on = 0; % Do not plot in the scenario function
build_subsidies = [0; 0; 0; 0; 0];
subsidies = [0; 0; 0; 0; 0];
sub = [subsidies; build_subsidies];
dt = 1; 
P = 30*10^6; % Power in kW
x0 = [1; 0; 0; 0; 0];

%% Perform some first test
tic;
f_normal = scenario(sub)
toc;
A = [];
b = [];
%x = fmincon(@scenario,sub,A,b)
%% Test the fmincon scenario
tic;
f_fmincon = scenario_test(x)
toc;
%% Test fmincon
    A = [1, 1, 1, 1]; b = 1;
    Aeq = [1, 1, 1, 1]; beq = 1;
    lb = [0 0 0 0]; ub = [1 1 0.3 0.2];
    nonlcon = [];
    options = optimoptions(@fmincon,'Algorithm','sqp','Display','off');
    [xsol,fsol] = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
%% GA
global plot_on
plot_on = 0; % Set to 0 or you're gonna have a bad time
options = optimoptions('ga','Display','iter','MaxGenerations',50)
max_subsidy = 10*-0.5*max(energy_cost);
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];%[-3000 -3000 -3000 -3000 -3000 max_subsidy max_subsidy max_subsidy max_subsidy max_subsidy];
ub = [0 0 0 0 0 0.3 0.2 0 0 0];%[0 0 0 0 0 -max_subsidy -max_subsidy -max_subsidy -max_subsidy -max_subsidy];
nonlcon = [];
x_test = ga(@scenario,10,A,b,Aeq,beq,lb,ub,nonlcon,options)
global plot_on
plot_on = 1;
scenario(x_test)
global plot_on
plot_on = 0;

%% Test
test_sub = [-0.0583 -0.2357 -0.4212 -0.3057 -0.4572 0 0 -0.2393 -0.0017 -1.1513];
% scenario_plot(x_test)
global plot_on
plot_on = 1
scenario(test_sub)