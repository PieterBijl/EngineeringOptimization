function f = scenario(sub)
    global x0 energy_cost capital_loan_duration build_cost CO2_cost P subsidies build_subsidies plot_on w_CO2
    budget = 10^9/P; % budget per year in dollars
    t_end = 30*8760; % Time after which the simulation ends in hours
%     subsidies = subsidies;
%     build_subsidies = build_subsidies;
    subsidies = sub(1:11);
    build_subsidies = sub(12:22);
    A = ones(1,11); b = 1;
    Aeq = ones(1,11); beq = 1;
    lb = zeros(1,11); ub = [1 1 1 1 0.3 0.3 0.3 0.3 0.3 0.3 0.3];
    nonlcon = [];
    options = optimoptions(@fmincon,'Algorithm','sqp','MaxIterations',1000,'Display','off');
    [xsol_abs,f_abs] = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

    %% Market Function
    x1(:,1) = x0;
    i = 1;
    j = 1;
    gov_total_cost(1) = 0;
    total_market_cost(1) = 0;
    CO2_total_cost(1) = 0;
    tax_factor = 0;
    t = 0;
    time_step = 1000; % Timestep in hours
    options = optimoptions(@fmincon,'Algorithm','sqp','MaxIterations',1,'Display','off');
    [xsol,fsol] = fmincon(@objfun,x1(:,i),A,b,Aeq,beq,lb,ub,nonlcon,options);
while t<t_end
    if rem(i,20) == 0
        [xsol,fsol] = fmincon(@objfun,x1(:,i),A,b,Aeq,beq,lb,ub,nonlcon,options);
    end
    dx = xsol-x1(:,i);
    norm_dx = dx/norm(dx);
    f_check(i) = fsol;
    unit_cost = sum(abs(norm_dx).*build_cost);
    dx_step = budget/unit_cost*norm_dx;
    x1(:,i+1) = x1(:,i)+dx_step;
    M_f = ones(11,1);
    M_f(2) = 2;
    M_f(4) = 2;
%     M_f = [1; 1; 1; 4*x1(4,i)^2-4*x1(4,i)+2; 1];
    market_cost(:,i) = time_step*x1(:,i).*(M_f.*((build_cost+build_subsidies')/(capital_loan_duration*8760)+energy_cost)+subsidies');
    total_market_cost(i+1) = total_market_cost(i)+P*sum(market_cost(:,i));
    gov_build_subsidies(:,i) = -P*abs(dx_step).*build_subsidies';
    gov_subsidies(:,i) = -P*time_step*x1(:,i).*subsidies';
    gov_cost(:,i) = gov_build_subsidies(:,i)+gov_subsidies(:,i)+tax_factor*(abs(gov_subsidies(:,i))+abs(gov_build_subsidies(:,i)));
    gov_total_cost(i+1) = gov_total_cost(i)+sum(gov_cost(:,i));
    added_CO2(:,i) = time_step*P*x1(:,i).*CO2_cost;
    CO2_total_cost(i+1) = CO2_total_cost(i)+sum(added_CO2(:,i));
    i = i + 1;
    t = t + time_step;
end
    f = gov_total_cost(end) + w_CO2*CO2_total_cost(end);
    if plot_on == 1
       n = ["Coal"; "Coal with CC"; "Gas"; "Gas with CC"; "Nuclear"; "Biomass"; "Geothermal"; "Hydro"; "Onshore Wind"; "Offshore Wind"; "Solar"];
       PlotStates(n,x1,24)
        figure;
        plot(f_check)
       disp("Costs in dollars for the government")
       gov_total_cost(end)
       disp("CO2 in dollars")
       w_CO2*CO2_total_cost(end)
       disp("fsol absolute")
       f_abs
       disp("fsol relative at end")
       f_check(end)
    end
end