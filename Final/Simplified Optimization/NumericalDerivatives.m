[powerplants, cost, carbon] = PowerPlant();
global x0 w_dollar energy_cost capital_loan_duration dt build_cost CO2_cost P plot_on w_CO2
build_cost = [cost(1,1); cost(10,1)];
energy_cost = [cost(1,2); cost(10,2)];
CO2_cost = [carbon(1,1); carbon(10,1)];
w_dollar = 0.5;
capital_loan_duration = 20;
w_CO2 = 50/1000; % dollars per kg CO2
plot_on = 0; % Do not plot in the scenario function
dt = 1; 
P = 30*10^6; % Power in kW

x0_sub = [0, 0];
n = 1000;



hx = logspace(-20,0,n);
scenariox = zeros(2,n);
for i = 1:1:length(hx)
    dx = hx(i);
    
    fx1 = scenario2D(x0_sub);
    fxplush1 = scenario2D([x0_sub(1)+dx, x0_sub(2)]);
    scenariox(1,i) = (fxplush1-fx1)./dx;
    fx2 = scenario2D(x0_sub);
    fxplush2 = scenario2D([x0_sub(1), x0_sub(2)+dx]);
    scenariox(2,i) = (fxplush2-fx2)./dx;
end

figure;
set(gca,'xscale','log')
semilogx(hx, scenariox)
ylabel("First Order Derivative of Scenario Model")
xlabel("Delta x")
legend("Partial Derivative with respect to subsidy 1", "Partial Derivative with respect to subsidy 2")
