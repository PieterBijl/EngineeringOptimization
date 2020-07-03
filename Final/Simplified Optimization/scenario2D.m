function f = scenario2D(sub)
    global x0 energy_cost capital_loan_duration build_cost CO2_cost P subsidies plot_on w_CO2
    budget_year = 8*10^9/P; % budget per year in dollars
    subsidies = sub(1:2);
    sub_count = 0; % Check to choose from the right subsidies
    A = ones(1,2); b = 1;
    Aeq = ones(1,2); beq = 1;
    lb = zeros(1,2); ub = [1 1];
    nonlcon = [];
    options = optimoptions(@fmincon,'Algorithm','sqp','MaxIterations',1000,'Display','off','SpecifyObjectiveGradient',true);
    [xsol_abs,f_abs] = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);

    %% Market Function
    time_step = 600; % Timestep in hours
    t_end = 30*8760; % Time after which the simulation ends in hours
    x1 = zeros(2,t_end/time_step);
    f_check = zeros(1,t_end/time_step);
    market_cost = zeros(2,t_end/time_step);
    total_market_cost = zeros(1,t_end/time_step);
    gov_subsidies = zeros(2,t_end/time_step);
    gov_cost = zeros(2,t_end/time_step);
    gov_total_cost = zeros(1,t_end/time_step);
    added_CO2 = zeros(2,t_end/time_step);
    CO2_total_cost = zeros(1,t_end/time_step);
    x1(:,1) = x0;
    i = 1;
    j = 1;
    tax_factor = 0;
    t = 0;

    budget = budget_year/8760*time_step;
%     options = optimoptions(@fmincon,'Algorithm','sqp','MaxIterations',1,'Display','off');
    xsol = xsol_abs;
    fsol = f_abs;
%     [xsol,fsol] = fmincon(@objfun,x1(:,i),A,b,Aeq,beq,lb,ub,nonlcon,options);
while t<t_end
%     if rem(i,5000) == 0
%         [xsol,fsol] = fmincon(@objfun,x1(:,i),A,b,Aeq,beq,lb,ub,nonlcon,options);
%     end
    if rem(t,10043800) == 0  && t~=0
%        sub_count = sub_count+1;
%        global subsidies
%        subsidies = sub(1+2*sub_count:11+11*sub_count);
       [xsol,fsol] = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);      
    end
    R = 0*randn(2,1)/5000;
    dx = xsol-x1(:,i)+R;
    norm_dx = dx/norm(dx);
    f_check(i) = fsol;
    unit_cost = sum(abs(norm_dx).*build_cost);
    dx_step = budget/unit_cost*norm_dx;
    x1(:,i+1) = x1(:,i)+dx_step;
    M_f = ones(2,1);
    M_f(2) = 4*x1(2,i)^2-4*x1(2,i)+2;
    market_cost(:,i) = time_step*x1(:,i).*(M_f.*(build_cost/(capital_loan_duration*8760)+energy_cost)+subsidies');
    total_market_cost(i+1) = total_market_cost(i)+P*sum(market_cost(:,i));
    gov_subsidies(:,i) = -P*time_step*x1(:,i).*subsidies';
    gov_cost(:,i) = gov_subsidies(:,i)+tax_factor*(abs(gov_subsidies(:,i)));
    gov_total_cost(i+1) = gov_total_cost(i)+sum(gov_cost(:,i));
    added_CO2(:,i) = time_step*P*x1(:,i).*CO2_cost;
    CO2_total_cost(i+1) = CO2_total_cost(i)+sum(added_CO2(:,i));
    i = i + 1;
    t = t + time_step;
end
    w_CO2_used = exp(log(8)*CO2_total_cost(end)/10^12)*w_CO2;
%     if CO2_total_cost(end)>500*10^9
%        w_CO2_used = 2*w_CO2; 
%     end
%     if CO2_total_cost(end)>10^12
%        w_CO2_used = 4*w_CO2; 
%     end
    f = gov_total_cost(end) + w_CO2_used*CO2_total_cost(end);
    if plot_on == 1
       n = num2cell(["Coal"; "Offshore Wind"]);
       colors = [{[0 0 0]}; {[0 0.4470 0.7410]}];
       n(:,2) = colors;
       PlotStates(n,x1,time_step)
        figure;
        plot(f_check)
       disp("Costs in dollars for the government")
       gov_total_cost(end)
       disp("CO2 in dollars")
       w_CO2_used*CO2_total_cost(end)
       disp("Total CO2 emissions in Megatonnes")
       CO2_total_cost(end)/(10^9)
       disp("fsol ab7solute")
       f_abs
       disp("fsol relative at end")
       f_check(end)
       w_CO2_used
    end
end