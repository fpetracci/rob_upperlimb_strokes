function [first_condition,second_condition] = Teorema11(f,g,x,x0)
% la linearizzazione esatta in retroazione(ingresso-stati) può essere
% inappropriata in certi casi:
% a) se x_dot = x_dot = f(x)+g(x)u, non soddisfa le condizione del teorema 10
% b) se il sistema ha un'uscita con significato fisico tale da imporne la
%	 scelta
% c) se non si vuole o non si riesce ad integrare il sistema di equazione
%	 differenziali alle derivate parziali 8.8
% ENUNCIATO
% condizione necessaria e sufficiente affinchè esista una funzione che,
% presa come uscita del sistema x_dot = f(x)+g(x)u; con f(x0) = 0 dia grado
% relativo n
%				ovvero
% affinchè esistano un cambiamento di variabili Φ(x) e le funzioni di
% retroazione statica α(x), β(x) tali da linearizzare il sistema detto è
% che:
%% 1 condizione completa controllabilità approsimazione lineare
first_condition = 0;
n = length(x);
filtration = lie_bracket_n(f,g,x,n-1);
filtration_0 = subs(filtration,x,x0);
if rank(filtration_0) == n 
	first_condition = 1;
end
%% 2 condizione
% da come è scritto nelle dispense non riesco a capire se si debba fare
% ogni possibile combinazione
% N.B. va valutata in un intorno di x0,BHO
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
% condizioni identiche a quelle del teorema 10.
% N.B
% cosa mi dice in soldoni il teorema?
% se le due ipotesi vengono rispettate allora esiste un'uscita, non
% sappiamo come fatta, che dia grado relativo n.
%	N.B.B.
% con la retroazione dell'uscita anche se non ottengo un grado relativo
% pari ad n, ma un grado r < n, posso comunque procedere ad una
% linearizzazione esatta. utilizzo le r funzioni linearmente indipendenti
% come parte di un cambio di variabile:
% N.B. in questo caso h(x) è una funzione scalare non un campo vettoriale, .
%	z1 = Φ1(x)= h(x), h(x) = uscita del sistema
%	z2 = Φ2(x)= L_f(h(x)) = jacobian(h(x),x)*f la L in questo caso indica la derivata direzionale della funzione scalare h(x) lungo il campo vettoriale f
%			.
%	zr = Φr(x) = L_f^r-1(h(x))
% vanno trovate le n-r variabili complementari