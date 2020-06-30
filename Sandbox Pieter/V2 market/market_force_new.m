clear all
[powerplants, cost, carbon] = PowerPlant();
global w_dollar energy_cost capital_loan_duration dt build_cost build_subsidies subsidies w_CO2 CO2_cost norm_state
build_cost = [cost(1,1); cost(4,1); cost(10,1); cost(11,1)];
energy_cost = [cost(1,2); cost(4,2); cost(10,2); cost(11,2)];
CO2_cost = [carbon(1,1); carbon(4,1); carbon(10,1); carbon(11,1)];
w_dollar = 0.5;
w_CO2 = 0.5;
capital_loan_duration = 20;
build_subsidies = 0;
subsidies = 0;
dt = 1; 
norm_state = [0.25; 0.25; 0.25; 0.25]*30*10^6;
cost_norm_dollar = 5*10^7;
cost_norm_CO2 = 4.5*10^9;
budget = 10^7; % budget per year in dollars
P = 30*10^6; % Power in kW
t_end = 30*8760; % Time after which the simulation ends in hours
A = [1, 1, 1, 1]; b = P;
x0 = [0.5*P; 0.5*P; 0; 0];
Aeq = [1, 1, 1, 1]; beq = P;
lb = [0 0 0 0]; ub = [P P P P];
nonlcon = [];
[xsol,fsol] = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon);
%CO2_total_cost = w_CO2*(xsol./norm_state*dt.*CO2_cost)
%dollar_total_cost = w_dollar*(xsol./norm_state*dt.*((build_cost-build_subsidies)/(capital_loan_duration*8760)+energy_cost+subsidies))
%% Perform objective function
xsol = [0; 0; 0.5; 0.5];
norm_cost = norm_state*dt.*((build_cost-build_subsidies)/(capital_loan_duration*8760)+energy_cost+subsidies)+[0.001; 0.001; 0.001; 0.001];
new_cost = xsol*dt.*((build_cost-build_subsidies)/(capital_loan_duration*8760)+energy_cost+subsidies)
norm_CO2 = norm_state*dt.*CO2_cost+[0.001; 0.001; 0.001; 0.001];
new_CO2 = xsol*dt.*CO2_cost
f_CO2 = sum(w_CO2*(new_CO2./norm_CO2))
f_dollar = sum(w_dollar*(new_cost./norm_cost))
f = f_CO2+f_dollar
%% Market Function
x1(:,1) = x0;
i = 1;
gov_total_cost(1) = 0;
total_market_cost(1) = 0;
t = 0;
time_step = 500; % Timestep in hours
tic;
while t<t_end
    options = optimoptions(@fmincon,'Algorithm','interior-point','Display','off');
    [xsol_temp,f1(i)] = fmincon(@objfun,x1(:,i),A,b,Aeq,beq,lb,ub,nonlcon,options);
    dx = xsol_temp-x1(:,i);
    norm_dx = dx/norm(dx);
    unit_cost = sum(abs(norm_dx).*build_cost);
    dx_step = budget/unit_cost*norm_dx;
    x1(:,i+1) = x1(:,i)+dx_step;
    market_cost(:,i) = x1(:,i)*time_step.*((build_cost-build_subsidies)/(capital_loan_duration*8760)+energy_cost+subsidies);
    total_market_cost(i+1) = total_market_cost(i)+sum(market_cost(:,i));
    gov_build_subsidies(:,i) = abs(dx_step).*abs(build_subsidies);
    gov_subsidies(:,i) = budget*x1(:,i).*subsidies;
    gov_cost(:,i) = gov_build_subsidies(:,i)+gov_subsidies(:,i);
    gov_total_cost(i+1) = gov_total_cost(i)+sum(gov_cost(:,i));
    i = i + 1;
    t = t + time_step;
end
toc;
figure;
plot3(x1(2,:),x1(3,:),x1(4,:))
grid on
xlabel('Solar')
ylabel('Gas')
zlabel('Wind')

%%

function f = objfun(x)
    global w_dollar energy_cost dt capital_loan_duration build_cost build_subsidies subsidies w_CO2 CO2_cost norm_state
    norm_cost = norm_state*dt.*((build_cost-build_subsidies)/(capital_loan_duration*8760)+energy_cost+subsidies)+[0.001; 0.001; 0.001; 0.001];
    new_cost = x*dt.*((build_cost-build_subsidies)/(capital_loan_duration*8760)+energy_cost+subsidies)
    norm_CO2 = norm_state*dt.*CO2_cost+[0.001; 0.001; 0.001; 0.001];
    new_CO2 = x*dt.*CO2_cost
    f_CO2 = sum(w_CO2*(new_CO2./norm_CO2))
    f_dollar = sum(w_dollar*(new_cost./norm_cost))
    f = f_CO2+f_dollar
    %misc_cost = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];%[0.55*x(1)^2-1.1*x(1)+0.6; 5.2*x(2)^2-5.2*x(2)+1.5; 0.55*x(1)^2-1.1*x(1)+0.6; 1.8*x(4)^2-1.5*x(4)+0.5];
%    norm_cost = norm_state*dt.*((build_cost-build_subsidies)/(capital_loan_duration*8760)+energy_cost+subsidies)+[0.001; 0.001; 0.001; 0.001]
%    new_cost = x*dt.*((build_cost-build_subsidies)/(capital_loan_duration*8760)+energy_cost+subsidies)
%    norm_CO2 = norm_state*dt.*CO2_cost+[0.001; 0.001; 0.001; 0.001]
%    new_CO2 = x*dt.*CO2_cost
%    f = sum(w_CO2*(new_CO2./norm_CO2))+sum(w_dollar*(new_cost./norm_cost))
%    f = sum(w_CO2*(x./norm_state*dt.*CO2_cost)+1/norm_state.*w_dollar*(x./norm_state*dt.*((build_cost-build_subsidies)/(capital_loan_duration*8760)+energy_cost+subsidies)));
%    f = sum(x/norm(x).*(w_dollar*(energy_cost/norm(energy_cost)+1/(capital_loan_duration)*(build_cost/norm(build_cost)+build_subsidies)+subsidies)+w_CO2*CO2_cost/norm(CO2_cost)));
end