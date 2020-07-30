%% Load data
clear;
% desired matrix cointaing the relevant info for:
% j njoints x s nsubj x k nfpcs (cumulative)
load('mat3_h','mat3_h')
load('mat3_la','mat3_la')
load('mat3_s','mat3_s')

%% Stroke subjects sub selection
subj_Ad			=	[7  8  9  11 14 15 19 20 22 23 24];
subj_Ad_FMMA	=	[55 55 38 47 43 37 61 42 60 46 21];
subj_And		=	[6  10 12 13 16 17 18 21];
subj_And_FMMA	=	[54 41 40 49 53 59 37 48];

% A,d = 7, 11, 15, 19, 24	(9b 23b)
% A,nd = 10, 12b, 13b, 14, 16

choice = [7 10 11 12 13 14 15 16 19 24]-5;

mat3_lar	= mat3_la(:,choice,:);
mat3_sr		= mat3_s(:,choice,:);

mat3_lar_m = mean(mat3_lar, 2);
mat3_sr_m = mean(mat3_sr, 2);

% each column contains values for 10j about a certain k value
mat3_lar_mean = reshape(mat3_lar_m, size(mat3_lar_m,1), size(mat3_lar_m,3), 1);
mat3_sr_mean = reshape(mat3_sr_m, size(mat3_sr_m,1), size(mat3_sr_m,3), 1);

% confronti

k = 1;

la	= mat3_lar_mean(:,k);
a	= mat3_sr_mean(:,k);
ranksum(a,la)

%% each joint, la vs a

choice = [7 10 11 12 13 14 15 16 19 24]-5; % selected subgroup inside S
%population
%choice = (6:24)-5; % select all stroke subject

k_used = 1;
njoints = 10;

mat3_lar	= mat3_la(:,choice,k_used);
mat3_ar		= mat3_s(:,choice,k_used);
mat3_h		= mat3_h(:,:,k_used);

%init
pala = zeros(njoints,1);
phla = zeros(njoints,1);
pha  = zeros(njoints,1);

for j = 1:njoints
	% selection
	a_tmp	= mat3_ar(j,:);
	la_tmp	= mat3_lar(j,:);
	h_tmp	= mat3_h(j,:);
	
	% ranksum
	p_tmp = ranksum(a_tmp, la_tmp);
	pala(j) = p_tmp
	
	p_tmp = ranksum(h_tmp, la_tmp);
	phla(j) = p_tmp
	
	p_tmp = ranksum(h_tmp, a_tmp);
	pha(j) = p_tmp
	
	
end

