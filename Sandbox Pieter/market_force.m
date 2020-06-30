clear all
powerplant_parameters;
A = [1, 1, 1, 1]; b = 1;
x0 = [1; 0; 0; 0];
Aeq = [1, 1, 1, 1]; beq = 1;
lb = [0 0 0 0]; ub = [1 1 1 1];
nonlcon = [];
[xsol,fsol] = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon);
x1(:,1) = x0;
i = 1;
gov_total_cost(1) = 0;
total_market_cost(1) = 0;
tic;
while sum(abs(x1(:,i)-xsol)) > 0.01 & i<1000
    options = optimoptions(@fmincon,'MaxIterations',1,'Algorithm','interior-point','Display','off');
    [xsol_temp,f1(i)] = fmincon(@objfun,x1(:,i),A,b,Aeq,beq,lb,ub,nonlcon,options);
    dx = xsol_temp-x1(:,i);
    norm_dx = dx/norm(dx);
    unit_cost = sum(abs(norm_dx).*build_cost);
    dx_step = budget/unit_cost*norm_dx;
    x1(:,i+1) = x1(:,i)+dx_step;
    misc_cost = [0.55*x1(1,i)^2-1.1*x1(1,i)+0.6; 5.2*x1(2,i)^2-5.2*x1(2,i)+1.5; 0.55*x1(1,i)^2-1.1*x1(1,i)+0.6; 1.8*x1(4,i)^2-1.5*x1(4,i)+0.5];
    market_cost(:,i) = x1(:,i).*budget*(maintenance_cost+energy_cost+misc_cost+1/20*(build_cost+build_subsidies)+subsidies);
    total_market_cost(i+1) = total_market_cost(i)+sum(market_cost(:,i));
    gov_build_subsidies(:,i) = abs(dx_step).*abs(build_subsidies);
    gov_subsidies(:,i) = budget*x1(:,i).*subsidies;
    gov_cost(:,i) = gov_build_subsidies(:,i)+gov_subsidies(:,i);
    gov_total_cost(i+1) = total_cost(i)+sum(gov_cost(:,i));
    i = i + 1;
end
toc;
figure;
plot3(x1(2,:),x1(3,:),x1(4,:))
grid on
xlabel('Solar')
ylabel('Gas')
zlabel('Wind')

function f = objfun(x)
    powerplant_parameters;
    misc_cost = [0.55*x(1)^2-1.1*x(1)+0.6; 5.2*x(2)^2-5.2*x(2)+1.5; 0.55*x(1)^2-1.1*x(1)+0.6; 1.8*x(4)^2-1.5*x(4)+0.5];
    f = sum([x(1); x(2); x(3); x(4)].*(w_euro*(maintenance_cost+energy_cost+misc_cost+1/20*(build_cost+build_subsidies)+subsidies)+w_CO2*CO2_cost));
end

