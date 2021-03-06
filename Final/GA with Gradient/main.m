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
tic;
x_test = ga(@scenario,66,A,b,Aeq,beq,lb,ub,nonlcon,options)
toc;
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

%% Robustness
mean_x = abs(mean(abs(x_test)));
std_noise = 2*mean_x;
plot_on = 0;
f_robust = zeros(1,1000);
noise_mean = zeros(1,1000);
for i =1:1000
    noise = randn(1,66)*(std_noise);
    new_x = x_test+noise;
    f_robust(i) = scenario(new_x);
    noise_std(i) = std(noise);
end
f_robust_mean = mean(f_robust)
%% Plot Histogram of the Robustness Check
figure;
histogram(f_robust)
title(['Histogram of input with Gaussian noise sigma = ',num2str(std_noise),' $/kWh, n = 1000'])
xlabel("Total Cost in USD")
ylabel("frequency")