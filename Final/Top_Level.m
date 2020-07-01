[powerplants, cost, carbon] = PowerPlant();
global x0 w_dollar energy_cost capital_loan_duration dt build_cost CO2_cost P
build_cost = [cost(1,1); cost(4,1); cost(10,1); cost(11,1)];
energy_cost = [cost(1,2); cost(4,2); cost(10,2); cost(11,2)];
CO2_cost = [carbon(1,1); carbon(4,1); carbon(10,1); carbon(11,1)];
w_dollar = 0.5;
capital_loan_duration = 20;
build_subsidies = [0; 0; 0; 0];
subsidies = [0; 0; 0; 0];
sub = [subsidies; build_subsidies];
dt = 1; 
P = 30*10^6; % Power in kW
x0 = [0.5; 0.5; 0; 0];
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
options = optimoptions('ga','MaxTime',1000,'MaxGenerations',10,'Display','iter')
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [];
nonlcon = [];
x_test = ga(@scenario_test,8,A,b,Aeq,beq,lb,ub,nonlcon,options)