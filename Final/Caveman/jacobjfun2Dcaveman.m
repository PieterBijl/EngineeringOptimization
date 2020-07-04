function dfdx = jacobjfun2Dcaveman(x)
    global energy_cost capital_loan_duration build_cost subsidies
    dfdx = zeros(2,1);
    c1 = build_cost/(capital_loan_duration*8760)+energy_cost;
    dfdx(1) = c1(1) + subsidies(1);
    dfdx(2) = 12 * c1(2) * x(2)^2 - 8 * c1(2) * x(2) + 2 * c1(2) + subsidies(2);
end