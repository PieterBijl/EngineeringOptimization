clear all
build_cost = [0.1; 0.2; 0.1; 0.2]; % How much to build for coal and solar
budget = 0.001;
A = [1, 1, 1, 1]; b = 1;
x0 = [1; 0; 0; 0];
Aeq = [1, 1, 1, 1]; beq = 1;
lb = [0 0 0 0]; ub = [1 1 1 1];
nonlcon = [];
xsol = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon);
x1(:,1) = x0;
i = 0
while sum(abs(x1(:,i+1)-xsol)) > 0.01
    i = i + 1
    options = optimoptions(@fmincon,'MaxIterations',1,'Algorithm','sqp');
    xsol_temp = fmincon(@objfun,x1(:,i),A,b,Aeq,beq,lb,ub,nonlcon,options);
    dx = xsol_temp-x1(:,i);
    norm_dx = dx/norm(dx);
    unit_cost = sum(abs(norm_dx).*build_cost);
    dx_step = budget/unit_cost*norm_dx;
    x1(:,i+1) = x1(:,i)+dx_step;
end

function f = objfun(x)
    w_euro = 0.2;
    w_CO2 = 0.8;
    fuel_cost = [0.3; 0; 0.15; 0];
    maintenance_cost = [0.1; 0.05; 0.15; 0.2];
    misc_cost = [0.55*x(1)^2-1.1*x(1)+0.6; 5.2*x(2)^2-5.2*x(2)+1.5; 0.55*x(1)^2-1.1*x(1)+0.6; 1.8*x(4)^2-1.5*x(4)+0.5];
    CO2_cost = [0.3; 0.0; 0.2; 0.0]; % How much CO2 do they emit?
    f = sum([x(1); x(2); x(3); x(4)].*(w_euro*(maintenance_cost+fuel_cost+misc_cost)+w_CO2*CO2_cost));
end
