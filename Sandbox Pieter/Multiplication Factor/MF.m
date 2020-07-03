x = linspace(0,1,100);
for i=1:100
    y(1,i) = 1;
    y(2,i) = x(i)+1;
    y(3,i) = 1;
    y(4,i) = x(i)+1;
    y(5,i) = 1;
    y(6,i) = 1;
    y(7,i) = 4*x(i)^2-4*x(i)+2;
    y(8,i) = 2-x(i);
    y(9,i) = 4*x(i)^2-4*x(i)+2;
    y(10,i) = 4*x(i)^2-4*x(i)+2;
    y(11,i) = 4*x(i)^2-4*x(i)+2;
end

figure
subplot(4,3,1)
plot(x,y(1,:))
ylim([0 2])
hold on
title("Coal")
xlabel("Power Fraction")
ylabel("MF")
subplot(4,3,2)
plot(x,y(2,:))
ylim([0 2])
hold on
title("Coal with CC")
xlabel("Power Fraction")
ylabel("MF")
subplot(4,3,3)
plot(x,y(3,:))
ylim([0 2])
hold on
title("Natural Gas")
xlabel("Power Fraction")
ylabel("MF")
subplot(4,3,4)
plot(x,y(4,:))
ylim([0 2])
hold on
title("Natural Gas with CC")
xlabel("Power Fraction")
ylabel("MF")
subplot(4,3,5)
plot(x,y(5,:))
ylim([0 2])
hold on
title("Nuclear")
xlabel("Power Fraction")
ylabel("MF")
subplot(4,3,6)
plot(x,y(6,:))
hold on
title("Biomass")
xlabel("Power Fraction")
ylabel("MF")
subplot(4,3,7)
plot(x,y(7,:))
ylim([0 2])
hold on
title("Geothermal")
xlabel("Power Fraction")
ylabel("MF")
subplot(4,3,8)
plot(x,y(8,:))
ylim([0 2])
hold on
title("Hydroelectric")
xlabel("Power Fraction")
ylabel("MF")
subplot(4,3,9)
plot(x,y(9,:))
ylim([0 2])
hold on
title("Onshore Wind")
xlabel("Power Fraction")
ylabel("MF")
subplot(4,3,10)
plot(x,y(10,:))
ylim([0 2])
hold on
title("Offshore Wind")
xlabel("Power Fraction")
ylabel("MF")
subplot(4,3,11)
plot(x,y(11,:))
ylim([0 2])
hold on
title("Solar")
xlabel("Power Fraction")
ylabel("MF")