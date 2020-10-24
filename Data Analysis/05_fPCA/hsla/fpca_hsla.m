function data = fpca_hsla
% this function returns the fpca structure with the fields specified in
% q_fpca.

%% stacking trial
tmp_struct = fpca_stacker_hsla;
q_matrix_h = tmp_struct.q_matrix_h;
q_matrix_s = tmp_struct.q_matrix_s;
q_matrix_la = tmp_struct.q_matrix_la;

%% fpca structure
nbase	= 15;	% number of elements in the base
norder	= 5;	% order of the functions
nfpc	= 10;	% how many fPCs I want to save

njoints = 10;	% number of angular joints in the 10R

% load a single fpca-struct and then repeat it to create structure
fpca_tmp	= q_fpca(q_matrix_h(:,:,2), nbase, norder, nfpc);
h_joint		= repmat(fpca_tmp, 1, njoints);	% healthy fpca-struct
s_joint		= repmat(fpca_tmp, 1, njoints);	% stroke fpca-struct
la_joint	= repmat(fpca_tmp, 1, njoints);	% stroke fpca-struct

%% fpca computation
for dof = 1:njoints
	h_joint(dof)	= q_fpca(q_matrix_h(:,:,dof), nbase, norder, nfpc);
	s_joint(dof)	= q_fpca(q_matrix_s(:,:,dof), nbase, norder, nfpc);
	la_joint(dof)	= q_fpca(q_matrix_la(:,:,dof), nbase, norder, nfpc);
end

%% save section
data = struct;
data.h_joint	= h_joint;
data.s_joint	= s_joint;
data.la_joint	= la_joint;
end

