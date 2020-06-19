clear all;
clc;
%% Load in the parameters
[build_cost, maintenance_cost, fuel_cost, CO2_cost, dismantling_cost] = parameters();
%Coal, Oil, Gas, Hydro, Wind, Solar, Nuclear, Biomass

%% Set up simulation
P_multiplier = 5; % how much more power is needed at the end of the simulatino vs. the beginning of the simulation
t = 0; % start year = 0
t_end = 50; % the amount of years that the simulation runs
dt = 0.01;
P_t = exp(t*log(P_multiplier)/t_end); % Required power at time t

budget = 5;

state(i) = [0.35, 0.2, 0.2, 0, 0.1, 0.05, 0, 0.1]';
cost_t = state.*(maintenance_cost+fuel_cost);
cost_co2 = state.*CO2_cost;