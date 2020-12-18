function [first_condition,second_condition] = Teorema9(f,g,x,x0)
%i casi in cui il teorema 8 sono veramente pochi. Avendo il controllista a
%disposizione gli ingressi, ha anche la possibilità di sfruttare la
%retroazione per portare il sistema ad una forma lineare.
%Teorema che permette di vedere se il sistema NL può essere reso
%lineare tramite un opportuno cambiamento di variabili, devono essere
%rispettate 2 condizioni, la 1 chiede che il linearizzato approssimante
%sia controllabile, 
%			Sistema di partenza		
%				x_dot = f(x)+g(x)u; x(0) = x0
%			legge di retroazione dello stato con v nuovo riferimento
%				u = α(x) + β(x)*v
%			cambio di variabili	
%				z = Φ(x) tali per cui si abbia
%				z_dot = Az + Bv
%condizioni necessarie e sufficienti, per l'esistenza di α,β,Φ.
%esempio:
%% 1 condizione
first_condition = 0;
n = length(x);
% filtration = lie_bracket_n(f,g,x,n-1);
filtration = lie_bracket_n_corr(f,g,x,n-1);
if rank(subs(filtration, x, x0) == n) 
	first_condition = 1;
end
%% 2 condizione
% da come è scritto nelle dispense non riesco a capire se si debba fare
% ogni possibile combinazione
second_condition = 1;
for i = 0:n-1
	for j = 0:n-1
		result = lie_bracket_dist(lie_bracket_n(f,g,x,i), lie_bracket_n(f,g,x,j),x);
		inv = involutive([lie_bracket_n(f,g,x,i) lie_bracket_n(f,g,x,j)],result);
		if inv == 0
			second_condition = 0;
			break
		end
	end
end
