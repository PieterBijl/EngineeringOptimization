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
x0 = [0.5; 0; 0.27; 0; 0.03; 0.04; 0.02; 0.01; 0.05; 0.05; 0.03];

plot_on = 1;
test_sub = zeros(1,66);
scenario(test_sub)