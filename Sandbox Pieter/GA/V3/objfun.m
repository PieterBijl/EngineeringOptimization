function f = objfun(x)
    global energy_cost capital_loan_duration build_cost subsidies build_subsidies
%     M_f = [1; 1; 1; 4*x(4)^2-4*x(4)+2; 1; 1; 1; 1; 1; 1; 1];%4.4444444*10^-15*x(4)^2-1.33333333*10^-7*x(4)];
    M_f = ones(11,1);
    M_f(2) = 2;
    M_f(4) = 2;
    new_cost = x.*(M_f.*((build_cost+build_subsidies')/(capital_loan_duration*8760)+energy_cost)+subsidies');
    f = sum(new_cost);
end