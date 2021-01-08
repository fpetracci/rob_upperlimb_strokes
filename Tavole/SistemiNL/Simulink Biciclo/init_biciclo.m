%% Questo script carica nel workspace le variabili di interesse per 
% simulare l'uniciclo

clear all; close all; clc;

disp('Caricamento Uniciclo')

%% parametri simulazione

t_end		= 20;		% simulation time
threshold	= 1e-3;		% soglia numerica
%% stato iniziale

x_p_iniziale	= 10;	% posizione asse x iniziale [m]
y_p_iniziale	= -20;	% posizione asse y iniziale [m]
v_iniziale		= 1;	% velocita` piano iniziale [m\s]
theta_iniziale	= pi/3;	% angolo iniziale [rad]

x_p_finale	= 0;	% posizione asse x finale [m]
y_p_finale	= 0;	% posizione asse y finale [m]
v_rif		= 10;	% velocità di riferimento lungo la traiettoria curvilinea [m/s]
%% parametri controllo

K1 = [10; 10];	% error on x_p, y_p
K2 = [50; 50];	% error on x_p dot, y_p dot

%% Clotoidi
% %%%   ginput
% 
% l_ginput=30; 
% h_ginput=20;
% 
% xlim([0 l_ginput]);
% ylim([0 h_ginput]);
% grid on
% daspect([1 1 1])
% 
% points =ginput;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Points
% 
% n_p= length(points);    %numero di punti
% xp = points(:,1);
% yp = points(:,2);
% 
% epsi=10^(-3);           %epsilon per il calcolo di s+ e s-
% 
% npts=400;               %risoluzione
% 
% vmax=1;
% amax=0.25;
% 
% for i= 1:(n_p-1)        %creazione angoli
%     theta_rette(i)=atan2( (yp(i+1)-yp(i)), (xp(i+1)-xp(i)) );
% end
% 
% theta_rette=theta_rette';
% if mod(n_p,2) == 1
%    theta_rette=[theta_rette ; theta_rette(n_p-2)+pi];  %aggiungo theta finale casi dispari
% end
% 
% L=[];               %Vettore con la lunghezza dei tratti
% Lsofar=[];          %Vettore con le lunghezze dei tratti cumulative
% 
% for i=1:(n_p-1)     %Creazione Punti percorso e indexclot
% 	if mod(i,2)==1         %dispari, tratti rettilinei
% 		L= [L ; ( (yp(i+1)-yp(i))^2 + (xp(i+1)-xp(i))^2 )^0.5];
% 		Lsofar=[Lsofar; sum(L)]; 
% 	elseif mod(i,2)==0      %pari, tratti clotodei
% 		[S0,S1,SM,SG,iter] = buildClothoid3arcG2( xp(i), yp(i), theta_rette(i-1), 0, xp(i+1), yp(i+1), theta_rette(i+1), 0);
% 		indexclot(i/2).clot.S0= S0;
% 		indexclot(i/2).clot.SM= SM;
% 		indexclot(i/2).clot.S1= S1;
% 		Lsofarclot(i/2).Lclot(1)= indexclot(i/2).clot.S0.L;
% 		Lsofarclot(i/2).Lclot(2)= indexclot(i/2).clot.S0.L+indexclot(i/2).clot.SM.L;
% 
% 		lclot=indexclot(i/2).clot.S0.L+indexclot(i/2).clot.SM.L+indexclot(i/2).clot.S1.L;         
% 		L= [L ; lclot];
% 		Lsofar=[Lsofar; sum(L)];
%     end
% 
% end
% 
% Ltot=sum(L);            %Lunghezza totale percorso
% 
% if Ltot<vmax^2 / amax
%     ttot=2*(Ltot/amax)^0.5;
%     v_raggiunta=0; %vmax raggiunta non e` vmax
% else
%     ttot=(Ltot + vmax^2 /amax)/vmax;
%     v_raggiunta=1; %vmax raggiunta e` vmax
% end
% 
% a=amax;     %notazione ferrari
% v=vmax;
% s_f = Ltot;
% t_f = ttot;
% 
% clear vmax amax Ltot ttot i;
% close all;
