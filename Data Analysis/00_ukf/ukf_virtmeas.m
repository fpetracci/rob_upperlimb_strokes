function [y_virt, S_virt, C] = ukf_virtmeas(x, P, Arm)
 % propagazione_misure genera i sigma points, li propaga attraverso state2meas
 % e da` come output la media, la covarianza dei nuovi sigma points e la 
 % crosscovarianza stato-meas.
 %
 % Input		
 % x			vettore media dello stato nx1
 % P			matrice covarianza dello stato nxn
 % Arm			braccio robotico
 %
 % Output
 % y_virt		vettore media dello misure mx1
 % S_virt		matrice covarianza dello delle misure mxm
 % C			matrice crosscovarianza nxm

%generiamo sigma points dello stato
[sp, wm, wc] = sigmapoint_gen(x, P);

%propaghiamo
[~, y_virt, esse, C] = spstate2meas(sp, x, wm, wc, Arm);

% prendiamo solo componente simmetrica 								
S_virt = (esse + esse')/2;

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function meas = state2meas(q, Arm)
%Prende in ingresso lo stato e genera delle misure virtuali.

meas = fkine_kalman_marker(q, Arm);

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [sp, wm, wc] = sigmapoint_gen(x, P)
% questa funzione genera i sigma point e i loro pesi
	n		= size(x,1);		% Dimensione dello spazio in cui vengono generati
	nsp		= 2*n+1;			% numero di sigma points
	
	% parametri di generazione
	alpha	= 1;
	beta	= 2;
	k		= 0;
	lambda = alpha^2 * (n + k) -n;
	
	% generazione pesi per media
	wm = 1/(2*(n + lambda)) * ones(nsp, 1);
    wm(1) = lambda/(n + lambda);
	
	% generazione pesi per cov
	wc = 1/(2*(n + lambda)) * ones(nsp, 1);
	wc(1) = lambda/(n + lambda) + (1 - alpha^2 + beta);
	
	% generazione sigma points sp
	%calcolo "radice" usando SVD
	[U, SIGMA, ~] = svd((n+lambda)* P);
	dist = U * sqrt(SIGMA);
	
	sp = zeros(n, nsp);
	for i=1:nsp
		if i == 1
			sp(:,i) = x;
		elseif i<=1+n
			sp(:,i) = x+dist(:,i-1);
		elseif i>1+n && i<=nsp
			sp(:,i) = x-dist(:,i-1-n);
		end
	end

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [sp_meas_new, y_virt, S_new, C] = spstate2meas(sp, x, wm, wc, Arm)
% questa funzione propaga i sigma point usando state2meas e calcola media,
% covarianza e crosscovarianza. 
	
	n  = size(x,1);		
	nsp = 2*n + 1;		%numero sigma points
	
	%init sigma points propagati
	n_meas = size(state2meas(x, Arm),1);
	sp_meas_new = zeros(n_meas, nsp);
	
	%applico funzione di misura ai sigma points
	for j = 1:nsp
		sp_meas_new(:,j) = state2meas(sp(:,j), Arm);
	end
	
	% media misure virtuali
	y_virt = zeros(n_meas, 1);
	for j = 1:nsp
		y_virt = y_virt + wm(j)*sp_meas_new(:,j);
	end

	% cov misure virtuali
	S_new = zeros(n_meas, n_meas);  
	for j = 1:nsp
		 S_new = S_new + wc(j)*(sp_meas_new(:,j) - y_virt)*(sp_meas_new(:,j) - y_virt)';
	end
	
	% crosscov stato -misure virt
	C = zeros(n, n_meas);
	for j = 1:nsp
		% calcolo corretto tra misure angolari
		ang = (sp(:,j)-x);				%scarto angolo
		a = atan2(sin(ang),cos(ang));	%atan2 dello scarto
		
		C = C + wc(j)*( a * (sp_meas_new(:,j)- y_virt(:,1))');
	end
	
end