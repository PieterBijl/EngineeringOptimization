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
state(:,1) = [0.35, 0.2, 0.2, 0, 0.1, 0.05, 0, 0.1]';
budget = 5;
cost_t(:,1) = state(:,1).*(maintenance_cost+fuel_cost)*dt;
cost_co2(:,1) = state(:,1).*CO2_cost;
fit(1) = sum(cost_co2(:,1))+sum(cost_t(:,1));
P_t(1) = 1;
for i=1:(t_end/dt)-1
    P_t(i+1) = exp((i+1)*dt*log(P_multiplier)/t_end);
    state(:,i+1) = P_t(i+1)/P_t(i)*state(:,i);
    cost_dt = state(:,i).*(maintenance_cost+fuel_cost)*dt+(state(:,i+1)-state(:,i)).*build_cost;
    cost_co2(:,i+1) = cost_co2(:,i)+(state(:,i+1)-state(:,i)).*build_cost;
    cost_t(:,i+1) = cost_t(:,i)+cost_dt;
    fit(i+1) = sum(cost_co2(:,i+1))+sum(cost_t(:,i+1));
end
