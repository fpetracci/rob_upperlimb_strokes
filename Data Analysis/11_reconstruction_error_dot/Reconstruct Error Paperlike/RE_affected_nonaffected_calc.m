function RE_affected_nonaffected_calc(ngroup)
%computes reconstruction error of firsts fPCs of stroke subjects about 
 %affected and less affected side (3R, 7R, 10R).
 
if exist('loader_subj_mat_1group_dot.mat') == 2 && sum(ngroup == 1) == 1 
	load('loader_subj_mat_1group_dot.mat');
elseif exist('loader_subj_mat_2group_dot.mat') == 2 && sum(ngroup == 2) == 1
	load('loader_subj_mat_2group_dot.mat');
elseif exist('loader_subj_mat_3group_dot.mat') == 2 && sum(ngroup == 3) == 1
	load('loader_subj_mat_3group_dot.mat');
elseif exist('loader_subj_mat_allgroup_dot.mat') == 2 && sum(ngroup == 'all') == 3 
	load('loader_subj_mat_allgroup_dot.mat');
end
load('q_task_warped_dot.mat');
q_task_warp = q_task_warp_dot;
fPCA_subj = fPCA_subj_dot;
q_stacked_subj = q_stacked_subj_dot;
%% index calculation

tic

[njoints, nsamples] = size(q_task_warp(1).subject(1).trial(1).q_grad);% number of joints and time length of each signal
nfpc		= 10;	% number of fpcs used
subj_num	= 19;	% number of stroke subjects

%init for efficiency
q_recon_s = zeros(nsamples, njoints);	% reconstruct stroke signal
q_recon_la = q_recon_s;					% reconstruct less affected signal

ID = zeros(subj_num,1);		% vector cointaining dissimilarity index for each stroke subject

E = zeros(nfpc,1);			%  
E_s = E;					%
E_la = E;					% 
E_subj = zeros(subj_num, nfpc, 2);
 %[9 15 16 18]
for nsubj = 6:24 %[9 15 16 18]%15 %6:24
	disp(['Elaborating subj num ' num2str(nsubj)]);
	
	% stroke side
	for k = 1:nfpc % number of used fPCs
		nobs_tmp = size(q_stacked_subj(nsubj).q_matrix_s,1); %number of observation give subject
		err_k = zeros(nobs_tmp,1); % error with k fPCs in time
		for  i = 1:nobs_tmp
			% select the real signal
			q_s = q_stacked_subj(nsubj).q_matrix_s(i,:,:);
			q_s = reshape(q_s, size(q_s,2), size(q_s,3));
			
			% reconstruct with k number of fPCs the selected signal
			for j = 1:njoints
				q_recon_mat = fpca2q(fPCA_subj(nsubj).s_joint(j));
				q_1dof = q_recon_mat(:,i,k+1); % 1joint in time
				q_recon_s(:,j) = q_1dof; 
			end
			q_recon_s = q_recon_s + mean(q_s, 1);

			%rms
			%err_k(i) = min(rms(q_s - q_recon_s, 2) );
			err_k(i) = norm(rms(q_s - q_recon_s,1) );

		end
		
		E_s(k) = mean(err_k);
	end
	
	% less affected side
	for k = 1:nfpc % number of used fPCs
		nobs_tmp = size(q_stacked_subj(nsubj).q_matrix_la,1); %number of observation give subject
		err_k = zeros(nobs_tmp,1); % error with k fPCs in time
		for  i = 1:nobs_tmp
			% select the real signal
			q_la = q_stacked_subj(nsubj).q_matrix_la(i,:,:);
			q_la = reshape(q_la, size(q_la,2), size(q_la,3));
			
			% reconstruct with k number of fPCs the selected signal
			for j = 1:njoints
				q_recon_mat = fpca2q(fPCA_subj(nsubj).la_joint(j));
				q_1dof = q_recon_mat(:,i,k+1); % 1joint in time
				q_recon_la(:,j) = q_1dof; 
			end
			q_recon_la = q_recon_la + mean(q_la, 1);

			%rms
% 			err_k(i) = min(rms(q_la - q_recon_la, 2) );
			err_k(i) = norm(rms(q_la - q_recon_la,1) );
		end
		
		E_la(k) = mean(err_k);
	end
	
	ID(nsubj-5) = sum(E_la - E_s);
	E_subj(nsubj-5, :, 1) = E_la;
	E_subj(nsubj-5, :, 2) = E_s;
end
	
toc

E_subj10 = E_subj;
save('E10_dot', 'E_subj10');

%% index calculation ONLY 7R

tic

nsamples = size(q_task_warp(1).subject(1).trial(1).q_grad,2);% number of joints and time length of each signal
njoints		= 7;	% number of joints
nfpc		= 10;	% number of fpcs used
subj_num	= 19;	% number of stroke subjects

%init for efficiency
q_recon_s = zeros(nsamples, njoints);	% reconstruct stroke signal
q_recon_la = q_recon_s;					% reconstruct less affected signal

ID = zeros(subj_num,1);		% vector cointaining dissimilarity index for each stroke subject

E = zeros(nfpc,1);			%  
E_s = E;					%
E_la = E;					% 
E_subj = zeros(subj_num, nfpc, 2);

for nsubj = 6:24 %[9 15 16 18]%6:24
	disp(['Elaborating subj num ' num2str(nsubj)]);
	
	% stroke side
	for k = 1:nfpc % number of used fPCs
		nobs_tmp = size(q_stacked_subj(nsubj).q_matrix_s,1); %number of observation give subject
		err_k = zeros(nobs_tmp,1); % error with k fPCs in time
		for  i = 1:nobs_tmp
			% select the real signal
			q_s = q_stacked_subj(nsubj).q_matrix_s(i,:,:);
			q_s = reshape(q_s, size(q_s,2), size(q_s,3));
			q_s = q_s(:,4:10);
			
			% reconstruct with k number of fPCs the selected signal
			for j = 1:njoints
				jj = j+3;
				q_recon_mat = fpca2q(fPCA_subj(nsubj).s_joint(jj));
				q_1dof = q_recon_mat(:,i,k+1); % 1joint in time
				q_recon_s(:,j) = q_1dof; 
			end
			q_recon_s = q_recon_s + mean(q_s, 1);

			%rms
% 			err_rms = rms(q_s - q_recon_s, 2);
% 			err_k(i) = min(err_rms);
			err_k(i) = norm(rms(q_s - q_recon_s,1) );
		end
		
		E_s(k) = mean(err_k);
	end
	
	% less affected side
	for k = 1:nfpc % number of used fPCs
		nobs_tmp = size(q_stacked_subj(nsubj).q_matrix_la,1); %number of observation give subject
		err_k = zeros(nobs_tmp,1); % error with k fPCs in time
		for  i = 1:nobs_tmp
			% select the real signal
			q_la = q_stacked_subj(nsubj).q_matrix_la(i,:,:);
			q_la = reshape(q_la, size(q_la,2), size(q_la,3));
			q_la = q_la(:,4:10);
			
			% reconstruct with k number of fPCs the selected signal
			for j = 1:njoints
				jj = j+3;
				q_recon_mat = fpca2q(fPCA_subj(nsubj).la_joint(jj));
				q_1dof = q_recon_mat(:,i,k+1); % 1joint in time
				q_recon_la(:,j) = q_1dof; 
			end
			q_recon_la = q_recon_la + mean(q_la,1);

			%rms
% 			err_rms = rms(q_la - q_recon_la, 2);
% 			err_k(i) = min(err_rms);
			err_k(i) = norm(rms(q_la - q_recon_la,1) );
		end
		
		E_la(k) = mean(err_k);
	end
	
	ID(nsubj-5) = sum(E_la - E_s);
	E_subj(nsubj-5, :, 1) = E_la;
	E_subj(nsubj-5, :, 2) = E_s;
end
	
toc
E_subj7 = E_subj;
save('E7_dot', 'E_subj7');

%% index calculation ONLY 3R

tic

nsamples = size(q_task_warp(1).subject(1).trial(1).q_grad,2);% number of joints and time length of each signal
njoints		= 3;	% number of joints
nfpc		= 10;	% number of fpcs used
subj_num	= 19;	% number of stroke subjects

%init for efficiency
q_recon_s = zeros(nsamples, njoints);	% reconstruct stroke signal
q_recon_la = q_recon_s;					% reconstruct less affected signal

ID = zeros(subj_num,1);		% vector cointaining dissimilarity index for each stroke subject

E = zeros(nfpc,1);			%  
E_s = E;					%
E_la = E;					% 
E_subj = zeros(subj_num, nfpc, 2);

for nsubj = 6:24 %[9 15 16 18]%6:24
	disp(['Elaborating subj num ' num2str(nsubj)]);
	
	% stroke side
	for k = 1:nfpc % number of used fPCs
		nobs_tmp = size(q_stacked_subj(nsubj).q_matrix_s,1); %number of observation give subject
		err_k = zeros(nobs_tmp,1); % error with k fPCs in time
		for  i = 1:nobs_tmp
			% select the real signal
			q_s = q_stacked_subj(nsubj).q_matrix_s(i,:,:);
			q_s = reshape(q_s, size(q_s,2), size(q_s,3));
			q_s = q_s(:,1:3);
			
			% reconstruct with k number of fPCs the selected signal
			for j = 1:njoints
				q_recon_mat = fpca2q(fPCA_subj(nsubj).s_joint(j));
				q_1dof = q_recon_mat(:,i,k+1); % 1joint in time
				q_recon_s(:,j) = q_1dof; 
			end
			q_recon_s = q_recon_s + mean(q_s, 1);

			%rms
% 			err_rms = rms(q_s - q_recon_s, 2);
% 			err_k(i) = min(err_rms);
			err_k(i) = norm(rms(q_s - q_recon_s,1) );
		end
		
		E_s(k) = mean(err_k);
	end
	
	% less affected side
	for k = 1:nfpc % number of used fPCs
		nobs_tmp = size(q_stacked_subj(nsubj).q_matrix_la,1); %number of observation give subject
		err_k = zeros(nobs_tmp,1); % error with k fPCs in time
		for  i = 1:nobs_tmp
			% select the real signal
			q_la = q_stacked_subj(nsubj).q_matrix_la(i,:,:);
			q_la = reshape(q_la, size(q_la,2), size(q_la,3));
			q_la = q_la(:,1:3);
			
			% reconstruct with k number of fPCs the selected signal
			for j = 1:njoints
				q_recon_mat = fpca2q(fPCA_subj(nsubj).la_joint(j));
				q_1dof = q_recon_mat(:,i,k+1); % 1joint in time
				q_recon_la(:,j) = q_1dof; 
			end
			q_recon_la = q_recon_la + mean(q_la,1);

			%rms
% 			err_rms = rms(q_la - q_recon_la, 2);
% 			err_k(i) = min(err_rms);
			err_k(i) = norm(rms(q_la - q_recon_la,1) );
		end
		
		E_la(k) = mean(err_k);
	end
	
	ID(nsubj-5) = sum(E_la - E_s);
	E_subj(nsubj-5, :, 1) = E_la;
	E_subj(nsubj-5, :, 2) = E_s;
end

E_subj3 = E_subj;
save('E3_dot', 'E_subj3');
	
toc
end