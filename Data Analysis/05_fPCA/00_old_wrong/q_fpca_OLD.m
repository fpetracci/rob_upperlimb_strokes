function data = q_fpca(q_chosen_dataset, nbase, norder, nfpc)
%Q_FPCA computes the first nfpc functional principal components of the
%given angular joints for the chosen trial
%   Detailed explanation goes here
%	NOTE: angular joints are in degrees

%% fpca
q_matrix = q_chosen_dataset; 

nobs	 = size(q_matrix,1);		% number of observations
nsamples = size(q_matrix,2);		% number of time samples in the trial

frequenza	= 1;					% sampling rate
intervallo	= [0, nsamples/frequenza];	% time range
t			= linspace(intervallo(1), intervallo(2), nsamples);

base = creaBase(intervallo, nbase, norder);
oggettoFD = calcolaCurve(t, q_matrix, base);
%oggettoFD_medio = calcolaMediaCurve(oggettoFD);
lista_pca_nr = calcolaFPCA(oggettoFD, nfpc);

FD			= lista_pca_nr.fd;
comp_tmp	= lista_pca_nr.componenti;
mean		= lista_pca_nr.media;
var			= lista_pca_nr.perc_varianza;

% principal component
pc = zeros(nobs,nfpc);
for i = 1:nfpc
	pc(:,i) = FD.fPCA{i};
end

% scores
comp = zeros(nsamples,nfpc);
for i = 1:nfpc
	comp(:,i) = comp_tmp(:,i);
end

% info
info			= struct;
info.nbase		= nbase;
info.norder		= norder;
info.nfpc		= nfpc;
info.nobs		= nobs;
info.njoints	= nsamples;

% save to data struct

data = struct;
data.pc		= pc;
data.comp	= comp;
data.var	= var;
data.mean	= mean;
data.info	= info;
end

