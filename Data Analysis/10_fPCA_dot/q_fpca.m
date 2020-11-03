function data = q_fpca(q_chosen_dataset, nbase, norder, nfpc)
%Q_FPCA computes the first nfpc functional principal components of the
%given angular joint for the chosen observations
%	NOTE: angular joints are in degrees

%% fpca

% removing the mean
[nobs, n] = size(q_chosen_dataset);

for i = 1:nobs
	%q_chosen_dataset(i,:) = q_chosen_dataset(i,:) - mean(q_chosen_dataset(i,:));
	q_chosen_dataset(i,:) = q_chosen_dataset(i,:) - sum(q_chosen_dataset(i,:))/n;
end
	
q_matrix = q_chosen_dataset; 


% trasposing
q_matrix = q_matrix';
n = size(q_matrix,1);				% number of samples in the trial
nobs = size(q_matrix,2);			% number of observations

frequenza = 1;					% sampling rate
intervallo=[0, n/frequenza];	% time range
t=linspace(intervallo(1),intervallo(2),n);

base = creaBase(intervallo, nbase, norder);
oggettoFD = calcolaCurve(t, q_matrix, base);
%oggettoFD_medio = calcolaMediaCurve(oggettoFD);
lista_pca_nr = calcolaFPCA(oggettoFD,nfpc);

FD			= lista_pca_nr.fd;
comp_tmp	= lista_pca_nr.componenti;
mean		= lista_pca_nr.media;
var			= lista_pca_nr.perc_varianza;

% principal component
pc = zeros(n,nfpc);
for i = 1:nfpc
	pc(:,i) = FD.fPCA{i};
end

% scores
comp = zeros(nobs,nfpc);
for i = 1:nfpc
	comp(:,i) = comp_tmp(:,i);
end

% info
info			= struct;
info.nbase		= nbase;
info.norder		= norder;
info.nfpc		= nfpc;
info.n			= n;
info.nobs		= nobs;

% save to data struct
data = struct;
data.val_pc	= pc;
data.comp	= comp;
data.var	= var;
data.mean	= mean;
data.info	= info;
end

