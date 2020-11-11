function [mean_posture] = mean_post(ngroup, flag_mp)
%MEAN_POST computes the mean posture of rPCs.
% Input:
%		ngroup		tasks' group number (1,2,3,'all')
%		flag_mp		1	PCA of the time means of dataset mean
%					2	PCA of the time means of each rPCs
%					3	PCA of the time median of each rPCs
%					4	PCA of PCA of rPCs???
%					0	PCA of the rPCs in the first time instant

	% if flag_mean = 0 mean posture is computed as the first posture of each
	% subject
	% if flag_mean = 1 mean posture is computed as PCA of mean postures of each
	% subject
	% if flag_mean = 2 mean posture is computed as PCA of median postures of each
	% subject
	
	if nargin < 2
		flag_mp = 0;
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
	%% compute PCA of mean or first postures, to be used to comparison
	struct_rPCA = rpca_all_subj(ngroup);
	% creating empty matrices to fill up later
	mean_mat_h	= [];
	mean_mat_s	= [];
	mean_mat_la = [];
	mean_posture = zeros(10,1);
	
	if flag_mp == 1
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
		
		% PC of means/median/first istant values
		[mean_posture,	~, ~, ~, ~, ~] = pca(data_mat');
		
	elseif flag_mp == 2
		for j = 1:10 % num rPCs
			for i = [1:10,12:20,22:24]
				if i < 6 %subj
					tmp = struct_rPCA(i).h.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); % non ricordo come si faccia
					mean_mat_h	= cat(2 , mean_mat_h, mean(tmp, 2)); 
				else
					tmp = struct_rPCA(i).s.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); % non ricordo come si faccia
					mean_mat_s	= cat(2 , mean_mat_s, mean(tmp, 2));
					tmp = struct_rPCA(i).la.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); % non ricordo come si faccia
					mean_mat_la	= cat(2 , mean_mat_la, mean(tmp, 2));
				end
			end
			
			% qua fai tutti i soggetti insieme per avere un'unica PCA di riferimento
			% finale
			data_mat = [mean_mat_h, mean_mat_s, mean_mat_la];

			% PC of means/median/first istant values
			[mean_post,	~, ~, ~, ~, ~] = pca(data_mat');
			mean_posture(:, j) = mean_post(:, 1);
		end

	elseif flag_mp == 3
		for j = 1:10 % num rPCs
			for i = [1:10,12:20,22:24]
				if i < 6 %subj
					tmp = struct_rPCA(i).h.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); % non ricordo come si faccia
					mean_mat_h	= cat(2 , mean_mat_h, median(tmp, 2)); 
				else
					tmp = struct_rPCA(i).s.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); % non ricordo come si faccia
					mean_mat_s	= cat(2 , mean_mat_s, median(tmp, 2));
					tmp = struct_rPCA(i).la.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); % non ricordo come si faccia
					mean_mat_la	= cat(2 , mean_mat_la, median(tmp, 2));
				end
			end
			
			% qua fai tutti i soggetti insieme per avere un'unica PCA di riferimento
			% finale
			data_mat = [mean_mat_h, mean_mat_s, mean_mat_la];

			% PC of means/median/first istant values
			[mean_post,	~, ~, ~, ~, ~] = pca(data_mat');
			mean_posture(:, j) = mean_post(:, 1);
		end
	elseif flag_mp == 0
		for j = 1:10 % num rPCs
			for i = [1:10,12:20,22:24]
				if i < 6 %subj
					tmp = struct_rPCA(i).h.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); % non ricordo come si faccia
					mean_mat_h	= cat(2 , mean_mat_h, tmp); 
				else
					tmp = struct_rPCA(i).s.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); % non ricordo come si faccia
					mean_mat_s	= cat(2 , mean_mat_s, tmp);
					tmp = struct_rPCA(i).la.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); % non ricordo come si faccia
					mean_mat_la	= cat(2 , mean_mat_la, tmp);
				end
			end
			
			% qua fai tutti i soggetti insieme per avere un'unica PCA di riferimento
			% finale
			data_mat = [mean_mat_h, mean_mat_s, mean_mat_la];

			% PC of means/median/first istant values
			[mean_post,	~, ~, ~, ~, ~] = pca(data_mat');
			mean_posture(:, j) = mean_post(:, 1);
		end
	elseif flag_mp == 4
		for j = 1:10 % num rPCs
			for i = [1:10,12:20,22:24]
				if i < 6 %subj
					tmp = struct_rPCA(i).h.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); % non ricordo come si faccia
					[tmp_cff_h, ~, ~, ~, ~, ~] = pca(tmp');
					mean_mat_h	= cat(2 , mean_mat_h, tmp_cff_h); 
				else
					tmp = struct_rPCA(i).s.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); % non ricordo come si faccia
					[tmp_cff_s, ~, ~, ~, ~, ~] = pca(tmp');
					mean_mat_s	= cat(2 , mean_mat_s, tmp_cff_s);
					tmp = struct_rPCA(i).la.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); % non ricordo come si faccia
					[tmp_cff_la, ~, ~, ~, ~, ~] = pca(tmp');
					mean_mat_la	= cat(2 , mean_mat_la, tmp_cff_la);
				end
			end
			
			% qua fai tutti i soggetti insieme per avere un'unica PCA di riferimento
			% finale
			data_mat = [mean_mat_h, mean_mat_s, mean_mat_la];

			% PC of means/median/first istant values
			[mean_post,	~, ~, ~, ~, ~] = pca(data_mat');
			mean_posture(:, j) = mean_post(:, 1);
		end
	else
		error('no valid flag input value');
	end
end

