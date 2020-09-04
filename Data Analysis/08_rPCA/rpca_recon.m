function [recon_qh, recon_qs, recon_qla] = rpca_recon(ntask)
%RPCA_RECON reconstructs stacked matrix (nobs_h x nsamples x njoints) for
% given task. Output is matrix (nsamples x njoints x nobs_h x npc)

% first we calculate rpca and the stacked original matrix
struct_old = rpca_stacker_task(ntask);
data = rpca(ntask);

% get sizes
[~, ntot, njoints] = size(struct_old.q_matrix_h);
%	ntot		= total number of time frames
%	njoints		= number of DOF of the robot-arm
ntrial_h	= size(struct_old.q_matrix_h,	1); % number of valid healthy trial
ntrial_s	= size(struct_old.q_matrix_s,	1); % number of valid stroke trial
ntrial_la	= size(struct_old.q_matrix_la,	1); % number of valid lessaffected trial
npc = 10;

% extract mean
mean_h = mean(struct_old.q_matrix_h,1);
mean_h = reshape(mean_h,ntot,njoints,1);

mean_s = mean(struct_old.q_matrix_s,1);
mean_s = reshape(mean_s,ntot,njoints,1);

mean_la = mean(struct_old.q_matrix_la,1);
mean_la = reshape(mean_la,ntot,njoints,1);

%reshape(mean_h,ntot,njoints,1)

%% reconstruct

% prealloc, npc+1 so we can put mean in first position
recon_qh	= zeros(ntrial_h, ntot, njoints, npc+1); 
recon_qs	= zeros(ntrial_s, ntot, njoints, npc+1);
recon_qla	= zeros(ntrial_la, ntot, njoints, npc+1);

for t = 1:ntot
	
	% reset partial sum
	oldrecon_h = 0;
	oldrecon_s = 0;
	oldrecon_la = 0;
	for i = 1:(npc+1)
		ii = i -1; % number of pc taken in account
		% in i = 1, we put the mean
		
		if i == 1
			recon_ti_h = ones(ntrial_h, njoints) .* mean_h(t,:);
			recon_ti_s = ones(ntrial_s, njoints) .* mean_s(t,:);
			recon_ti_la = ones(ntrial_la, njoints) .* mean_la(t,:);
		else
			recon_ti_h = oldrecon_h + data.h.scores(:,ii,t) * data.h.coeff(:,ii,t)';
			recon_ti_s = oldrecon_s + data.s.scores(:,ii,t) * data.s.coeff(:,ii,t)';
			recon_ti_la = oldrecon_la + data.la.scores(:,ii,t) * data.la.coeff(:,ii,t)';
		end
		
		% save current reconstruction
		recon_qh(:,t,:,i) = recon_ti_h;
		recon_qs(:,t,:,i) = recon_ti_s;
		recon_qla(:,t,:,i) = recon_ti_la;
		
		% store current reconstruction
		oldrecon_h = recon_ti_h;
		oldrecon_s = recon_ti_s;
		oldrecon_la = recon_ti_la;
	end
	
end








%reconstruct = scorei(:,1) * coeffi(:,1)' + mean

%end

