
c1 = 10;
c2 = 0;

p = [12*c1 -8*c1 c1+c2];

x0=0.5;

hx = logspace(-20,0,100);
dfdx = zeros(1,100);
for i = 1:1:length(hx)
    hxi = hx(i);
    
    fx = polyval(p, x0);
    fxplush = polyval(p, x0+hxi);
    dfdx(i,:) = (fx+fxplush)./hxi;
end

semilogx(hx, dfdx)