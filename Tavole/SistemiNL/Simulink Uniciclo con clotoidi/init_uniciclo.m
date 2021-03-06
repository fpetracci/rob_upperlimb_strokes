%% Questo script carica nel workspace le variabili di interesse per 
% simulare l'uniciclo

clear all; close all; clc;

disp('Caricamento Uniciclo')

%% scelta percorso

tipo_perc = input(' Scegli un percorso da far fare all''uniciclo: \n 1: Raggiungimento di un punto \n 2: Circonferenza di raggio fissato \n 3: Percorso con clotoidi \n 4: Retta passante origine \n... ');

% Simulink Variant settings
Punto			= Simulink.Variant('tipo_perc == 1');
Circonferenza	= Simulink.Variant('tipo_perc == 2');
Clotoidi		= Simulink.Variant('tipo_perc == 3');
Retta			= Simulink.Variant('tipo_perc == 4');
%% parametri simulazione

t_end		= 20;		% simulation time
threshold	= 1e-3;		% soglia numerica

%% stato iniziale

figure(1)
clf
l_ginput = 30; 
h_ginput = 20;

xlim([-l_ginput l_ginput]);
ylim([-h_ginput h_ginput]);
grid on
daspect([1 1 1])
title('Clickare su da dove si vuole far partire l''uniciclo! Poi premere invio')
points = ginput;
if size(points,1) > 1
	warning('Hai inserito troppi punti iniziali! Partira` dall''origine')
	x_p_iniziale	= 0;	% posizione asse x iniziale [m]
	y_p_iniziale	= 0;	% posizione asse y iniziale [m]
else
	x_p_iniziale	= points(1);	% posizione asse x iniziale [m]
	y_p_iniziale	= points(2);	% posizione asse y iniziale [m]
end

v_iniziale		= 1;	% velocita` piano iniziale [m\s]
theta_iniziale	= pi/3;	% angolo iniziale [rad]
v_rif			= 3;	% velocità di riferimento lungo la traiettoria curvilinea [m/s]
%% parametri di saturazione
v_dot_sat = 5;			% saturazione controllo sull'accelerazione lineare[m/s^2]
w_sat = 3*pi;				% saturazione controllo sulla velocità angolare[rad/s]
%% parametri controllo

% K1 = [10; 10];	% error on x_p, y_p
% K2 = [20; 20];	% error on x_p dot, y_p dot

%% PERCORSI
switch tipo_perc
	%% Raggiungimento punto
	case 1
		figure(1)
		clf
		%% controlli raggiungimento punto
		K1 = [20; 20];	% error on x_p, y_p
		K2 = [10; 10];	% error on x_p dot, y_p dot
		l_ginput = 30; 
		h_ginput = 20;
		plot(x_p_iniziale, y_p_iniziale, 'b*', 'DisplayName', 'Punto Iniziale' )
		xlim([-l_ginput l_ginput]);
		ylim([-h_ginput h_ginput]);
		grid on
		daspect([1 1 1])
		title('Clickare su da dove si vuole far arrivare l''uniciclo! Poi premere invio')
		points = ginput;
		if size(points,1) > 1
			warning('Hai inserito troppi punti finali! Arrivera` al punto [30;-20]')
			x_p_finale	= 30;	% posizione asse x iniziale [m]
			y_p_finale	= -20;	% posizione asse y iniziale [m]
		else
			x_p_finale	= points(1);	% posizione asse x iniziale [m]
			y_p_finale	= points(2);	% posizione asse y iniziale [m]
		end
		traslazione = [	x_p_finale - x_p_iniziale;...
						y_p_finale - y_p_iniziale];
		
		dir_retta = traslazione/ norm(traslazione,2);
		
		s_finale = norm(traslazione,2);
	%% Circonferenza
	case 2
		figure(1)
		clf
		% controlli cerchio
		K1 = [40; 40];	% error on x_p, y_p
		K2 = [50; 50];	% error on x_p dot, y_p dot
		l_ginput = 30; 
		h_ginput = 20;
		plot(x_p_iniziale, y_p_iniziale, 'b*', 'DisplayName', 'Punto Iniziale' )
		xlim([-l_ginput l_ginput]);
		ylim([-h_ginput h_ginput]);
		grid on
		daspect([1 1 1])
		title('Clickare su da dove si vuole il centro della circonferenza! Poi premere invio')
		points = ginput;
		if size(points,1) > 1
			warning('Hai inserito troppi punti come centri! Il centro sara` il punto [ 0; 0]')
			centro	= [0;0];	% posizione del centro [m]
		else
			centro	= [points(1); points(2)];	% posizione del centro [m]
		end
		if v_rif > 1
			v_rif = 1;
		end
		v_r = v_rif; % raggio dipende dalla velocità di rif
	%% Clotoidi
	case 3
	%%%   ginput
	figure(1)
	clf
	% controlli raggiungimento clotoide
	K1 = [40; 40];	% error on x_p, y_p
	K2 = [50; 50];	% error on x_p dot, y_p dot
	l_ginput = 30; 
	h_ginput = 20;

	plot(x_p_iniziale, y_p_iniziale, 'b*', 'DisplayName', 'Punto Iniziale' )
	xlim([-l_ginput l_ginput]);
	ylim([-h_ginput h_ginput]);
	grid on
	daspect([1 1 1])
	title('Clickare sui punti che si vuole raggiungere poi premere invio')
	points = ginput;
	%%% Points
	points = [x_p_iniziale, y_p_iniziale ; points];
	n_p = length(points);    %numero di punti
	xp  = points(:,1);
	yp  = points(:,2);
	
	npts = 400;             %risoluzione
	theta_rette = zeros(n_p-1,1);
	for i= 1:(n_p-1)        %creazione angoli per le rette
		theta_rette(i)=atan2( (yp(i+1)-yp(i)), (xp(i+1)-xp(i)) );
	end

	% se n_p dispari
	if mod(n_p,2) == 1
	   theta_rette=[theta_rette ; theta_rette(n_p-2)+pi];  %aggiungo theta finale casi dispari
	end

	Lenghts=[];               %Vettore con la lunghezza dei tratti
	Lsofar=[];          %Vettore con le lunghezze dei tratti cumulative

	for i=1:(n_p-1)			%Creazione Punti percorso e indexclot
		if  mod(i,2)==1         %dispari, tratti rettilinei
			Lenghts= [Lenghts ; ( (yp(i+1)-yp(i))^2 + (xp(i+1)-xp(i))^2 )^0.5];
			Lsofar=[Lsofar; sum(Lenghts)]; 
		elseif mod(i,2)==0      %pari, tratti clotodei
			[S0,S1,SM,SG,iter] = buildClothoid3arcG2( xp(i), yp(i), theta_rette(i-1), 0, xp(i+1), yp(i+1), theta_rette(i+1), 0);
			indexclot(i/2).clot.S0= S0;
			indexclot(i/2).clot.SM= SM;
			indexclot(i/2).clot.S1= S1;
			Lsofarclot(i/2).Lclot(1)= indexclot(i/2).clot.S0.L;
			Lsofarclot(i/2).Lclot(2)= indexclot(i/2).clot.S0.L+indexclot(i/2).clot.SM.L;

			lclot=indexclot(i/2).clot.S0.L+indexclot(i/2).clot.SM.L+indexclot(i/2).clot.S1.L;         
			Lenghts= [Lenghts ; lclot];
			Lsofar=[Lsofar; sum(Lenghts)];
		end

	end

	Ltot=sum(Lenghts); %Lunghezza totale percorso
	%% Retta
	case 4 
		dir_retta = [cos(pi/4); sin(pi/4)];
		K1 = [40; 40];	% error on x_p, y_p
		K2 = [50; 50];	% error on x_p dot, y_p dot

end


