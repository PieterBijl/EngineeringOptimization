% [A,B,C] = MFcoef1(1.2, 1.3)
% 
% ys = zeros(1,101);
% for i = 0:0.01:1
%     ys(round(i*100+1)) = polyval([A B C], i)
% end
% 
% plot(ys)

function [a,b,c] = MFcoef(y1,y2)
    c = y1;
    p = [(y1-1)-(y2-1), -2*(y1-1), (y1-1)];
    r = roots(p);
    h = r(2);
    a = (y1-1)/(h)^2;
    b = -2*h;
end