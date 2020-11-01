% this script calculates the needed reconstruction error matrix and saves 
% it in a .mat file
clear all; clc; close;
load('loader_subj_mat.mat');

%% intro
nsamples	= 240;	% time length of each signal
njoints		= 10;	% number of joints
nfpc		= 10;	% number of fpcs used
h_nsubj		= 5;	% number of healthy subject
s_nsubj		= 19;	% number of stroke subject

% desired matrix cointaing the relevant info for:
% j njoints x s nsubj x k nfpcs (cumulative)
mat3_h = zeros(njoints, h_nsubj, nfpc);
mat3_la = zeros(njoints, s_nsubj, nfpc);
mat3_s = zeros(njoints, s_nsubj, nfpc);
			%
q_recon = zeros(nsamples, njoints);	% reconstruct healthy signal

%% recon calculation HEALHTY

tic


 for s = 1:h_nsubj
	disp(['Elaborating Healthy subj num ' num2str(s)]);
	
	for k = 1:nfpc % number of used fPCs
		nobs_tmp = size(q_stacked_subj(s).q_matrix_h,1); %number of observation give subject
		err_k = zeros(nobs_tmp,njoints); % error with k fPCs in time
		for  i = 1:nobs_tmp
			% select the real signal
			q_tmp = q_stacked_subj(s).q_matrix_h(i,:,:);
			q = reshape(q_tmp, size(q_tmp,2), size(q_tmp,3));
			
			% reconstruct with k number of fPCs the selected signal
			for j = 1:njoints
				q_recon_mat = fpca2q(fPCA_subj(s).h_joint(j));
				q_1dof = q_recon_mat(:,i,k+1); % 1joint in time
				q_recon(:,j) = q_1dof; 
			end
			q_recon = q_recon + mean(q, 1);
			q_error = q - q_recon; 
						
			%rms
			err_k(i, :) = rms(q_error,1);
		end
		% done observations given subject
		mat3_h(:, s, k) = (mean(err_k,1))';	
	end
	% done all of subjects given k

	a = 1;
	
 end
 toc
 save('mat3_h', 'mat3_h');
 %% recon calculation LESSAFFECTED
 tic

 for s = 6:s_nsubj+5
	disp(['Elaborating Strokes LA subj num ' num2str(s)]);
	
	for k = 1:nfpc % number of used fPCs
		nobs_tmp = size(q_stacked_subj(s).q_matrix_la,1); %number of observation give subject
		err_k = zeros(nobs_tmp,njoints); % error with k fPCs in time
		for  i = 1:nobs_tmp
			% select the real signal
			q_tmp = q_stacked_subj(s).q_matrix_la(i,:,:);
			q = reshape(q_tmp, size(q_tmp,2), size(q_tmp,3));
			
			% reconstruct with k number of fPCs the selected signal
			for j = 1:njoints
				q_recon_mat = fpca2q(fPCA_subj(s).la_joint(j));
				q_1dof = q_recon_mat(:,i,k+1); % 1joint in time
				q_recon(:,j) = q_1dof; 
			end
			q_recon = q_recon + mean(q, 1);
			q_error = q - q_recon; 
						
			%rms
			err_k(i, :) = rms(q_error,1);
		end
		% done observations given subject
		mat3_la(:, s-5, k) = (mean(err_k,1))';	
	end
 end
 toc
  save('mat3_la', 'mat3_la');
%% recon calculation AFFECTED
 tic

 for s = 6:s_nsubj+5
	disp(['Elaborating Strokes A subj num ' num2str(s)]);
	
	for k = 1:nfpc % number of used fPCs
		nobs_tmp = size(q_stacked_subj(s).q_matrix_s,1); %number of observation give subject
		err_k = zeros(nobs_tmp,njoints); % error with k fPCs in time
		for  i = 1:nobs_tmp
			% select the real signal
			q_tmp = q_stacked_subj(s).q_matrix_s(i,:,:);
			q = reshape(q_tmp, size(q_tmp,2), size(q_tmp,3));
			
			% reconstruct with k number of fPCs the selected signal
			for j = 1:njoints
				q_recon_mat = fpca2q(fPCA_subj(s).s_joint(j));
				q_1dof = q_recon_mat(:,i,k+1); % 1joint in time
				q_recon(:,j) = q_1dof; 
			end
			q_recon = q_recon + mean(q, 1);
			q_error = q - q_recon; 
						
			%rms
			err_k(i, :) = rms(q_error,1);
		end
		% done observations given subject
		mat3_s(:, s-5, k) = (mean(err_k,1))';	
	end
 end
 toc
 save('mat3_s', 'mat3_s');