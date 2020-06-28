clear all

starting_state = [0.9; 0.1]; % Coal and Solar power, must sum to 1
build_cost = [0.1; 0.2]; % How much to build for coal and solar
fuel_cost = [0.2; 0];
maintenance_cost = [0.1; 0.1];
demolition_cost = [0.2; 0.1]; % How much to break down the buildings
CO2_cost = [0.2; 0.05]; % How much CO2 do they emit?
budget = 1; % How much can be spend per time unit
w_CO2 = 0.5; % How bad is polluting
w_euro = 0.5; % How bad is spending money
f = starting_state.*(w_euro*(maintenance_cost+fuel_cost)+w_CO2*CO2_cost);