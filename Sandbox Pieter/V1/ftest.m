function f = ftest(x)
    x
    w_euro = 0.5;
    w_CO2 = 0.5;
    fuel_cost = [0.1; 0; 0.05];
    maintenance_cost = [0.1; 0.3; 0.05];
    CO2_cost = [0.2; 0.05; 0.1]; % How much CO2 do they emit?
    f = sum([x(1); x(2); x(3)].*(w_euro*(maintenance_cost+fuel_cost)+w_CO2*CO2_cost));
end