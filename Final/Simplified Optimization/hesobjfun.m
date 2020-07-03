function hes = hesobjfun(x,lambda)
    global energy_cost capital_loan_duration build_cost 
    dfdx2 = zeros(2,1);
    c1 = build_cost/(capital_loan_duration*8760)+energy_cost;
    dfdx2(2) = 24 * c1(2) * x(2) - 8 * c1(2);
    hes = eye(2).*dfdx2;
end