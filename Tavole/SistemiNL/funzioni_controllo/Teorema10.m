function [first_condition,second_condition] = Teorema10(f,g,x,x0)
% l'unica differenza con il teorema 9 sta nel fatto che diamo in ingresso
% anche x0, stato iniziale. La seconda condizione è identica a quella del
% teorema 9, la prima varia solo per il fatto che viene calcolato il rango 
% valutando lo span di lie_bracket_n(f,g,x,n-1) in x0.
%			Sistema di partenza		
%				x_dot = f(x)+g(x)u; x(0) = x0
%			legge di retroazione dello stato con v nuovo riferimento
%				u = α(x) + β(x)*v
%			cambio di variabili	
%				z = Φ(x) tali per cui si abbia
%				z_dot = Az + Bv
% Una volta verificato il teorema 9 è bene troavare una procedura per
% determinare α,β,Φ. Avendo la possibilità di scegliere una retroazione
% degli stati sugli ingressi, si potrà sempre anche scegliere
% arbitrariamente la posizione degli autovalori di A, potendo anche
% scegliere le coordinate si può portare il sitema in una forma canonica.
% Per semplicità senza perdere di generalità, portiamo tutti cli autovalori
% nell'origine e che la coppia (A,B) sia in forma canonica di controllo.
% si avrà che le componenti del nuovo vettore di stato saranno
%		z_1_dot = z2
%			.
%			.
%		z_n-1_dot = z_n
%		z_n = v
% avere le componenti descritte in questa forma ci consente di fare
% considerazioni per poi poter risolvere un sistema di equazioni, si veda
% theorem9 dispense bicchi. 
% il risultato importante è che α,β dipendono da Φ1(x), prima componente di
% Φ(x).Per verificare che esista una Φ1(x) tale per cui siano verificate le
% condizioni imposte,8.8-8.9 bicchi, tali condizioni vanno verificate.

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
