function [history,searchdir] = runfmincon
 clear all
% Set up shared variables with OUTFUN
history.x = [];
history.fval = [];
searchdir = [];
 
% call optimization
A = [1, 1, 1]; b = 1;
x0 = [1; 0; 0];
Aeq = [1, 1, 1]; beq = 1;
lb = [0 0 0]; ub = [1 1 1];
nonlcon = [];
options = optimoptions(@fmincon,'OutputFcn',@outfun,... 
    'Display','iter','Algorithm','sqp');
xsol = fmincon(@objfun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
 
 function stop = outfun(x,optimValues,state)
     stop = false;
 
     switch state
         case 'init'
             hold on
         case 'iter'
         % Concatenate current point and objective function
         % value with history. x must be a row vector.
           history.fval = [history.fval; optimValues.fval];
           history.x = [history.x; x];
         % Concatenate current search direction with 
         % searchdir.
           searchdir = [searchdir;... 
                        optimValues.searchdirection'];
           plot(x(1),x(2),'o');
         % Label points with iteration number and add title.
         % Add .15 to x(1) to separate label from plotted 'o'
           text(x(1)+.15,x(2),... 
                num2str(optimValues.iteration));
           title('Sequence of Points Computed by fmincon');
         case 'done'
             hold off
         otherwise
     end
 end
 
 function f = objfun(x)
    w_euro = 0.5;
    w_CO2 = 0.5;
    fuel_cost = [0.1; 0];
    maintenance_cost = [0.1; 0.3];
    CO2_cost = [0.2; 0.05]; % How much CO2 do they emit?
    f = sum([x(1); x(2)].*(w_euro*(maintenance_cost+fuel_cost)+w_CO2*CO2_cost));
 end
end