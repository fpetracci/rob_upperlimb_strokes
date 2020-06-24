



for i = 1:nTasks
	
	for j = 1:nSubject_healthy
		healthy_task_q(i).subject(j).stroke_side = -1;
		for k = 1:nTrial
			filenameL = healthy_task(i).subject(j).left_side_trial(k);
			healthy_task_q(i).subject(j).left_side_trial(k) = q_dataload(filenameL);
% 			healthy_task_q(i).subject(j).left_side_trial(k).stroke_side = -1;
% 			healthy_task_q(i).subject(j).left_side_trial(k).task_side = 0;

			filenameR = healthy_task(i).subject(j).right_side_trial(k);
			healthy_task_q(i).subject(j).right_side_trial(k) = q_dataload(filenameR)
% 			healthy_task_q(i).subject(j).right_side_trial(k).stroke_side = -1;
% 			healthy_task_q(i).subject(j).right_side_trial(k).task_side = 1;
		end
	end
end
		