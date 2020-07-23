function err  = approx_err1joint(q, qrecon)
% USELESS -> usa: mean(rms(q-qrecon, 1)


% err = nsamples×1


%% intro

% smaller names for easy visibility
q1 = q;
q2 = qrecon;


% check:
if  size(q1,1)~= size(q2,1) || size(q1,2)~= size(q2,2)
	error('different sizes in input!')
end

nsamples = length(q1); % number of samples


end




%approx_err1joint calculates the approx error between a given
%fpca result using the specified number fpc to consider and the original
%recorded trial
%	INPUT is:
%	.fpca struct	- low level structure(example: fPCA_subj(1).h_joint(1))
%	 	 val_pc: [nsamples×nfpc double]
%		   comp: [nobs×nfpc double]
%		    var: [nfpc×1 double]
%		   mean: [nsamples×1 double]
%	       info: [1×1 struct]
%	.q_1joint		- the original recorded trial signal for 1 joint angle
%
%	OUTPUT is:
%	.approx_error	- approximation error between recorded trial and
%					  reconstruction. It is a 2 dimension vector: 
%					  [nsamples×nfpc_used] 
%	
%	NOTE: angular joints are in degrees