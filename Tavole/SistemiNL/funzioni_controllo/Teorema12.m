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
clear all; clc
syms x1 x2 x3 u syms
x = [x1;x2;x3];
fprintf('lo stato iniziale del sistema è: \n')
x0 = [0;0;0]
f = [x3-x2^3;-x2;x1^2-x3]
g = [0;-1;1]
fprintf('l''uscita del sistema è data da: \n')
y = x1
[r,Lf_full,Lg_full] = relative_degree(f,g,y,x);
fprintf('il grado relativo è : \n')
r
if r<length(x)
	fprintf('per l''uscita selezionata non si ha grado relativo pari a n: \n applichiamo il teorema 11 per vedere se esiste un''uscita che ammetta grado relativo pari ad n ')
	[condizione1_T11,condizione2_T11] = Teorema10(f,g,x,x0)
end
if sum(condizione1_T11,condizione2_T11) == 2
	fprintf('esiste un ingresso che ammette grado n : \n')
else
	fprintf('non esiste!!! \n sei stato sfortunato.... \n non preoccuparti c''è la zero dinamica a salvarti')
end
phi = [y;transpose(Lf_full(1,1:r-1))];
fprintf([' abbiamo già ',num2str(r),' variabili per completare la Φ, e sono : \n '])
phi
fprintf(['ne mancano ',num2str(length(x)-r)])
fprintf(', per trovarle va risolta quest''equazione jacobian(η1)*g = 0, per trovare η1')
eq = transpose(x)*g == 0
% non sono riuscito ad automatizzare la procedura
fprintf(' jacobian(η1) puo'' valere sia [α 0 0] che [0 α α] \n ne segue che η1 può essere sia αx1 che αx2+αx3 \n scegliamo la seconda perchè indipendente da phi ')

phi = [phi ; x2+x3]
det = det(jacobian(phi,x));
if det~= 0
	fprintf('bravo buona scelta')
else
	fprintf('ritenta')
end
fprintf('per il teorema 12 andiamo a studiare la zero dinamica e vediamo se è A.S.')
epsilon1_dot = phi(2)
epsilon2_dot = jacobian(phi(2),x)*f + jacobian(phi(2),x)*g*u
fprintf('si può ricavere la u')
etha1_dot = jacobian(phi(3),x)*f + jacobian(phi(3),x)*g 
