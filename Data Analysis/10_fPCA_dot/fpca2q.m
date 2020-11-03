function [qmat, qmat_separated] = fpca2q(fpca_struct)
%FPCA2Q reconstructs the first principal components angular joints given
%the structure cointaining fpca information.
%	INPUT is:
%	.fpca struct - low level structure		
% 	 val_pc: [nsamples×nfpc double]
%      comp: [nobs×nfpc double]
%       var: [nfpc×1 double]
%      mean: [nsamples×1 double]
%      info: [1×1 struct]
%
%	OUTPUT is:
%	.qmat - a matrix cointaing angular joints:
%	first column is only first pc. Second column is first plus second pc 
%	and so on.
%	.qmat_separate - a matrix cointaing angular joints:
%	first column is only first pc. Second column is only second pc 
%	and so on.
%	
%	NOTE: angular joints are in degrees


% load data from struct
val_pc		= fpca_struct.val_pc;
comp		= fpca_struct.comp;
mean		= fpca_struct.mean;
nfpc		= fpca_struct.info.nfpc;
n			= fpca_struct.info.n;
nobs		= fpca_struct.info.nobs;

% build q
qmat = zeros(n, nobs, nfpc+1);
qmat_separated = qmat;

for i = 1:(nfpc+1)
	ii = i-1;
	
	for j = 1:n
		if i == 1
			qmat(j,:,i) = mean(j)';
			qmat_separated(j,:,i) = mean(j)';
		else
			tmp_sum = sum((val_pc(j,[1:ii]) .* comp(:,[1:ii])),2);
			tmp = val_pc(j,ii) .* comp(:,ii);
			qmat(j,:,i) =  (tmp_sum + mean(j))';
			qmat_separated(j,:,i) = tmp';
		end
		
	end
end
% 
% %
% qmat_separated = zeros(n, nobs, nfpc + 1);
% for i = 1:(nfpc+1)
% 	for j = 1:n
% 		q_mat(j,:,i) = (val_pcpc(j,[1:i]) .* comp(:,[1:i]))';
% 	end
% end
% 


end

