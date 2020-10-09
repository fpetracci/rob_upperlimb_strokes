function data = fpca_subj(nsubj)
% COMMENTAMI

%% check subj

if nsubj < 6
	healthy_subj = 1;
	stroke_subj = 0;
else
	healthy_subj = 0;
	stroke_subj = 1;
end

%% stacking trial
tmp_struct = fpca_stacker_subj(nsubj);

if healthy_subj
	q_matrix_h = tmp_struct.q_matrix_h;
end
if stroke_subj
	q_matrix_s = tmp_struct.q_matrix_s;
	q_matrix_la = tmp_struct.q_matrix_la;
end

%% fpca
nbase	= 15;	% number of elements in the base
norder	= 5;	% order of the functions
nfpc	= 10;	% how many fPCs I want to save

njoints = 10;	% number of angular joints in the 10R

% load a single fpca-struct and then repeat it to create structure
if healthy_subj
	fpca_tmp = q_fpca(q_matrix_h(:,:,1), nbase, norder, nfpc);
	h_joint = repmat(fpca_tmp, 1, njoints);	% healthy fpca-struct
end
if stroke_subj
	fpca_tmp = q_fpca(q_matrix_s(:,:,1), nbase, norder, nfpc);
	s_joint = repmat(fpca_tmp, 1, njoints);	% stroke fpca-struct
	la_joint = repmat(fpca_tmp, 1, njoints);	% stroke fpca-struct
end


for dof = 1:njoints
	if healthy_subj
		h_joint(dof) = q_fpca(q_matrix_h(:,:,dof), nbase, norder, nfpc);
	end
	if stroke_subj
		s_joint(dof) = q_fpca(q_matrix_s(:,:,dof), nbase, norder, nfpc);
		la_joint(dof) = q_fpca(q_matrix_la(:,:,dof), nbase, norder, nfpc);
	end
end

%% save section
data = struct;

if healthy_subj
		data.h_joint = h_joint;
end
if stroke_subj
	data.s_joint = s_joint;
	data.la_joint = la_joint;
end

end