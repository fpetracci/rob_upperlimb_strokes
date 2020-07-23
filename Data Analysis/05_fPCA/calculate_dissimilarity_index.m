 %CALCULATE DISSIMILARITY INDEX 
 clear all;
 
%% load fPCA_subj
oldfolder = cd;
cd ../
cd 99_folder_mat
load('q_task_warped.mat');

cd(oldfolder);
clear oldfolder;

% const
task_num = 30;
subj_num = 24;
joint_num = 10;
obs_num = 240;
% load dummy struct;
dummy_struct1	= fpca_task(1);
fPCA_subj		= repmat(dummy_struct1,1, subj_num);

for nsubj = 1:subj_num
	%compute fpca for current task 
	disp(['Elaborating subj num ' num2str(nsubj)]);
	struct_tmp = fpca_subj(nsubj);
	if nsubj <6
		fPCA_subj(nsubj).h_joint = struct_tmp.h_joint;
		fPCA_subj(nsubj).s_joint = [];
		fPCA_subj(nsubj).la_joint = [];
	else
		fPCA_subj(nsubj).h_joint = [];
		fPCA_subj(nsubj).s_joint = struct_tmp.s_joint;
		fPCA_subj(nsubj).la_joint = struct_tmp.la_joint;
	end
end

%% load q_stacked_subj
dummy_struct1	= fpca_stacker_subj(1);
q_stacked_subj	= repmat(dummy_struct1, 1, subj_num);

for nsubj = 1:subj_num
	disp(['Stacking subj num ' num2str(nsubj)]);
	struct_tmp = fpca_stacker_subj(nsubj);
	if nsubj <6
		q_stacked_subj(nsubj).q_matrix_h = struct_tmp.q_matrix_h;
		q_stacked_subj(nsubj).q_matrix_s = [];
		q_stacked_subj(nsubj).q_matrix_la = [];
	else
		q_stacked_subj(nsubj).q_matrix_h = [];
		q_stacked_subj(nsubj).q_matrix_s = struct_tmp.q_matrix_s;
		q_stacked_subj(nsubj).q_matrix_la = struct_tmp.q_matrix_la;
	end	
end

%% 

tic

nsamples = 240;
njoints = 10;
nfpc = 10; 
subj_num = 19;

%init for efficiency
q_recon_s = zeros(nsamples, njoints);
q_recon_la = q_recon_s;

ID = zeros(subj_num,1);

%
E = zeros(nfpc,1);
E_s = E;
E_la = E;
E_subj = zeros(subj_num, nfpc, 2);

for nsubj = [9 15 16 18]
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
			q_recon_s = q_recon_s + mean(q_s, 2);

			%rms
			err_k(i) = min(rms(q_s - q_recon_s, 1) );
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
			q_recon_la = q_recon_la + mean(q_la,2);

			%rms
			err_k(i) = min(rms(q_la - q_recon_la, 1) );
		end
		
		E_la(k) = mean(err_k);
	end
	
	ID(nsubj-5) = sum(E_la - E_s);
	E_subj(nsubj-5, :, 1) = E_la;
	E_subj(nsubj-5, :, 2) = E_s;
end
	
toc

%% 
figure(1)
clf
title(['Subj ' num2str(nsubj) ' ID '   num2str(ID(nsubj-5)) ])
plot(E_la, 'g')
hold on
plot(E_s, 'r')


%%
for i = [1 5 10]
	i
end
	
