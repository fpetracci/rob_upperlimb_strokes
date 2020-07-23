 %CALCULATE DISSIMILARITY INDEX 
 clear all
if exist('q_stacked_subj') ~= 1
	if exist('loader_subj_mat.mat') == 2
		load('loader_subj_mat.mat');
	else
		loader_subj
	end
end

%% index calculation

tic

nsamples	= 240;	% time length of each signal
njoints		= 10;	% number of joints
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
for nsubj = [9 15 16 18]%15 %6:24
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
			err_k(i) = min(rms(q_s - q_recon_s, 2) );

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
			err_k(i) = min(rms(q_la - q_recon_la, 2) );
		end
		
		E_la(k) = mean(err_k);
	end
	
	ID(nsubj-5) = sum(E_la - E_s);
	E_subj(nsubj-5, :, 1) = E_la;
	E_subj(nsubj-5, :, 2) = E_s;
end
	
toc

save('E', 'E_subj')


%% plot E_la vs E_s
figure(1)
clf
title(['Subj ' num2str(nsubj) ' ID '   num2str(ID(nsubj-5)) ])
plot(E_la, 'g')
hold on
plot(E_s, 'r')

%%
E_la = E_subj(:,:,1);
E_s = E_subj(:,:,2);
nsubj = 18;
i_subj = nsubj -5;
ID = sum(E_la(i_subj,:) - E_s(i_subj,:));
figure(1)
clf
plot(E_la(i_subj,:), 'g')
hold on
plot(E_s(i_subj,:), 'r')
title(['Subj ' num2str(nsubj) ' ID '   num2str(ID) ])

%% index calculation ONLY 7R

tic

nsamples	= 240;	% time length of each signal
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

for nsubj = [9 15 16 18]%6:24
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
			err_rms = rms(q_s - q_recon_s, 2);
			err_k(i) = min(err_rms);
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
			err_rms = rms(q_la - q_recon_la, 2);
			err_k(i) = min(err_rms);
		end
		
		E_la(k) = mean(err_k);
	end
	
	ID(nsubj-5) = sum(E_la - E_s);
	E_subj(nsubj-5, :, 1) = E_la;
	E_subj(nsubj-5, :, 2) = E_s;
end
	
toc
save('E7', 'E_subj')
