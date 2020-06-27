function [x_new, P_new] = ukf_predict(x_old, P_old)
 % PROPAGATE genera 2n+1 sigma points, li propaga attraverso
 % state_update e da` come output la media e la covarianza dei nuovi sigma
 % points. 
 %
 % Input		
 % x_old			vettore media dello stato nx1
 % P_old			matrice covarianza dello stato nxn
 %
 % Output
 % x_new		vettore media dello stato nx1
 % P_new		matrice covarianza dello stato nxn

 %generiamo sigma points e pesi
[sp, wm, wc] = sigmapoint_gen(x_old, P_old);

%propaghiamo attraverso la funzione di aggiornamento dello stato
[x_new, P] = sigmapoint_propagate(sp, wm, wc);

% si prende componente simmetrica
P_new = (P + P')/2;

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function x_new = state_update(x_old)
%Funzione di aggiornamento dello stato.

x_new = x_old;

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [sp, wm, wc] = sigmapoint_gen(x_old, P_old)
% questa funzione genera i sigma point e i loro pesi

	n		= size(x_old,1);	% Dimensione dello spazio in cui vengono generati
	nsp		= 2*n+1;			% numero di sigma points
	P       = P_old;			% matrice di covarianza
	
	%parametri per distribuzioni simmetriche
	alpha	= 1;
	beta	= 2;
	k		= 0;
    
	lambda = alpha^2 * (n + k) -n;
	
	% generazione pesi primo ordine per media
	wm = 1/(2*(n + lambda)) * ones(nsp, 1);
    wm(1) = lambda/(n + lambda);
	
	% generazione pesi secondo ordine per cov
	wc = 1/(2*(n + lambda)) * ones(nsp, 1);
	wc(1) = lambda/(n + lambda) + (1 - alpha^2 + beta);
	
	% generazione sigma points sp
	dist	= zeros(n,n);
	sp		= zeros(n, nsp);
	
	%calcolo "radice" di (n+lambda)*P
	[U, SIGMA, ~] = svd((n+lambda)* P);
	dist = U * sqrt(SIGMA);

	for i=1:nsp
		if i == 1
			sp(:,i) = x_old;
		elseif i <= 1+n
			sp(:,i) = x_old + dist(:,i-1);
		elseif i > 1+n && i<=nsp
			sp(:,i) = x_old - dist(:,i-1-n);
		end
	end

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [x_new, P_new] = sigmapoint_propagate(sp, wm, wc)
% questa funzione propaga i sigma point usando state_update
	
	n = size(sp(:,1),1);
	nsp = n*2 + 1;		%numero sigma points
	
	%inizializzazione sigma points propagati
	sp_new = zeros(n, nsp);	
	
	%propagazione
	for j = 1:nsp
		 sp_new(:,j) = state_update(sp(:,j));
	end

	%calcolo media
	mean_c = zeros(n, 1);	%media coseno
	mean_s = zeros(n, 1);	%media seno
	for j = 1:nsp
		c = cos(sp_new(:,j));
		s = sin(sp_new(:,j));

		mean_c = mean_c + wm(j)*c;
		mean_s = mean_s + wm(j)*s;
	end
	
	x_new = atan2(mean_s, mean_c); %atan2 delle medie

	% cov
	cc = zeros(n,n);		%covarianza coseno
	cs = zeros(n,n);		%covarianza seno
	for j = 1:nsp
		c = cos(sp_new(:,j) - x_new);
		s = sin(sp_new(:,j) - x_new);

		cc = cc + wc(j)*(c*c');
		cs = cs + wc(j)*(s*s');
	end
	P_new = atan2(cs,cc); %covarianza bearing con atan2 delle covarianze


	
end

