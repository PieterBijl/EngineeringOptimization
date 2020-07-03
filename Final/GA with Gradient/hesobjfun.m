function hes = hesobjfun(x,lambda)
    global energy_cost capital_loan_duration build_cost 
    dfdx2 = zeros(11,1);
    c1 = build_cost/(capital_loan_duration*8760)+energy_cost;
    dfdx2(2) = c1(2);
    dfdx2(4) = c1(4);
    dfdx2(7) = 24 * c1(7) * x(7) - 8 * c1(7);
    dfdx2(8) = -2 * c1(8);
    dfdx2(9) = 24 * c1(9) * x(9) - 8 * c1(9);
    dfdx2(10) = 24 * c1(10) * x(10) - 8 * c1(10);
    dfdx2(11) = 24 * c1(11) * x(11) - 8 * c1(11);
    hes = eye(11).*dfdx2;
end