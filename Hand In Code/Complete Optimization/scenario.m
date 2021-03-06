% Made by Toon Stolk and Pieter Bijl as part of the course Engineering Optimization
% at Delft University of Technology
% 
% scenario.m
% The scenario function takes a row vector of 66 values as input. These
% values represent the subsidies/excises of the government at 6 time
% intervals. The function evaluates the 'ideal' state according to the
% market and will try and move the real market state towards this ideal
% state. Every timestep the market moves and the costs for the government
% are calculated and added to the total cost as well as the emitted CO2. 
% The output gives the total cost in USD and if the global variable plot_on
% = 1 it will also plot the energy transition as well as the change of the
% market function over time.

function f = scenario(sub)
    global x0 energy_cost capital_loan_duration build_cost CO2_cost P subsidies plot_on w_CO2
    budget_year = 8*10^9/P; % budget per year in dollars for the market it is divided by P since the state of the powerplants is between 0 and 1
    subsidies = sub(1:11); % Subsidies for the first time period
    sub_count = 0; % Value that is used to switch to the next time period
    
    % Settings for the fmincon market function evaluation
    A = ones(1,11); b = 1;
    Aeq = ones(1,11); beq = 1;
    lb = zeros(1,11); ub = [1 1 1 1 1 1 0.5 0.1 0.1 0.3 0.3];
    nonlcon = [];
    options = optimoptions(@fmincon,'Algorithm','sqp','MaxIterations',1000,'Display','off','SpecifyObjectiveGradient',true);
    [xsol_abs,f_abs] = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options); % Value that the market sees as 'ideal'

    %% Run Trough A Scenario
    time_step = 600; % Timestep in hours
    t_end = 30*8760; % Time after which the simulation ends in hours
    x1 = zeros(11,t_end/time_step); % state vector for every timestep
    f_check = zeros(1,t_end/time_step); % Vector used for verification to check if the solution would go to the global (market) solution
    market_cost = zeros(11,t_end/time_step); % Matrix for market cost for every time step, only used for verification
    total_market_cost = zeros(1,t_end/time_step); % Cumulative market cost, for verification purposes
    gov_subsidies = zeros(11,t_end/time_step); % 
    gov_cost = zeros(11,t_end/time_step); % Matrix for government costs for every powerplant
    gov_total_cost = zeros(1,t_end/time_step); % Matrix for cumulative costs for the government
    added_CO2 = zeros(11,t_end/time_step); % Matrix for CO2 emissions at ever timestep for every powerplant
    CO2_total_cost = zeros(1,t_end/time_step); % Matrix for cumulative CO2 emissions
    x1(:,1) = x0; % Initialize the state vector
    i = 1;
    t = 0;

    budget = budget_year/8760*time_step; % Budget that is accessible to the market for building powerplants at every timestep
    xsol = xsol_abs;
    fsol = f_abs;
    
    % Below the loop is given that calculates the state, costs and
    % emissions for every timestep throughout the energy transition
    while t<t_end
        if rem(t,43800) == 0  && t~=0
           sub_count = sub_count+1;
           global subsidies
           subsidies = sub(1+11*sub_count:11+11*sub_count);
           [xsol,fsol] = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);      
        end
        dx = xsol-x1(:,i); % Calculate difference between current and ideal state
        norm_dx = dx/norm(dx); % Make a unit vector
        f_check(i) = fsol; % For verification purposes
        unit_cost = sum(abs(norm_dx).*build_cost); % Calculate the unit cost in the direction the market wants to go
        dx_step = budget/unit_cost*norm_dx; % Calculate the size of the step the market is able to make
        x1(:,i+1) = x1(:,i)+dx_step; % Calculate the next state
        
        % Calculate the multiplication factors for market cost
        M_f = ones(11,1);
        M_f(2) = x1(2,i)+1;
        M_f(4) = x1(4,i)+1;
        M_f(7) = 4*x1(7,i)^2-4*x1(7,i)+2;
        M_f(8) = 2-x1(8,i);
        M_f(9) = 4*x1(9,i)^2-4*x1(9,i)+2;
        M_f(10) = 4*x1(10,i)^2-4*x1(10,i)+2;
        M_f(11) = 4*x1(11,i)^2-4*x1(11,i)+2;
        market_cost(:,i) = time_step*x1(:,i).*(M_f.*(build_cost/(capital_loan_duration*8760)+energy_cost)+subsidies');
        total_market_cost(i+1) = total_market_cost(i)+P*sum(market_cost(:,i)); % For verification purpose only
        gov_subsidies(:,i) = -P*time_step*x1(:,i).*subsidies';
        gov_cost(:,i) = gov_subsidies(:,i);
        gov_total_cost(i+1) = gov_total_cost(i)+sum(gov_cost(:,i));
        added_CO2(:,i) = time_step*P*x1(:,i).*CO2_cost;
        CO2_total_cost(i+1) = CO2_total_cost(i)+sum(added_CO2(:,i));
        i = i + 1;
        t = t + time_step;
    end
        w_CO2_used = exp(log(8)*CO2_total_cost(end)/10^12)*w_CO2; % Exponential function for the cost of CO2
        f = gov_total_cost(end) + w_CO2_used*CO2_total_cost(end); % Cost function
        
        % If the user wants to plot the energy transition and some more
        % statistics
        if plot_on == 1
           n = num2cell(["Coal"; "Coal with CC"; "Gas"; "Gas with CC"; "Nuclear"; "Biomass"; "Geothermal"; "Hydro"; "Onshore Wind"; "Offshore Wind"; "Solar"]);
           colors = [{[0 0 0]}; {[0.494 0.184 0.556]}; {[0.466 0.674 0.188]}; {[0 1 0]}; {[1 1 0]}; {[0.929 0.694 0.125]}; {[1 0 0]}; {[0 0 1]}; {[1 0 1]}; {[0 0.4470 0.7410]}; {[0.85 0.325 0.098]}];
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
           disp("Total cost in dollars")
           f
        end
end