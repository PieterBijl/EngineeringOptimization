function f = scenario_barebone(subsidies,build_subsidies)
    global x0 energy_cost capital_loan_duration build_cost CO2_cost P subsidies build_subsidies
    budget = 10^9/P; % budget per year in dollars
    t_end = 30*8760; % Time after which the simulation ends in hours
%     subsidies = subsidies;
%     build_subsidies = build_subsidies;
    A = [1, 1, 1, 1]; b = 1;
    Aeq = [1, 1, 1, 1]; beq = 1;
    lb = [0 0 0 0]; ub = [1 1 1 1];
    nonlcon = [];
    %options = optimoptions(@fmincon,'Algorithm','sqp','Display','off');
    %[xsol,fsol] = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

    %% Market Function
    x1(:,1) = x0;
    gov_total_cost = 0;
    total_market_cost = 0;
    CO2_total_cost = 0;
    t = 0;
    time_step = 1000; % Timestep in hours
    while t<t_end
        options = optimoptions(@fmincon,'MaxIterations',1,'Algorithm','sqp','Display','off');
%         [xsol_temp(:,i),f1(i)] = fmincon(@objfun,x1(:,i),A,b,Aeq,beq,lb,ub,nonlcon,options);
        xsol_temp = fmincon(@objfun,x1,A,b,Aeq,beq,lb,ub,nonlcon,options); % Barebone version
        dx = xsol_temp-x1;
        norm_dx = dx/norm(dx);
        unit_cost = sum(abs(norm_dx).*build_cost);
        dx_step = budget/unit_cost*norm_dx;
        x1 = x1+dx_step;
        M_f = [1; 1; 1; 4*x1(4)^2-4*x1(4)+2];
        market_cost = time_step*x1.*(M_f.*((build_cost+build_subsidies)/(capital_loan_duration*8760)+energy_cost)+subsidies);
        total_market_cost = total_market_cost+P*sum(market_cost);
        gov_build_subsidies = P*abs(dx_step).*abs(build_subsidies);
        gov_subsidies = P*budget*x1.*subsidies;
        gov_cost = gov_build_subsidies+gov_subsidies;
        gov_total_cost = gov_total_cost+abs(sum(gov_cost));
        added_CO2 = P*x1.*CO2_cost;
        CO2_total_cost = CO2_total_cost+sum(added_CO2);
        t = t + time_step;
    end

%        n = ["Coal"; "Gas"; "Wind"; "Solar"];
%        PlotStates(n,x1,24)

%      figure; % Uncomment to show the evolution of the optimal point as
%      the market sees it
%     plot(f1)
    f = CO2_total_cost(end);
%     f = gov_total_cost(end);
end