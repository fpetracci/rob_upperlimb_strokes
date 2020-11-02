function q_mat = q_fpca2q(fpca_struct)
%Q_FPCA2Q reconstruct the first principal components angular joints given
%the struct cointaining fpca information.
%	Output is a matrix cointaing angular joints:
%	first column is only first pc. Second column is first plus second pc 
%	and so on.
%	NOTE: angular joints are in degrees

% load data from struct
pc		= fpca_struct.pc;
comp	= fpca_struct.comp;
mean	= fpca_struct.mean;
nfpc	= fpca_struct.info.nfpc;
n		= fpca_struct.info.n;
njoints = fpca_struct.info.njoints;


% build q
q_mat = zeros(n, njoints, nfpc);

for i = 1:nfpc
	for j = 1:n
		tmp = sum((pc(j,[1:i]) .* comp(:,[1:i])),2);
		q_mat(j,:,i) =  (tmp + mean(j))';
	end
end

% 




end

