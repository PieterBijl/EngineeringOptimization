clear all
clc
%% Get parameters
[build_cost, maintenance_cost, fuel_cost, CO2_cost, dismantling_cost] = parameters();
% Energy Sources are in order: Coal, Oil, Gas, Hydro, Wind, Solar, Nuclear, Biomass

%% Calculations
t_end = 600; %600 months
dt = 1; %1 month
plant_state = zeros(8,600);
plant_state(:,1) = [0.4, 0.2, 0.15,0,0.1,0.05,0,0.2]';
energy_need = zeros(1,600);
energy_need(1) = 1;
multiplication_factor = 5; % Amount of power that is needed after 50 years compared to t=0

for i=1:t_end
    energy_need(i) = exp(i*((log(multiplication_factor)/600)));
end