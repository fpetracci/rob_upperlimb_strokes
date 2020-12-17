function [first_condition,second_condition] = Teorema8(f,g,x,x0)
%Teorema che permette di vedere se il sistema NL può essere reso
%lineare tramite un opportuno cambiamento di variabili, devono essere
%rispettate 2 condizioni, la 1° chiede che il linearizzato approssimante
%sia controllabile, la 2° condizione analoga a quella di rettificazione
%simultanea dei campi gi(x)
% condizioni necessarie e sufficienti, teorema 
%% 1 condizione
num_sample = 100;
lim_inf = x0 - 0.1;
lim_sup = x0 + 0.1;
n = length(x);

%first_condition = 0;
%filtration = lie_bracket_n(f,g,x,n-1);
filtration = lie_bracket_n_corr(f,G,x);
x0_neigh = neigh_gen(x0, num_sample, lim_inf, lim_sup);
first_condition = 1;
for s = 1:num_sample
	a = filtration;
	subs(a, x, x0_neigh(:, s));
	if rank(a) == n 
		first_cond = 1;
	else
		first_cond = 0;
	end
	first_condition = first_condition * first_cond;
end
%% 2 condizione
% da come è scritto nelle dispense non riesco a capire se si debba fare
% ogni possibile combinazione
second_condition = 1;
for i = 0:n-1
	for j = 0:n-1
		result = lie_bracket_dist(lie_bracket_n(f,g,x,i), lie_bracket_n(f,g,x,j),x);
		if involutive([0;0;0],result) == 0 %se il risultato non è involutivo a [0;0;0]la seconda condizione non è rispettata
			second_condition = 0;
			break
		end
	end
end
