%Eccoci all'ennesimo teorema.
% eravamo rimasti col trovare le n-r varabili per il cambio di variabili,
% nella bibbia c'è scritto che questa scelta deve "solo" soddisfare la
% condizione di costruire con le prime r funzioni, un cambiamento di
% variabili lecito(invertibile almeno localmente):
%	det(jacobian(Φ(x),x))~=0 CONTROLLARE BENE NON SONO SICURO CHE SIA SCRITTO BENE
% dato che si deve soddisfare solo questa condizione, si scelgono variabili
% senza andar a derivare la variabile precedente. In questo modo le nuove
% variabile non vanno ad intaccare l'uscita.
% per far si che l'ingresso non influenzi la dinamica delle variabili
% complementari si impone Lg_Φi = 0 =,r+1 <= i< =n
%							FORMA NORMALE
%--------------------------------------------------------------------------
% ε = [z1;....;zr]  η = [zr+1;zn] A0 = [[zeros(r-1,1) eye(r-1)]; zeros(r,1)]
% 						   | 0 |					| 0     1     0     0 |
%					b0=	   | 0 |				A0=	| 0     0     1     0 |
%						   | 0 |					| 0     0     0     1 |
% 						   | 1 |					| 0     0     0     0 |
% b0 = [zeros(r-1,1);1]
% c0 = [1 zeros(1,r-1)] = |1 0 0 0|
% ε_dot = A0ε +b0v			
% η_dot = q(ε,η)
% y = ε1 = c0*ε
% -------------------------------------------------------------------------
% da un punto di vista ingresso uscita il sistema è linearizzato con 
% f.d.t y(s)/v(s) = 1/s^r, dobbiamo però vedere la dinamica interna delle
% variabili η, per ora non abbiamo garantito che il sistema nel complesso
% non possa avere modi divergenti.
% vediamo che cosa susccede a ε_dot e η_dot determinando quali stati
% iniziali e quali controlli mantengano l'uscita a zero.Questo perchè
% le evoluzioni a partire da questi stati iniziali /controlli rappresentano
% i 'modi' della parte inaccessibile η0(t).
% per  ε si ha: y=ε1=0.....= εr-1=0 => ε0 = ε(t)= 0, 
%				zr_dot = b+a*u = 0  =>  u = -b(0,η)/a(0,η)
% per  η va studiata η_dot = q(0,η) che viene chiamata zero dinamica è qui
% che entra in gioco il teorema 12.
%								ENUNCIATO
%-------------------------------------------------------------------------
% con riferimento alla forma normale di cui sopra, una retroazione 
% v = v(ε)=kε con k=[-k0......-kr] coefficienti di un polinomio a radici
% con parte reale negativa, rende asintoticamente stabile il sistema non
% lineare originale se la zero dinamica η_dot = q(0,η) è A.S. in η0 = 0
%-------------------------------------------------------------------------
% esempio pag 179
syms x1 x2 x3 syms
x = [x1;x2;x3];
fprintf('lo stato iniziale del sistema è: \n')
x0 = [0;0;0]
f = [x3-x2^3;-x2;x1^2-x3]
g = [0;-1;1]
fprintf('l''uscita del sistema è data da: \n')
y = x1
Lf_y = jacobian(y,x)*f
Lg_y = jacobian(y,x)*g
[condizione1_T10,condizione2_T10] = Teorema10(f,g,x,x0)