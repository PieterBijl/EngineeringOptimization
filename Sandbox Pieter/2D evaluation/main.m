[powerplants, cost, carbon] = PowerPlant();
global energy_cost build_cost subsidies capital_loan_duration
build_cost = [cost(2,1);cost(9,1)];
energy_cost = [cost(2,2);cost(9,2)];
subsidies = [0 0];
capital_loan_duration = 20;
%%
x = linspace(0,1,100); % Coal
y = linspace(0,1,100); % Wind
z = zeros(100,100);
for i = 1:length(x)
    for j = 1:length(y)
        z(i,j) = objfun([x(i); y(j)]);
    end
end
figure
grid on
surf(100*x,100*y,z)
title("Market cost function with Coal and Wind energy")
xlabel("Coal % of power supply")
ylabel("Wind % of power supply")
zlabel("Market cost")
