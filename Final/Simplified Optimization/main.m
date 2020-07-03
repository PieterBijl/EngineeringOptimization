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
x = linspace(0,1,100); % Coal
y = linspace(0,1,100); % Wind
z = zeros(100,100);
global subsidies
subsidies = [0 0]
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

%% Create Scenario Space with no subsidies
sub = [0 0];
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

%% Perfrom Fmincon
plot_on = 0; 
x0_fmincon = [0 0];
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];%[-3000 -3000 -3000 -3000 -3000 max_subsidy max_subsidy max_subsidy max_subsidy max_subsidy];
ub = [energy_cost(1) energy_cost(2)];
nonlcon = []
options = optimoptions(@fmincon,'Algorithm','sqp','Display','iter');
[x_fmincon,f_fmincon] = fmincon(@scenario2D,x0_fmincon,A,b,Aeq,beq,lb,ub,nonlcon,options)
plot_on = 1;
scenario2D(x_fmincon)
plot_on = 0;

%% Perform GA
plot_on = 0;
options = optimoptions('ga','Display','iter','MaxGenerations',1000,'PlotFcn', @gaplotbestf,'CrossoverFraction', 0.8)
tic;
x_test = ga(@scenario2D,2,A,b,Aeq,beq,lb,ub,nonlcon,options)
toc;
global plot_on
plot_on = 1;
scenario2D(x_test)
global plot_on
plot_on = 0;