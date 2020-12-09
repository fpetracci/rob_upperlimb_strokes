function [mean_posture] = mean_post(ngroup, flag_mp)
%MEAN_POST computes the mean posture of rPCs.
% Input:
%		ngroup		tasks' group number (1,2,3,'all')
%		flag_mp		1	PCA of the time means of dataset mean
%					2	PCA of the time means of each rPCs
%					3	PCA of the time median of each rPCs
%					4	mean of the rPCs in the first time instant
%					0	PCA of the rPCs in the first time instant

	if nargin < 2
		flag_mp = 0;
	end
	
	%% Load
if 0
	% if exist('mean_postPCA_1group.mat') == 2 && sum(ngroup == 1) == 1 && flag_mean == 0
% 	load('mean_postPCA_1group.mat');
% elseif exist('mean_postPCA_2group.mat') == 2 && sum(ngroup == 2) == 1 && flag_mean == 0
% 	load('mean_postPCA_2group.mat');
% elseif exist('mean_postPCA_3group.mat') == 2 && sum(ngroup == 3) == 1 && flag_mean == 0
% 	load('mean_postPCA_3group.mat');
% elseif exist('mean_postPCA_all_group.mat') == 2 && sum(ngroup == 'all') == 3 && flag_mean == 0
% 	load('mean_postPCA_all_group.mat');
else
	%% compute PCA of mean or first postures, to be used to comparison
	struct_rPCA = rpca_all_subj(ngroup);
	% creating empty matrices to fill up later
	mean_mat_h	= [];
	mean_mat_s	= [];
	mean_mat_la = [];
	mean_posture = zeros(10,1);
	
	if flag_mp == 1
		%PCA of the time means of dataset mean
		
		% not all subjects have enough trials, we remove some of them
		for i = [1:10,12:20,22:24]
			if i < 6
				mean_mat_h	= cat(2 , mean_mat_h, mean(struct_rPCA(i).h.mean, 2)); 
			else
				mean_mat_s	= cat(2 , mean_mat_s, mean(struct_rPCA(i).s.mean, 2));
				mean_mat_la	= cat(2 , mean_mat_la, mean(struct_rPCA(i).la.mean, 2));
			end
		end
		
		% stacking the means together
		data_mat = [mean_mat_h, mean_mat_s, mean_mat_la];
		
		% PC of means
		[mean_posture,	~, ~, ~, ~, ~] = pca(data_mat');
		
	elseif flag_mp == 2
		
		%2	PCA of the time means of each rPCs
		for j = 1:10 % num rPCs
			for i = [1:10,12:20,22:24]
				if i < 6 
					% healthy subj
					tmp = struct_rPCA(i).h.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1);
					rPC_mean_mat_h	= cat(2 , rPC_mean_mat_h, mean(tmp, 2)); 
					
				else
					% stroke subj
					tmp = struct_rPCA(i).s.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); 
					rPC_mean_mat_s	= cat(2 , rPC_mean_mat_s, mean(tmp, 2));
					
					tmp = struct_rPCA(i).la.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1);
					rPC_mean_mat_la	= cat(2 , rPC_mean_mat_la, mean(tmp, 2));
				end
			end
			
			% stacking the mean of rPCs together
			data_mat = [rPC_mean_mat_h, rPC_mean_mat_s, rPC_mean_mat_la];

			% PC
			[mean_post,	~, ~, ~, ~, ~] = pca(data_mat');
			mean_posture(:, j) = mean_post(:, 1);
		end

	elseif flag_mp == 3
		%PCA of the time median of each rPCs
		
		for j = 1:10 % num rPCs
			for i = [1:10,12:20,22:24]
				if i < 6 %subj
					tmp = struct_rPCA(i).h.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1); 
					rPC_med_mat_h	= cat(2 , rPC_med_mat_h, median(tmp, 2)); 
				else
					tmp = struct_rPCA(i).s.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1);
					rPC_med_mat_s	= cat(2 , rPC_med_mat_s, median(tmp, 2));
					
					tmp = struct_rPCA(i).la.coeff(:, j, :);
					tmp = reshape(tmp, 10, 240, 1);
					rPC_med_mat_la	= cat(2 , rPC_med_mat_la, median(tmp, 2));
				end
			end
			
			% stacking the median of rPCs together
			data_mat = [rPC_med_mat_h, rPC_med_mat_s, rPC_med_mat_la];

			% PC
			[mean_post,	~, ~, ~, ~, ~] = pca(data_mat');
			mean_posture(:, j) = mean_post(:, 1);
			
		end
		
	elseif flag_mp == 0
		
		% PCA of the rPCs in the first time instant
		for j = 1:10 % num rPCs
			for i = [1:10,12:20,22:24]
				if i < 6 %subj
					tmp = struct_rPCA(i).h.coeff(:, j, 1);
					%tmp = reshape(tmp, 10, 1, 1);
					mean_mat_h	= cat(2 , mean_mat_h, tmp); 

					
					%+ struct_rPCA(i).h.mean
				else
					tmp = struct_rPCA(i).s.coeff(:, j, 1);
					%tmp = reshape(tmp, 10, 1, 1);
					mean_mat_s	= cat(2 , mean_mat_s, tmp);
					
					tmp = struct_rPCA(i).la.coeff(:, j, 1);
					%tmp = reshape(tmp, 10, 1, 1);
					mean_mat_la	= cat(2 , mean_mat_la, tmp);
				end
			end
			
			data_mat = [mean_mat_h, mean_mat_s, mean_mat_la];
 
			% PC
			[mean_post,	~, ~, ~, ~, ~] = pca(data_mat');
			mean_posture(:, j) = mean_post(:, 1);
		end
		
		
		
	elseif flag_mp == 4
		
		% mean of the rPCs in the first time instant
		for j = 1:10 % num rPCs
			for i = [1:10,12:20,22:24]
				if i < 6 %subj
					tmp = struct_rPCA(i).h.coeff(:, j, 1);
					%tmp = reshape(tmp, 10, 1, 1);
					mean_mat_h	= cat(2 , mean_mat_h, tmp); 
					
				else
					tmp = struct_rPCA(i).s.coeff(:, j, 1);
					%tmp = reshape(tmp, 10, 1, 1);
					mean_mat_s	= cat(2 , mean_mat_s, tmp);
					
					tmp = struct_rPCA(i).la.coeff(:, j, 1);
					%tmp = reshape(tmp, 10, 1, 1);
					mean_mat_la	= cat(2 , mean_mat_la, tmp);
				end
			end
			
			data_mat = [mean_mat_h, mean_mat_s, mean_mat_la];
			% mean
			mean_posture(:, j) = mean(data_mat,2);
		end
		
	else
		error('no valid flag input value');
	end
end

