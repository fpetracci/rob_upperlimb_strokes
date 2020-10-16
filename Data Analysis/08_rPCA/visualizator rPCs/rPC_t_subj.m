function [coeff_rPCs, var_rPCs, scoresMm_rPCs, dom] = rPC_t_subj(t, data_all, nsubj, sel_rPC)
%RPC_T extrapulates rPCs about a subject and a specific group of tasks at
%time t
%	input = 
%			t:				selected time 
%			data_all:		rPCA structure results of a certain tasks group for
%								all subjects
%			sbj:			subject number
%			sel_rPC:		number of desired rPC
%	output = 
%			coeff_rPCs:		coeff of selected rPCs at time t
%			var_rPCs:		explained variance of selected rPCs at time t
%			dom:			info if subj is or not dominant
%			scoresMm_rPCs:	max and min value of scores associated to a
%								subject and an istant of time t among all trial executions
%% dominant-non dominant
%subj_Ad: -1 for healthy, 1 for Ad, 0 for And
% Ad	= affected on dominant side
% And	= affected on non-dominant side
subj_Ad = [	-1	-1	-1	-1	-1 ...% healthy
			0	1	1	1	0	1	0	0	1	1	0	0	0	1	1	0	1	1	1];
		%	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24
dom = subj_Ad(nsubj);
%% extrapulation
data_subj = data_all(nsubj);

	if isfield(data_subj.h, 'var_expl')
		vr_rPCs			= data_subj.h.var_expl(sel_rPC,t);
		cff_rPCs		= data_subj.h.coeff(:,sel_rPC,t);
		scr_rPCs		= data_subj.h.scores(:,sel_rPC,t);
		
		var_rPCs		= vr_rPCs;
		coeff_rPCs		= cff_rPCs;
		scoresMm_rPCs	= [max(scr_rPCs), min(scr_rPCs)]';
		
	elseif isfield(data_subj.s, 'var_expl') && isfield(data_subj.la, 'var_expl')
		vr_rPCs_s		= data_subj.s.var_expl(sel_rPC,t);
		vr_rPCs_la		= data_subj.la.var_expl(sel_rPC,t);
		
		cff_rPCs_s		= data_subj.s.coeff(:,sel_rPC,t);
		cff_rPCs_la		= data_subj.la.coeff(:,sel_rPC,t);
		
		scr_rPCs_s		= data_subj.s.scores(:,sel_rPC,t);
		scr_rPCs_la		= data_subj.la.scores(:,sel_rPC,t);
		
		scoresMm_rPCs_s	= [max(scr_rPCs_s), min(scr_rPCs_s)]';
		scoresMm_rPCs_la= [max(scr_rPCs_la), min(scr_rPCs_la)]';
		
		var_rPCs		= [vr_rPCs_s, vr_rPCs_la];
		coeff_rPCs		= [cff_rPCs_s, cff_rPCs_la];
		scoresMm_rPCs	= [scoresMm_rPCs_s, scoresMm_rPCs_la];
	end
	
end