%MEAN_POST computes the mean posture of rPCs.
% Input:
%		ngroup		tasks' group number (1,2,3,'all')
%		flag_mean	1 for PCA of the means, 2 for
%					doing PCA of the median, 0 for the 
%					rPCA about first time value					

	% if flag_mean = 0 mean posture is computed as the first posture of each
	% subject
	% if flag_mean = 1 mean posture is computed as PCA of mean postures of each
	% subject
	% if flag_mean = 2 mean posture is computed as PCA of median postures of each
	% subject
	
	if nargin < 2
		flag_mean = 0;
	end
%% Load
if exist('mean_postPCA_1group.mat') == 2 && sum(ngroup == 1) == 1 && flag_mean == 0
	load('mean_postPCA_1group.mat');
elseif exist('mean_postPCA_2group.mat') == 2 && sum(ngroup == 2) == 1 && flag_mean == 0
	load('mean_postPCA_2group.mat');
elseif exist('mean_postPCA_3group.mat') == 2 && sum(ngroup == 3) == 1 && flag_mean == 0
	load('mean_postPCA_3group.mat');
elseif exist('mean_postPCA_all_group.mat') == 2 && sum(ngroup == 'all') == 3 && flag_mean == 0
	load('mean_postPCA_all_group.mat');
else
	%% compute PCA of mean postures, used to comparison
	struct_rPCA = rpca_all_subj(ngroup);
	% creating empty matrices to fill up later
	
	mean_mat_h	= [];
	mean_mat_s	= [];
	mean_mat_la = [];
	
	if flag_data == 1
	% fai mean prima nel tempo per singolo soggetto, poi impili in gruppi di
	% soggetti e poi fai la PCA tra i mean postures dei gruppi, svincoli dal
	% tempo
		for i = [1:10,12:20,22:24]
			if i < 6
				mean_mat_h	= cat(2 , mean_mat_h, mean(struct_rPCA(i).h.mean, 2)); 
			else
				mean_mat_s	= cat(2 , mean_mat_s, mean(struct_rPCA(i).s.mean, 2));
				mean_mat_la	= cat(2 , mean_mat_la, mean(struct_rPCA(i).la.mean, 2));
			end
		end
		% qua fai tutti i soggetti insieme per avere un'unica PCA di riferimento
		% finale
		data_mat = [mean_mat_h, mean_mat_s, mean_mat_la];
% 		for i = [1:10,12:20,22:24]
% 			if i < 6
%				for j = 1:10
%				tmp = struct_rPCA(i).h.coeff(:, 1, :);
%				tmp = reshape(tmp, 1, 3, 2); % non ricordo come si faccia
% 				mean_mat_h	= cat(2 , mean_mat_h, mean(tmp, 2)); 
% 			else
%				tmp = struct_rPCA(i).s.coeff(:, 1, :);
%				tmp = reshape(tmp, 1, 3, 2); % non ricordo come si faccia
% 				mean_mat_s	= cat(2 , mean_mat_s, tmp, 2));
%				tmp = struct_rPCA(i).la.coeff(:, 1, :);
%				tmp = reshape(tmp, 1, 3, 2); % non ricordo come si faccia
% 				mean_mat_la	= cat(2 , mean_mat_la, tmp, 2));
% 			end
% 		end
	elseif flag_mean == 2
	% fai median prima nel tempo per singolo soggetto, poi impili in gruppi di
	% soggetti e poi fai la PCA tra i median postures dei gruppi, svincoli dal
	% tempo
		for i = [1:10,12:20,22:24]
			if i < 6
				mean_mat_h	= cat(2 , mean_mat_h, median(struct_rPCA(i).h.mean, 2)); 
			else
				mean_mat_s	= cat(2 , mean_mat_s, median(struct_rPCA(i).s.mean, 2));
				mean_mat_la	= cat(2 , mean_mat_la, median(struct_rPCA(i).la.mean, 2));
			end
		end
		% qua fai tutti i soggetti insieme per avere un'unica PCA di riferimento
		% finale
		data_mat = [mean_mat_h, mean_mat_s, mean_mat_la];
	
	elseif flag_mean == 0
	% prendi il primo valore nel tempo per singolo soggetto, poi impili in gruppi di
	% soggetti e poi fai la PCA
		for i = [1:10,12:20,22:24]
			if i < 6
				mean_mat_h	= cat(2 , mean_mat_h, struct_rPCA(i).h.mean(:, 1)); 
				
			else
				mean_mat_s	= cat(2 , mean_mat_s, struct_rPCA(i).s.mean(:, 1));
				mean_mat_la	= cat(2 , mean_mat_la, struct_rPCA(i).la.mean(:, 1));
			end
		end
		% qua fai tutti i soggetti insieme per avere un'unica PCA di riferimento
		% finale
		data_mat = [mean_mat_h, mean_mat_s, mean_mat_la];
	else
		error('no valid flag input value');
	end
		
	% PC of means/median/first istant values
	[mean_posture,	~, ~, ~, ~, ~] = pca(data_mat');
% mean of means/median
% 		mean_tmp = mean(mean_mat, 2);
% 		mean_posture = [];
% 		for i = 1:10
% 			mean_posture = cat(2, mean_posture, mean_tmp);
% 		end
end