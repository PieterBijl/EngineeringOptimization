[powerplants, cost, carbon] = PowerPlant();
global x0 w_dollar energy_cost capital_loan_duration dt build_cost CO2_cost P plot_on w_CO2
build_cost = [cost(1,1); cost(7,1)];
energy_cost = [cost(1,2); cost(7,2)];
CO2_cost = [carbon(1,1); carbon(7,1)];
w_dollar = 0.5;
capital_loan_duration = 20;
w_CO2 = 50/1000; % dollars per kg CO2
plot_on = 0; % Do not plot in the scenario function
dt = 1; 
P = 30*10^6; % Power in kW
x0 = [0.5; 0.5];
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
ylabel("Subsidy/Excise Geothermal $/kWh")
zlabel("Total Cost")