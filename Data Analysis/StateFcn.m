function x = StateFcn(x)
dt = 0.5;% va vista la frequenza di campionamento
x = x + StateFunctionContinuos(x)*dt;
end

function x = StateFunctionContinuos(x)
dxdt = [x(1) x(2) x(3) x(4) x(5) x(6) x(7) x(8) x(9) ]' ;
end
