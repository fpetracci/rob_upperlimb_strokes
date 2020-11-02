function data = q_fpca(q_trial, nbase, norder, nfpc)
%Q_FPCA computes the first nfpc functional principal components of the
%given angular joints for the chosen trial
%   Detailed explanation goes here
%	NOTE: angular joints are in degrees

%% fpca
q = q_trial; 

n = size(q,1);					% number of samples in the trial
njoints = size(q,2);			% number of joints angle (10 in our case)

frequenza = 1;					% sampling rate
intervallo=[0, n/frequenza];	% time range
t=linspace(intervallo(1),intervallo(2),n);

base = creaBase(intervallo, nbase, norder);
oggettoFD = calcolaCurve(t, q, base);
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
comp = zeros(njoints,nfpc);
for i = 1:nfpc
	comp(:,i) = comp_tmp(:,i);
end

% info
info			= struct;
info.nbase		= nbase;
info.norder		= norder;
info.nfpc		= nfpc;
info.n			= n;
info.njoints	= njoints;

% save to data struct

data = struct;
data.pc		= pc;
data.comp	= comp;
data.var	= var;
data.mean	= mean;
data.info	= info;
end

