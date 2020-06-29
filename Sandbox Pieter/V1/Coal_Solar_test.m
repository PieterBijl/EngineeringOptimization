clear all

starting_state = [0.9; 0.1]; % Coal and Solar power, must sum to 1
build_cost = [0.1; 0.2]; % How much to build for coal and solar
fuel_cost = [0.2; 0];
maintenance_cost = [0.1; 0.1];
demolition_cost = [0.2; 0.1]; % How much to break down the buildings
CO2_cost = [0.2; 0.05]; % How much CO2 do they emit?
budget = 1; % How much can be spend per time unit
w_CO2 = 0.5; % How bad is polluting
w_euro = 0.5; % How bad is spending money
f = starting_state.*(w_euro*(maintenance_cost+fuel_cost)+w_CO2*CO2_cost);
sol = linspace(0,1,100);
coal = linspace(0,1,100);
f_test = zeros(length(sol),length(coal));

%% Run initial loop to show how the design space looks like

for i=1:length(sol)
    for j=1:length(coal)
        f_test(i,j) = sum([coal(j); sol(i)].*(w_euro*(maintenance_cost+fuel_cost)+w_CO2*CO2_cost));
%        if coal(j)+sol(i) ~= 1
%            f_test(i,j) = 10;
%        end
    end
end

surf(coal,sol,f_test)

%% Perform fminbnd to earch for optimum
options = optimoptions('fmincon','Display','iter','Algorithm','sqp','OutputFcn',@outfun);
A = [1, 1]; b = 1;
x0 = [1; 0];
Aeq = [1, 1]; beq = 1;
lb = [0 0]; ub = [1 1];
nonlcon = [];
[x,fval,exitflag,output] = fmincon(@ftest,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)