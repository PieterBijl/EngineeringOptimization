[powerplants, cost, carbon] = PowerPlant();
global x0 w_dollar energy_cost capital_loan_duration dt build_cost CO2_cost P plot_on w_CO2
build_cost = cost(:,1);
energy_cost = cost(:,2);
CO2_cost = carbon;
w_dollar = 0.5;
capital_loan_duration = 20;
w_CO2 = 50/1000; % dollars per kg CO2
plot_on = 0; % Do not plot in the scenario function
dt = 1; 
P = 30*10^6; % Power in kW
x0 = [0.4; 0; 0.4; 0; 0.2; 0; 0; 0; 0; 0; 0];

%% GA
global plot_on
plot_on = 0; % Set to 0 or you're gonna have a bad time
options = optimoptions('ga','Display','iter','MaxGenerations',1000,'PlotFcn', @gaplotbestf,'CrossoverFraction', 0.8)
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];%[-3000 -3000 -3000 -3000 -3000 max_subsidy max_subsidy max_subsidy max_subsidy max_subsidy];
ub = [energy_cost(1) energy_cost(2) energy_cost(3) energy_cost(4) energy_cost(5) energy_cost(6) energy_cost(7) energy_cost(8) energy_cost(9) energy_cost(10) energy_cost(11),... 
    energy_cost(1) energy_cost(2) energy_cost(3) energy_cost(4) energy_cost(5) energy_cost(6) energy_cost(7) energy_cost(8) energy_cost(9) energy_cost(10) energy_cost(11),...
    energy_cost(1) energy_cost(2) energy_cost(3) energy_cost(4) energy_cost(5) energy_cost(6) energy_cost(7) energy_cost(8) energy_cost(9) energy_cost(10) energy_cost(11),...
    energy_cost(1) energy_cost(2) energy_cost(3) energy_cost(4) energy_cost(5) energy_cost(6) energy_cost(7) energy_cost(8) energy_cost(9) energy_cost(10) energy_cost(11),...
    energy_cost(1) energy_cost(2) energy_cost(3) energy_cost(4) energy_cost(5) energy_cost(6) energy_cost(7) energy_cost(8) energy_cost(9) energy_cost(10) energy_cost(11),...
    energy_cost(1) energy_cost(2) energy_cost(3) energy_cost(4) energy_cost(5) energy_cost(6) energy_cost(7) energy_cost(8) energy_cost(9) energy_cost(10) energy_cost(11)];%[0 0 0 0 0 -max_subsidy -max_subsidy -max_subsidy -max_subsidy -max_subsidy];
nonlcon = [];
x_test = ga(@scenario,66,A,b,Aeq,beq,lb,ub,nonlcon,options)
global plot_on
plot_on = 1;
scenario(x_test)
global plot_on
plot_on = 0;

%% Fmincon test
x0_fmincon = zeros(1,66);
global plot_on
plot_on = 0;
options = optimoptions(@fmincon,'Algorithm','sqp','Display','iter');
[x_fmincon,f_fmincon] = fmincon(@scenario,x0_fmincon,A,b,Aeq,beq,lb,ub,nonlcon,options)
global plot_on
plot_on = 1;
scenario(x_fmincon)
global plot_on
plot_on = 0;