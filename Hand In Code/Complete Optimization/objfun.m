function [f, g] = objfun(x)
    global energy_cost capital_loan_duration build_cost subsidies
%     M_f = [1; 1; 1; 4*x(4)^2-4*x(4)+2; 1; 1; 1; 1; 1; 1; 1];%4.4444444*10^-15*x(4)^2-1.33333333*10^-7*x(4)];
    M_f = ones(11,1);
    M_f(2) = x(2)+1;
    M_f(4) = x(4)+1;
    M_f(7) = 4*x(7)^2-4*x(7)+2;
    M_f(8) = 2-x(8);
    M_f(9) = 4*x(9)^2-4*x(9)+2;
    M_f(10) = 4*x(10)^2-4*x(10)+2;
    M_f(11) = 4*x(11)^2-4*x(11)+2;
    new_cost = x.*(M_f.*(build_cost/(capital_loan_duration*8760)+energy_cost)+subsidies');
    f = sum(new_cost);
    g = jacobjfun(x);
end