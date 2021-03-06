clear all
[powerplants, cost, carbon] = PowerPlant();
global w_euro energy_cost capital_loan_duration dt build_cost build_subsidies subsidies w_CO2 CO2_cost
build_cost = cost(:,1);
energy_cost = cost(:,2);
CO2_cost = carbon;
w_euro = 0.;
w_CO2 = 1;
capital_loan_duration = 20;
build_subsidies = 0;
subsidies = 0;
dt = 500; % Timestep in hours
budget = 10^7; % budget per year in dollars
P = 30*10^6; % Power in kW
t_end = 30*8760; % Time after which the simulation ends in hours
A = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]; b = P;
x0 = [P; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
Aeq = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]; beq = P;
lb = [0 0 0 0 0 0 0 0 0 0 0]; ub = [P P P P P P P P P P P];
nonlcon = [];
[xsol,fsol] = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon);
x1(:,1) = x0;
i = 1;
gov_total_cost(1) = 0;
total_market_cost(1) = 0;
t = 0;
tic;
while t<t_end
    options = optimoptions(@fmincon,'MaxIterations',1,'Algorithm','interior-point','Display','off');
    [xsol_temp,f1(i)] = fmincon(@objfun,x1(:,i),A,b,Aeq,beq,lb,ub,nonlcon,options);
    dx = xsol_temp-x1(:,i);
    norm_dx = dx/norm(dx);
    unit_cost = sum(abs(norm_dx).*build_cost);
    dx_step = budget/unit_cost*norm_dx;
    x1(:,i+1) = x1(:,i)+dx_step;
    misc_cost = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];%[0.55*x1(1,i)^2-1.1*x1(1,i)+0.6; 5.2*x1(2,i)^2-5.2*x1(2,i)+1.5; 0.55*x1(1,i)^2-1.1*x1(1,i)+0.6; 1.8*x1(4,i)^2-1.5*x1(4,i)+0.5];
    market_cost(:,i) = x1(:,i)*dt.*((energy_cost+1/(capital_loan_duration*8760/dt)*(build_cost+build_subsidies)).*misc_cost+subsidies);
    total_market_cost(i+1) = total_market_cost(i)+sum(market_cost(:,i));
    gov_build_subsidies(:,i) = abs(dx_step).*abs(build_subsidies);
    gov_subsidies(:,i) = budget*x1(:,i).*subsidies;
    gov_cost(:,i) = gov_build_subsidies(:,i)+gov_subsidies(:,i);
    gov_total_cost(i+1) = gov_total_cost(i)+sum(gov_cost(:,i));
    i = i + 1;
    t = t + dt;
end
toc;
figure;
plot3(x1(2,:),x1(3,:),x1(4,:))
grid on
xlabel('Solar')
ylabel('Gas')
zlabel('Wind')

function f = objfun(x)
    global w_euro energy_cost capital_loan_duration build_cost build_subsidies subsidies w_CO2 CO2_cost
    %misc_cost = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];%[0.55*x(1)^2-1.1*x(1)+0.6; 5.2*x(2)^2-5.2*x(2)+1.5; 0.55*x(1)^2-1.1*x(1)+0.6; 1.8*x(4)^2-1.5*x(4)+0.5];
    f = sum(x/norm(x).*(w_euro*(energy_cost/norm(energy_cost)+1/(capital_loan_duration)*(build_cost/norm(build_cost)+build_subsidies)+subsidies)+w_CO2*CO2_cost/norm(CO2_cost)));
end

