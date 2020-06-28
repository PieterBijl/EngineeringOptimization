function [f_CO2, f_cost, f_total, time] = path_calculator(x,n)
    parameters_2;
    %x is the vector that is returned with the intermediate values of the
    %optimization, n is the number of dimensions
    f_cost = 0;
    f_CO2 = 0;
    f_total = 0;
    time = 0;
    for i=2:length(x)/n
        dx(i,:) = x(i*n-n+1:i*n)-x((i-1)*n-n+1:(i-1)*n);
        cost_to_build = build_cost.*abs(dx(i,:))';
        dt = sum(cost_to_build)/budget
        time = time + dt;
        time_dependent_cost = dt*(fuel_cost+maintenance_cost);
        new_CO2 = dt*CO2_cost;
        new_cost = cost_to_build+time_dependent_cost;
        f_cost = f_cost + new_cost
        f_CO2 = f_CO2+new_CO2;
        f_total = f_total + w_euro*new_cost+w_CO2*new_CO2;
    end
end