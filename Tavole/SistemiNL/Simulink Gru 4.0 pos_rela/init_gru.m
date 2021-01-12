%% Questo script carica nel workspace le variabili di interesse per 
% simulare l'uniciclo

clear all; close all; clc;

disp('Caricamento Gru')
%% scelta percorso

%tipo_perc = input(' Scegli un percorso da far fare al carico della gru: \n 1: Raggiungimento di un punto \n 2: Circonferenza di raggio fissato \n 3: Percorso con clotoidi \n 4: Retta passante origine \n 5: Sinusoide \n... ');
% TEMPORANEO
tipo_perc = 1;

% Simulink Variant settings
Punto			= Simulink.Variant('tipo_perc == 1'); % non funziona
Circonferenza	= Simulink.Variant('tipo_perc == 2'); % okay se non troppo rapida
Clotoidi		= Simulink.Variant('tipo_perc == 3'); % okay se non troppo rapida
Retta			= Simulink.Variant('tipo_perc == 4'); % okay
Sinusoide		= Simulink.Variant('tipo_perc == 5'); % okay

%% parametri simulazione

t_end		= 200;		% simulation time % era 20 prima
threshold	= 1e-2;		% soglia numerica

%% parametri gru

g			= 9.81; % acc gravita [m/s^2]
% z_t		= 0;	% definita sotto
v_rif		= 1;	% velocità di riferimento lungo la traiettoria curvilinea [m/s]
a_rif		= 0.5; % accelerazione di riferimento lungo la traiettoria curvilinea [m/s^2]

% azioni di controllo saturazione
x_t_ddot_sat	= 3;	% [m/s^2] suggested 0.3
y_t_ddot_sat	= 3;	% [m/s^2] suggested 0.3
L_ddot_sat		= 0.5;	% [m/s^2] suggested 0.5

b_smorza	= 3;  % coefficiente di smorzamento su theta

% limiti ambiente di lavoro
xmin_workplace = -Inf;
xmax_workplace = Inf;
ymin_workplace = -Inf;
ymax_workplace = Inf;
Lmin = 0;
Lmax = 5;


%% parametri controllo gru

% K1 = [1; 1;	  1;   1;   1];
% K2 = [0.5; 0.5;	0.5; 0.5; 0.5];
K1 = [100; 100; 100];
K2 = [50; 50; 50];

%% stato iniziale

% statico
% x_t_iniziale		= 0;		% posizione asse x iniziale [m]
% y_t_iniziale		= 0;		% posizione asse y iniziale [m]
% x_t_dot_iniziale	= 0;		% velocita` piano iniziale [m\s]
% y_t_dot_iniziale	= 0;		% derivata velocita` piano iniziale [m\s]
% theta_iniziale		= 20/180*pi;	% angolo heading iniziale [rad]     metti a zero per partire col carico sotto al carrello
% theta_dot_iniziale	= pi/8;	
% phi_iniziale		= 30/180*pi;% angolo sterzo iniziale [rad]		metti a zero per partire col carico sotto al carrello
% phi_dot_iniziale	= 10/180*pi;
% L_iniziale			= 2;
% L_dot_iniziale		= 0;

% stato iniziale funzione di posizione palla
x_b_iniziale = 0;
y_b_iniziale = 0;
z_b_iniziale = 2;
% L = z_b_iniziale;

theta_iniziale		= 1e-2/180*pi;	% stato 5	(Non puo` essere 90 gradi!)
phi_iniziale		= 30/180*pi;	% stato 7
L_iniziale = z_b_iniziale/cos(theta_iniziale);

x_t_iniziale = x_b_iniziale - L_iniziale * sin(theta_iniziale) * sin(phi_iniziale);  % stato 1
y_t_iniziale = y_b_iniziale - L_iniziale * sin(theta_iniziale) * cos(phi_iniziale);	% stato 3
z_t = 0;

% derivate
x_t_dot_iniziale	= 0;		% stato 2
y_t_dot_iniziale	= 0;		% stato 4
theta_dot_iniziale	= 0;		% stato 6
phi_dot_iniziale	= 0;		% stato 8
L_dot_iniziale		= 0;		% stato 10


%% PERCORSI
switch tipo_perc
	%% Raggiungimento punto
	case 1
		x_b_finale = 2;
		y_b_finale = 2;
		z_b_finale = 2;
		
		traslazione = [	x_b_finale - x_b_iniziale;...
						y_b_finale - y_b_iniziale;...
						z_b_finale - z_b_iniziale];
		
		dir_retta = traslazione/ norm(traslazione,2);
		
		s_finale = norm(traslazione,2);
					
		
		
		
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
		if v_rif > 1
			v_rif = 1;
		end
		v_r = v_rif; % raggio dipende dalla velocità di rif
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
