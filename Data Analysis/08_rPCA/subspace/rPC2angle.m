function [angle, dom] = rPC2angle(data_rPCA_all, nsubj, sel_rPC)
%RPC2ANGLE Summary of this function goes here
%   Detailed explanation goes here

%% general parameter (to edit for displaying different rPCs)

t0 = 1;										% initial time of recorded trial
tf = size(data_rPCA_all(1).h.coeff,3);		% final time of recorded trial
njoint = size(data_rPCA_all(1).h.coeff,1);	% number of joint
nrpc = size(data_rPCA_all(1).h.coeff,2);	% total number of used rPCs
nsamples = tf - t0 + 1;						% number of samples

%% PCA of mean postures, used to comparison
 
mean_mat	= [];
mean_mat_h	= [];
mean_mat_s	= [];
mean_mat_la = [];

for i = [1:10,12:20,22:24]
	if i < 6
		mean_mat_h	= cat(2 , mean_mat_h, mean(data_rPCA_all(i).h.mean, 2));
	else
		mean_mat_s	= cat(2 , mean_mat_s, mean(data_rPCA_all(i).s.mean, 2));
		mean_mat_la	= cat(2 , mean_mat_la, mean(data_rPCA_all(i).la.mean, 2));
	end
end

mean_mat = [mean_mat_h, mean_mat_s, mean_mat_la];

% pca
% transpose because for pca rows are observations
% [coeff_h,	~,~,~,	var_expl_h,		~] = pca(mean_mat_h');
% [coeff_s,	~,~,~,	var_expl_s,		~] = pca(mean_mat_s');
% [coeff_la,	~,~,~,	var_expl_la,	~] = pca(mean_mat_la');
[coeff_all,	~, ~, ~, ~, ~] = pca(mean_mat');

% obs: there are more subj for s and la, coeff_all could be affected by it!
% angle_mean_h_all	= subspace(coeff_all(:,1),	coeff_h(:,1))	/pi*180;
% angle_mean_s_all	= subspace(coeff_all(:,1),	coeff_s(:,1))	/pi*180;
% angle_mean_la_all	= subspace(coeff_all(:,1),	coeff_la(:,1))	/pi*180;
% angle_mean_la_s		= subspace(coeff_s(:,1),	coeff_la(:,1))	/pi*180;
% angle_mean_la_h		= subspace(coeff_h(:,1),	coeff_la(:,1))	/pi*180;
% angle_mean_s_h		= subspace(coeff_s(:,1),	coeff_h(:,1))	/pi*180;

% choice of mean posture to compute angle
mean_posture = coeff_all(:,sel_rPC);

%% extrapulation of dynamic rPCs about a subject and a group of tasks

% check subj
if floor(nsubj)-nsubj ~= 0
	error('Ciao Giuseppe!')
elseif nsubj <= 0 || nsubj > 24
	error('this subject does not exist inside the dataset, number must be in [1 24]')
end
% single subject loading

if nsubj > 5 % strokes subject
	rPC_coeff_s	= [];
	rPC_coeff_la	= [];

	for i = t0 : tf
		[coeff_rPCs, ~, ~, dom] = rPC_t_subj(i, data_rPCA_all, nsubj, sel_rPC);

		rPC_coeff_s		= cat(2, rPC_coeff_s, coeff_rPCs(:, 1));
		rPC_coeff_la	= cat(2, rPC_coeff_la, coeff_rPCs(:,2));
	end

else % healthy subject
	rPC_coeff_h			= [];

	for i = t0 : tf
		[coeff_rPCs, ~, ~, dom] = rPC_t_subj(i, data_rPCA_all, nsubj, sel_rPC);

		rPC_coeff_h	= cat(2, rPC_coeff_h, coeff_rPCs(:, 1));
	end
end
%% confronto rPCs statiche con rPCs dinamiche
if nsubj > 5 % strokes subject
	
	angle_s = [];
	angle_la = [];
	
	for i = t0 : tf
		angle_s		= cat(2, angle_s,	subspace(mean_posture, rPC_coeff_s(:,i))	/pi*180);
		angle_la	= cat(2, angle_la,	subspace(mean_posture, rPC_coeff_la(:,i))	/pi*180);
	end
		angle = [angle_s; angle_la];
else % healthy subject
	
	angle = [];
	
	for i = t0 : tf
		angle		= cat(2, angle,	subspace(mean_posture, rPC_coeff_h(:,i))	/pi*180);
	end
end
end

