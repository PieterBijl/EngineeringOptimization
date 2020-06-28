%options = optimoptions('fmincon','Display','iter');
A = [1, 1]; b = 1;
x0 = [1; 0];
Aeq = [1, 1]; beq = 1;
lb = [0 0]; ub = [1 1];
nonlcon = [];
%[x,f,status,output,lambda]=slp_trust(@ftest,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)
[x,f,status,output,lambda]=slp_trust(@ftest,x0,[],lb,ub,[],A,b,Aeq,beq,[],[])