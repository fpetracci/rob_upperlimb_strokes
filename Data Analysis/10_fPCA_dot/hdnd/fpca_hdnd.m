function data = fpca_hdnd(ngroup)
% this function returns the fpca structure with the fields specified in
% q_fpca.

%% stacking trial
tmp_struct = fpca_stacker_hdnd(ngroup);
q_matrix_h = tmp_struct.q_matrix_h;
q_matrix_a_d = tmp_struct.q_matrix_a_d;
q_matrix_la_d = tmp_struct.q_matrix_la_d;
q_matrix_a_nd = tmp_struct.q_matrix_a_nd;
q_matrix_la_nd = tmp_struct.q_matrix_la_nd;

%% fpca structure
nbase	= 15;	% number of elements in the base
norder	= 5;	% order of the functions
nfpc	= 10;	% how many fPCs I want to save

njoints = 10;	% number of angular joints in the 10R

% load a single fpca-struct and then repeat it to create structure
fpca_tmp	= q_fpca(q_matrix_h(:,:,2), nbase, norder, nfpc);
h_joint		= repmat(fpca_tmp, 1, njoints);	% healthy fpca-struct
a_d_joint	= repmat(fpca_tmp, 1, njoints);	% stroke affected dominant fpca-struct
la_d_joint	= repmat(fpca_tmp, 1, njoints);	% stroke less affected dominant fpca-struct
a_nd_joint	= repmat(fpca_tmp, 1, njoints);	% stroke affected non dominant fpca-struct
la_nd_joint	= repmat(fpca_tmp, 1, njoints);	% stroke less affected non dominant fpca-struct
%% fpca computation
for dof = 1:njoints
	h_joint(dof)	= q_fpca(q_matrix_h(:,:,dof), nbase, norder, nfpc);
	a_d_joint(dof)	= q_fpca(q_matrix_a_d(:,:,dof), nbase, norder, nfpc);
	la_d_joint(dof)	= q_fpca(q_matrix_la_d(:,:,dof), nbase, norder, nfpc);
	a_nd_joint(dof)	= q_fpca(q_matrix_a_nd(:,:,dof), nbase, norder, nfpc);
	la_nd_joint(dof)= q_fpca(q_matrix_la_nd(:,:,dof), nbase, norder, nfpc);
end

%% save section
data = struct;
data.h_joint	= h_joint;
data.a_d_joint	= a_d_joint;
data.la_d_joint	= la_d_joint;
data.a_nd_joint	= a_nd_joint;
data.la_nd_joint= la_nd_joint;
end

