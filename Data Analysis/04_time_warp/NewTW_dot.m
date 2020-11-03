% %correct Time warping
%% init
clear all,clc
oldfolder = cd;
cd ../
cd 99_folder_mat
load('q_task.mat');
load('q_task_warped.mat');
cd(oldfolder);
clear oldfolder;
%%Initializa
nSubject_strokes = 19;
nSubject_healthy = 5;
num_tasks = 30;
num_trial = 6;
q_task_warp_corretto = q_task_warp;
q_task_warp_do = q_task;
% %% Come prima cosa andiamo a vedere se il movimento inizia prima o dopo i 20 samples
% % nel caso finisse prima si ricopia l'ultimo valore fino a init_movement, nel caso
% % fosse maggiore si eliminano i primi sample. ora si vede dove finisce il
% % movimento, se prima o dopo di end_movement si fa un resample fino a 240 - end_Movement
% %
%% calcolo delle q di velocità eliminando alcune parti iniziali e finali
for i = 1:num_tasks
	for j = (1:nSubject_healthy + nSubject_strokes)
			for k = 1:num_trial
				%% Inizializzazione variabili
				q_task_warp_corretto(i).subject(j).trial(k).q_grad = [];
				q_task_warp_do(i).subject(j).trial(k).q_grad(:,228:end) = [];
				if not(isempty(q_task_warp(i).subject(j).trial(k).q_grad))
					q_trial = diff(q_task_warp(i).subject(j).trial(k).q_grad(:,10:227)')';
					q_task_warp_do(i).subject(j).trial(k).q_grad = q_trial;
				end
			end
	end
end
%% 

for i = 1:num_tasks
	for j = (1:nSubject_healthy + nSubject_strokes)
		for k = 1:num_trial
			if not(isempty(q_task_warp(i).subject(j).trial(k).q_grad))
				s2 =  correct2pi_err(q_task_warp(i).subject(j).trial(k).q_grad);
				[skip_init, skip_end] = find_skip(s2);
				%% prendere soltanto la parte di movimento effettiva
				s2 = s2(:,skip_init+1:skip_end-1);
				if length(s2) > 0
					s2 = resample(s2',240,skip_end-skip_init-1)';
				end
				q_task_warp_corretto(i).subject(j).trial(k).q_grad = s2;
				q_trial = diff(q_task_warp_corretto(i).subject(j).trial(k).q_grad(:,10:227)')';
				q_task_warp_do(i).subject(j).trial(k).q_grad = q_trial;
			end
			
		end
	end
end
