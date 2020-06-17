function [build_cost, maintenance_cost, fuel_cost, CO2_cost, dismantling_cost] = parameters
data = xlsread("Input Data.xlsx");
build_cost = data(:,1); %per unit of energy
maintenance_cost = data(:,2); %per unit of energy/year
fuel_cost = data(:,3); %per unit of energy
CO2_cost = data(:,4); %per unit of energy
dismantling_cost = data(:,5); %per unit of energy
end