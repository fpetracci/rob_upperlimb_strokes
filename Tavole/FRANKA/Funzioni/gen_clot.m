function out = gen_clot(points)
%Funzione generazione percorso - Francesco Petracci 27 - 04 - 2020

%% intro
%points = [ 1 1; 1 5; 5 5; 7 1];
scale_up = 10;

points = points * scale_up; % scalo i punti

n_p = length(points);    % numero di punti
xp = points(:,1);
yp = points(:,2);
numero_clotoidi = floor((n_p - 1)/2); % numero di clotoidi nel percorso

theta_rette = zeros(1, n_p - 1);	%inizializzazione 

% creazione angoli
for i= 1:(n_p-1)        
    theta_rette(i) = atan2( (yp(i+1)-yp(i)), (xp(i+1)-xp(i)) );
end

% aggiungo theta finale nel caso di numero di punti dispari
if mod(n_p,2) == 1
   theta_rette = [theta_rette , theta_rette(n_p-2)+pi];  
end

%% Creazione percorso

% inizializzazione
L = zeros(n_p - 1 , 1);				%Vettore con la lunghezza dei tratti
Lsofar = zeros(n_p - 1 , 1);		%Vettore con le lunghezze dei tratti cumulative

indexclot = repmat(struct('clot',struct), 1, numero_clotoidi);	% array di struct contenente le info sulle clotoidi
Lsofarclot = repmat(struct('clot',struct), 1, numero_clotoidi);	% array di struct contenente le lunghezze dei tratti cumulative

% Creazione Punti percorso e indexclot
for i = 1:(n_p-1)     
    if  mod(i,2) == 1         %dispari, tratti rettilinei
            
			L(i) = ( (yp(i+1)-yp(i))^2 + (xp(i+1)-xp(i))^2 )^0.5;
			if i == 1
				Lsofar(i) = L(i);
			else
				Lsofar(i) = Lsofar(i-1) + L(i); 
			end
			
    elseif mod(i,2) == 0      %pari, tratti clotodei
          
            [S0,S1,SM,SG,iter] = buildClothoid3arcG2( xp(i), yp(i), theta_rette(i-1), 0, xp(i+1), yp(i+1), theta_rette(i+1), 0);
            indexclot(i/2).clot.S0 = S0;
            indexclot(i/2).clot.SM = SM;
            indexclot(i/2).clot.S1 = S1;
			
            Lsofarclot(i/2).Lclot(1) = indexclot(i/2).clot.S0.L;
            Lsofarclot(i/2).Lclot(2) = indexclot(i/2).clot.S0.L + indexclot(i/2).clot.SM.L;
            
            lclot = indexclot(i/2).clot.S0.L + indexclot(i/2).clot.SM.L + indexclot(i/2).clot.S1.L;         
            L(i) = lclot;
            Lsofar(i) = Lsofar(i-1) + L(i);
    end

end

%% Coordinata curvilinea s

% questa parte, dentro il for, l'avevo messa in una funzione che restituiva
% la posizione relativa alla la coordinata curvilinea assegnata. Con un'altra 
% funzione andavo a generare s in funzione del tempo andando cosi` a regolarmi 
% sulle velocita`. x_rif e y_rif cambiano dimensioni nell'iterazione ma,
% mettendolo poi in futuro dentro una funzione non si ha questo problema

x_rif = [];
y_rif = [];
s_rif = [];

% voglio almeno tot_frames di punti.
tot_frames = 3000;
s_incremento = Lsofar(end)/tot_frames;

for s = 0:s_incremento:Lsofar(end)
	% Parte per capire in che tratto sono
	if s<Lsofar(1)
		ntratto = 1;
	else
		for ii=2:(n_p-1)
			if s >= Lsofar(ii-1) && s<=Lsofar(ii)
				ntratto=ii;
			end
		end
	end

	% calcolo delle coordinate x e y riferite a s e a ntratto
	if mod(ntratto,2)==1            %tratti dispari
		if ntratto==1
			XYS=[xp(ntratto) + cos(theta_rette(ntratto))*(s), yp(ntratto)+sin(theta_rette(ntratto))*(s)]';
		else
			srel = s - Lsofar(ntratto-1); %coordinata curvilinea nel tratto in cui mi trovo
			XYS=[xp(ntratto) + cos(theta_rette(ntratto))*(srel), yp(ntratto)+sin(theta_rette(ntratto))*(srel)]';
		end 

	elseif mod(ntratto,2)==0
		srel = s - Lsofar(ntratto-1);
		if srel<=Lsofarclot(ntratto/2).Lclot(1)
			XYS = double(pointsOnClothoid( indexclot(ntratto/2).clot.S0, srel ));       
		elseif srel>Lsofarclot(ntratto/2).Lclot(1) && srel<=Lsofarclot(ntratto/2).Lclot(2)
			XYS = double(pointsOnClothoid( indexclot(ntratto/2).clot.SM, srel- indexclot(ntratto/2).clot.S0.L ));
		elseif srel>Lsofarclot(ntratto/2).Lclot(2)
			XYS = double(pointsOnClothoid( indexclot(ntratto/2).clot.S1, srel- indexclot(ntratto/2).clot.S0.L - indexclot(ntratto/2).clot.SM.L ));
		end
	end
	
	x_rif = [x_rif; XYS(1)];
	y_rif = [y_rif; XYS(2)];
	s_rif = [s_rif; s];
end	

% xys_rif = [x_rif, y_rif, s_rif];


%% Plot
% hold on
% plot(xp, yp,'ko');
% plot(x_rif, y_rif, 'b','Linewidth', 1 );
% axis([ min(min(x_rif)-3,0) max(x_rif)+3 min(min(y_rif)-3,0) max(y_rif)+3])
% xlabel('x [m]')
% ylabel('y [m]')
% legend('Punti Inseriti', 'Riferimento');
% grid on
% pbaspect([1 1 1])

%% output

out = [x_rif, y_rif] /scale_up;


end