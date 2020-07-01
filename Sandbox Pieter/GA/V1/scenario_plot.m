function f = scenario(sub)
    global x0 energy_cost capital_loan_duration build_cost CO2_cost P subsidies build_subsidies
    budget = 10^9/P; % budget per year in dollars
    t_end = 30*8760; % Time after which the simulation ends in hours
%     subsidies = subsidies;
%     build_subsidies = build_subsidies;
    subsidies = sub(1:5);
    build_subsidies = sub(6:10);
    A = [1 1 1 1 1]; b = 1;
    Aeq = [1 1 1 1 1]; beq = 1;
    lb = [0 0 0 0 0]; ub = [1 1 0.3 0.3 0.1];
    nonlcon = [];
    options = optimoptions(@fmincon,'Algorithm','sqp','Display','off');
    [xsol] = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

    %% Market Function
    x1(:,1) = x0;
    i = 1;
    gov_total_cost(1) = 0;
    total_market_cost(1) = 0;
    CO2_total_cost(1) = 0;
    t = 0;
    time_step = 1000; % Timestep in hours
while t<t_end
    dx = xsol-x1(:,i);
    norm_dx = dx/norm(dx);
    unit_cost = sum(abs(norm_dx).*build_cost);
    dx_step = budget/unit_cost*norm_dx;
    x1(:,i+1) = x1(:,i)+dx_step;
    M_f = [1; 1; 1; 4*x1(4,i)^2-4*x1(4,i)+2; 1];
    market_cost(:,i) = time_step*x1(:,i).*(M_f.*((build_cost+build_subsidies')/(capital_loan_duration*8760)+energy_cost)+subsidies');
    total_market_cost(i+1) = total_market_cost(i)+P*sum(market_cost(:,i));
    gov_build_subsidies(:,i) = P*abs(dx_step).*abs(build_subsidies');
    gov_subsidies(:,i) = P*budget*x1(:,i).*subsidies';
    gov_cost(:,i) = gov_build_subsidies(:,i)+gov_subsidies(:,i);
    gov_total_cost(i+1) = gov_total_cost(i)+abs(sum(gov_cost(:,i)));
    added_CO2(:,i) = P*x1(:,i).*CO2_cost;
    CO2_total_cost(i+1) = CO2_total_cost(i)+sum(added_CO2(:,i));
    i = i + 1;
    t = t + time_step;
end

          n = ["Coal"; "Gas"; "Wind"; "Solar";"Nuclear"];
          PlotStates(n,x1,24)
%       figure;
%       plot(f1)
    social_cost = 50/1000; % dollars per ton CO2
    f = gov_total_cost(end) + social_cost*CO2_total_cost(end);
    gov_total_cost(end)
    CO2_total_cost(end)*social_cost
%     f = gov_total_cost(end);
end