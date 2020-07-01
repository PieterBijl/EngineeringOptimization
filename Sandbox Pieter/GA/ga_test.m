x = ga(@test,3);

function f = test(x)
    f = sin(x(1))*x(2) + log(x(3))
end