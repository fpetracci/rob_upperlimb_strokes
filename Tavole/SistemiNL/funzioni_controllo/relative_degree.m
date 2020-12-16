function  [n,Lf_full,Lg_full] = relative_degree(f,g,y,x)
% funzione che ritorna il grado relativo di un sistema che ha come uscita y
% in uscita ritorna rispettivamente, il grado relativo, e tutte le derivate
% direzionale della funzione scalare y(x) lungo il campo vettoriale f e
% g,DA CORREGERE QUESTA DEFINIZIONE, LEGGERA IMPRECISIONE
Lf_y = jacobian(y,x)*f;
Lg_y = jacobian(y,x)*g;
Lf_full = [Lf_y];
Lg_full = [Lg_y];
n = 1;
while n<length(x) && Lg_y == 0
	Lg_y = jacobian(Lf_y,x)*g;
	Lf_y = jacobian(Lf_y,x)*f;
	Lf_full = [Lf_full Lf_y];
	Lg_full = [Lg_full Lg_y];
	n = n+1;
end

