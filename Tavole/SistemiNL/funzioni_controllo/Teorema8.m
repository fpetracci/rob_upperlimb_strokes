function [first_condition,second_condition] = Teorema8(f,g,x)
%Teorema che permette di vedere se il sistema NL può essere reso
%lineare tramite un opportuno cambiamento di variabili, devono essere
%rispettate 2 condizioni, la 1 chiede che il linearizzato approssimante
%sia controllabile, la 2 condizione analoga a quella di rettificazione
%simultanea dei campi gi(x)
%% 1 condizione
first_condition = 0;
n = length(x);
filtration = lie_bracket_n(f,g,x,n-1);
if rank(filtration) == n 
	first_condition = 1;
end
%% 2 condizione
% da come è scritto nelle dispense non riesco a capire se si debba fare
% ogni possibile combinazione
second_condition = 1;
for i = 0:n-1
	for j = 0:n-1
		result = lie_bracket_dist(lie_bracket_n(f,g,x,i), lie_bracket_n(f,g,x,j),x);
		if result ~= 0
			second_condition = 0;
			brake
		end
	end
end
		

