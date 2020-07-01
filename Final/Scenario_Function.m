function f = scenario(x0,subsidies,build_subsidies)
    budget = 0.5*10^9/P; % budget per year in dollars
    t_end = 30*8760; % Time after which the simulation ends in hours
    A = [1, 1, 1, 1]; b = 1;
    Aeq = [1, 1, 1, 1]; beq = 1;
    lb = [0 0 0 0]; ub = [1 1 1 0.2];
    nonlcon = [];
    options = optimoptions(@fmincon,'Algorithm','sqp','Display','off');
    [xsol,fsol] = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

    %% Market Function
    x1(:,1) = x0;
    i = 1;
    gov_total_cost(1) = 0;
    total_market_cost(1) = 0;
    CO2_total_cost(1) = 0;
    t = 0;
    time_step = 500; % Timestep in hours
    tic;
    while t<t_end
         options = optimoptions(@fmincon,'MaxIterations',1,'Algorithm','sqp','Display','off');
        [xsol_temp(:,i),f1(i)] = fmincon(@objfun,x1(:,i),A,b,Aeq,beq,lb,ub,nonlcon,options);
        dx = xsol_temp(:,i)-x1(:,i);
        norm_dx = dx/norm(dx);
        unit_cost = sum(abs(norm_dx).*build_cost);
        dx_step = budget/unit_cost*norm_dx;
        x1(:,i+1) = x1(:,i)+dx_step;
        M_f = [1; 1; 1; 4*x1(4,i)^2-4*x1(4,i)+2];
        market_cost(:,i) = time_step*x1(:,i).*(M_f.*((build_cost+build_subsidies)/(capital_loan_duration*8760)+energy_cost)+subsidies);
        total_market_cost(i+1) = total_market_cost(i)+P*sum(market_cost(:,i));
        gov_build_subsidies(:,i) = P*abs(dx_step).*abs(build_subsidies);
        gov_subsidies(:,i) = P*budget*x1(:,i).*subsidies;
        gov_cost(:,i) = gov_build_subsidies(:,i)+gov_subsidies(:,i);
        gov_total_cost(i+1) = gov_total_cost(i)+abs(sum(gov_cost(:,i)));
        added_CO2(:,i) = P*x1(:,i).*CO2_cost;
        CO2_total_cost(i+1) = CO2_total_cost(i)+sum(added_CO2(:,i));
        i = i + 1;
        t = t + time_step;
    end
    toc;

    n = ["Coal"; "Gas"; "Wind"; "Solar"];
    PlotStates(n,x1,24)

    figure;
    plot(f1)
    f = gov_total_cost(end);
end

function f = objfun(x)
    global energy_cost dt capital_loan_duration build_cost build_subsidies subsidies
    M_f = [1; 1; 1; 4*x(4)^2-4*x(4)+2];%4.4444444*10^-15*x(4)^2-1.33333333*10^-7*x(4)];
    new_cost = x.*(M_f.*((build_cost+build_subsidies)/(capital_loan_duration*8760)+energy_cost)+subsidies);
    f = sum(new_cost);
end

function PlotStates(names, states, timestep) 
time2 = datetime('today') + caldays(1:length(states));

figure
area(time2, states')
xlabel("Time")
% ylim([0 1])
ylabel("Fraction of total power supply")

legend(names(:))
end