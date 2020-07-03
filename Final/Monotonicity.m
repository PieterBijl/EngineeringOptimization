% This program analyses the monotonicity of the cost functions

%% Constant multiplication factor

%% Linear increasing multiplication factor

%% Linear decreasing multiplication factor

%% Parabolic multiplication factor
c1 = 10;
c2 = 0;

p = [12*c1 -8*c1 c1+c2];

x = 1;
ys = zeros(1,100);
xs = zeros(1,100);
for i = linspace(0, 1)
    xs(x) = i;
    ys(x) = polyval(p, i);
    x=x+1;
end

plot(xs, ys)