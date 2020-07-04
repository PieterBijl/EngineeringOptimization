[powerplants, cost, carbon] = PowerPlant();
build_cost = cost(1,1);
energy_cost = cost(1,2);
capital_loan_duration = 20;

c1 = build_cost/(capital_loan_duration*8760)+energy_cost;
c2 = 0; % Subsidy equal to 0.

p1 = [0, 0, c1+c2];
p2 = [0, 2*c1, c1+c2];
p3 = [0, -2*c1, 2*c1+c2];
p4 = [12*c1, -8*c1, 2*c1+c2];

x0=0.5; % x around which the derivative is approximated
n = 1000;

d1 = 0;
d2 = 2 * c1;
d3 = -2 * c1;
d4 = 24 * c1 * x0 - 8 * c1;

ds(1,1:n) = d1;
ds(2,1:n) = d2;
ds(3,1:n) = d3;
ds(4,1:n) = d4;

hx = logspace(-20,0,n);
dfdx = zeros(4,100);
for i = 1:1:length(hx)
    hxi = hx(i);
    
    fx1 = polyval(p1, x0);
    fxplush1 = polyval(p1, x0+hxi);
    dfdx(1,i) = (fxplush1-fx1)./hxi;
    
    fx2 = polyval(p2, x0);
    fxplush2 = polyval(p2, x0+hxi);
    dfdx(2,i) = (fxplush2-fx2)./hxi;
    
    fx3 = polyval(p3, x0);
    fxplush3 = polyval(p3, x0+hxi);
    dfdx(3,i) = (fxplush3-fx3)./hxi;
    
    fx4 = polyval(p4, x0);
    fxplush4 = polyval(p4, x0+hxi);
    dfdx(4,i) = (fxplush4-fx4)./hxi;
    
end

colorspec = {[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]; [0.9290 0.6940 0.1250]; ...
  [0.4940 0.1840 0.5560]};
figure;
set(gca,'xscale','log')
hold on
for i = 1:4
    semilogx(hx, dfdx(i,:), hx, ds(i,:), '--', 'color', colorspec{i});
end
ylabel("Second Order Derivative")
xlabel("Delta x")
legend("Case 1 Approximation", "Case 1", "Case 2 Approximation", "Case 2", ...
    "Case 3 Approximation", "Case 3", "Case 4 Approximation", "Case 4")