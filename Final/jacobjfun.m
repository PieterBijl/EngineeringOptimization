function dfdx = jacobjfun(x)
    global energy_cost capital_loan_duration build_cost subsidies
    cost = zeros(11,1);
    c1 = build_cost/(capital_loan_duration*8760)+energy_cost;
    cost(1) = c1(1) + subsidies(1);
    cost(2) = x(2) * c1(2) + c1(2) + subsidies(2);
    cost(3) = c1(3) + subsidies(3);
    cost(4) = x(4) * c1(4) + c1(4) + subsidies(4);
    cost(5) = c1(5) + subsidies(5);
    cost(6) = c1(6) + subsidies(6);
    cost(7) = 12 * c1(7) * x(7)^2 - 8 * c1(7) * x(7) + 2 * c1(7) + subsidies(7);
    cost(8) = -2 * x(8) * c1(8) + 2 * (c1(8) + subsidies(8));
    cost(9) = 12 * c1(9) * x(9)^2 - 8 * c1(9) * x(9) + 2 * c1(9) + subsidies(9);
    cost(10) = 12 * c1(10) * x(10)^2 - 8 * c1(10) * x(10) + 2 * c1(10) + subsidies(10);
    cost(11) = 12 * c1(11) * x(11)^2 - 8 * c1(11) * x(11) + 2 * c1(11) + subsidies(11);
    dfdx = sum(cost);
end