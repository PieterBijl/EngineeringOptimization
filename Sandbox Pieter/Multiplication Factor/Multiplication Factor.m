x = linspace(0,1,100);
for i=1:100
    y(1,i) = x(i);
    y(2,i) = x(i)+1;
    y(3,i) = x(i);
    y(4,i) = x(i)+1;
    y(5,i) = x(i);
    y(6,i) = x(i);
    y(7,i) = 4*x(i)^2-4*x(i)+2;
    y(8,i) = 2-x(i);
    y(9,i) = 4*x(i)^2-4*x(i)+2;
    y(10,i) = 4*x(7)^2-4*x(7)+2;
    y(11,i) = 4*x(7)^2-4*x(7)+2;
end

figure
subplot(4,3,1)
plot(x,y(1,:)
hold on
subplot(4,3,2)
plot(x,y(2,:)
hold on
subplot(4,3,3)
plot(x,y(3,:)
hold on
subplot(4,3,4)
plot(x,y(4,:)
hold on
subplot(4,3,5)
plot(x,y(5,:)
hold on
subplot(4,3,6)
plot(x,y(6,:)
hold on
subplot(4,3,7)
plot(x,y(7,:)
hold on
subplot(4,3,8)
plot(x,y(8,:)
hold on
subplot(4,3,9)
plot(x,y(9,:)
hold on
subplot(4,3,10)
plot(x,y(10,:)
hold on
subplot(4,3,11)
plot(x,y(11,:)
hold on