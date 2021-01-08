%% Questo script carica nel workspace le variabili di interesse per 
% simulare l'uniciclo

clear all; close all; clc;

disp('Caricamento Biciclo')
%% scelta percorso

tipo_perc = input(' Scegli un percorso da far fare all''uniciclo: \n 1: Raggiungimento di un punto \n 2: Circonferenza di raggio fissato \n 3: Percorso con clotoidi \n 4: Retta passante origine \n 5: Sinusoide \n... ');

% Simulink Variant settings
Punto			= Simulink.Variant('tipo_perc == 1');
Circonferenza	= Simulink.Variant('tipo_perc == 2');
Clotoidi		= Simulink.Variant('tipo_perc == 3');
Retta			= Simulink.Variant('tipo_perc == 4');
Sinusoide		= Simulink.Variant('tipo_perc == 5');

%% parametri simulazione

t_end		= 20;		% simulation time
threshold	= 1e-2;		% soglia numerica

%% parametri biciclo

L			= 1;	% interasse [m]
v_rif		= 0.1;	% velocità di riferimento lungo la traiettoria curvilinea [m/s]

%% parametri controllo biciclo

% K1 = [20; 20];		% error on x_M, y_M
% K2 = [100; 100];	% error on x_M dot, y_M dot
% K3 = [10; 10];		% error on x_M ddot, y_M ddot


K1 = [20; 20];		% error on x_M, y_M
K2 = [100; 100];	% error on x_M dot, y_M dot
K3 = [10; 10];		% error on x_M ddot, y_M ddot

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
if size(points,1) > 1 || size(points,1) < 1
	warning('Hai inserito troppi punti iniziali! Partira` dall''origine')
	x_M_iniziale	= 0;	% posizione asse x iniziale [m]
	y_M_iniziale	= 0;	% posizione asse y iniziale [m]
else
	x_M_iniziale	= points(1);	% posizione asse x iniziale [m]
	y_M_iniziale	= points(2);	% posizione asse y iniziale [m]
end

% x_M_iniziale		= 10;	% posizione asse x iniziale [m]
% y_M_iniziale		= -20;	% posizione asse y iniziale [m]
v_P_iniziale		= 1;	% velocita` piano iniziale [m\s]
v_P_dot_iniziale	= 0.1;	% derivata velocita` piano iniziale [m\s]
theta_P_iniziale	= 0;	% angolo heading iniziale [rad]
phi_iniziale		= pi/18;% angolo sterzo iniziale [rad]


%% PERCORSI
switch tipo_perc
	%% Raggiungimento punto
	case 1
		figure(1)
		clf
		l_ginput = 30; 
		h_ginput = 20;
		plot(x_M_iniziale, y_M_iniziale, 'b*', 'DisplayName', 'Punto Iniziale' )
		xlim([-l_ginput l_ginput]);
		ylim([-h_ginput h_ginput]);
		grid on
		daspect([1 1 1])
		title('Clickare su da dove si vuole far arrivare l''uniciclo! Poi premere invio')
		points = ginput;
		if size(points,1) > 1 || size(points,1) < 1
			warning('Hai inserito troppi punti finali! Arrivera` al punto [30;-20]')
			x_M_finale	= 30;	% posizione asse x iniziale [m]
			y_M_finale	= -20;	% posizione asse y iniziale [m]
		else
			x_M_finale	= points(1);	% posizione asse x iniziale [m]
			y_M_finale	= points(2);	% posizione asse y iniziale [m]
		end
		
		offset_iniziale = 0.5;
		x_M_iniziale = x_M_iniziale + offset_iniziale;
		y_M_iniziale = y_M_iniziale + offset_iniziale*2;
		
	%% Circonferenza
	case 2
		figure(1)
		clf
		l_ginput = 30; 
		h_ginput = 20;
		plot(x_M_iniziale, y_M_iniziale, 'b*', 'DisplayName', 'Punto Iniziale' )
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
		
	%% Clotoidi
	case 3
	%%%   ginput
	figure(1)
	clf
	l_ginput = 30; 
	h_ginput = 20;

	plot(x_M_iniziale, y_M_iniziale, 'b*', 'DisplayName', 'Punto Iniziale' )
	xlim([-l_ginput l_ginput]);
	ylim([-h_ginput h_ginput]);
	grid on
	daspect([1 1 1])
	title('Clickare sui punti che si vuole raggiungere poi premere invio')
	points = ginput;
	%%% Points
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
	
	%% Sinusoide su una retta
	case 5 
		dir_retta = [1; 0];

end
