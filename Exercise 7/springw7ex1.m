% Two variable valve spring problem - Exercise 7.1
% Visualization of real spring mass optimization problem,
% using springobj2.m (objective function: spring mass) and
% springcon3.m (constraints).
% Visualization of linearized spring mass optimization problem,
% using flinw7.m (linearized objective function: spring mass) and
% glinw7.m (linearized constraints).

% Initialization
clf, hold off
format long

% Design point, x0, where problem is linearized to be given outside springw7ex1.
% x0 = [0.035 0.0045];
% x0 = [0.014281767955801,0.003098130841121]
% x0 = [0.018701657458564,0.003397196261682]
% x0 = [0.022071823204420,0.003612149532710]
x0 = [0.023176795580111,0.003658878504673]
% x0 = ginput(1);

% Combinations of design variables D and d 
D = [0.010:0.001:0.040];
d = [0.002:0.0002:0.006];

% Matrix of output values for combinations of design variables D and d: 
for j=1:1:length(d)
  for i=1:1:length(D)
    % Assignment of design variables:
    x(1) = D(i);
    x(2) = d(j);
 	 % Real objective function
    f = springobj2(x);
    % Grid value of objective function:
    fobj(j,i) = f; 
    
    % Linearized objective function
    flin = flinw7(x,x0);
    % Grid value of objective function:
    flingrid(j,i) = flin; 
    
    
    % Real constraints:
    g = springcon3(x);
    % Grid values of constraints:
    g1(j,i) = g(1);    % Scaled length constraint
    g2(j,i) = g(2);    % Scaled lowest force constraint
    g3(j,i) = g(3);    % Scaled highest force constraint
    g4(j,i) = g(4);    % Scaled shear stress constraint
    g5(j,i) = g(5);    % Scaled frequency constraint
    
    % Linearized constraints:
    glin = glinw7(x,x0);
    % Grid values of linearized constraints:
    g1lin(j,i) = glin(1);    % Scaled length constraint
    g2lin(j,i) = glin(2);    % Scaled lowest force constraint
    g3lin(j,i) = glin(3);    % Scaled highest force constraint
    g4lin(j,i) = glin(4);    % Scaled shear stress constraint
    g5lin(j,i) = glin(5);    % Scaled frequency constraint

  end
end

figure('Renderer', 'painters', 'Position', [10 10 900 600])

% Contour plot of real spring problem
contour(D, d, fobj)
xlabel('Coil diameter D (m)'), ylabel('Wire diameter d (m)'), ...
   title('Real (-) and linearized (--) spring mass optimization problem')
hold on
contour(D, d, g1, [0.0 0.0],'k')
contour(D, d, g2, [0.0 0.0],'b')
contour(D, d, g3, [0.0 0.0],'c')
contour(D, d, g4, [0.0 0.0],'g')
contour(D, d, g5, [0.0 0.0],'r')

% Contour plot of linearized spring problem
contour(D, d, flingrid,'--')
contour(D, d, g1lin, [0.0 0.0],'k--')
contour(D, d, g2lin, [0.0 0.0],'b--')
contour(D, d, g3lin, [0.0 0.0],'c--')
contour(D, d, g4lin, [0.0 0.0],'g--')
contour(D, d, g5lin, [0.0 0.0],'r--')

grid

% Plot marker in initial design point:
plot(x0(1),x0(2),'o');

clear all

%end 