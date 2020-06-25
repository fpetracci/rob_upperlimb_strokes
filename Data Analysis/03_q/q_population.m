for i = 1:nTasks
	
%% healthy
for j = 1:nSubject_healthy
	q_task(i).subject(j).stroke_side = -1;
	for k = 1:(2*nTrial)
		if k <= 3
			trial = healthy_task(i).subject(j).left_side_trial(k);
			q_task(i).subject(j).trial(k) = q_trial2q(trial);
		elseif k > 3
			k_right = k-3;
			trial = healthy_task(i).subject(j).right_side_trial(k_right);
			q_task(i).subject(j).trial(k) = q_trial2q(trial);
		end
		str = ['task ', num2str(i), ' subject ', num2str(j), ' trial ', num2str(k), '\n'];
		fprintf(str)
	end

	% after task.subject is done, we complete the substructure
	for kk = 1:(2*nTrial)
		if kk <= 3
			q_task(i).subject(j).trial(kk).stroke_task = ...
				healthy_task(i).subject(j).left_side_trial(kk).stroke_task;
			q_task(i).subject(j).trial(kk).stroke_side = ...
				healthy_task(i).subject(j).left_side_trial(kk).stroke_side;
			q_task(i).subject(j).trial(kk).task_side = ...
				healthy_task(i).subject(j).left_side_trial(kk).task_side;
		elseif kk > 3
			kk_right = kk - 3;
			q_task(i).subject(j).trial(kk).stroke_task = ...
				healthy_task(i).subject(j).right_side_trial(kk_right).stroke_task;
			q_task(i).subject(j).trial(kk).stroke_side = ...
				healthy_task(i).subject(j).right_side_trial(kk_right).stroke_side;
			q_task(i).subject(j).trial(kk).task_side = ...
				healthy_task(i).subject(j).right_side_trial(kk_right).task_side;
		end	
	end


end


%% stroke
for j = (nSubject_healthy+1):(nSubject_healthy+nSubject_strokes)
	q_task(i).subject(j).stroke_side = ...
		strokes_task(i).subject(j-nSubject_healthy).stroke_side;
	for k = 1:(2*nTrial)
		if k <= 3
			trial = strokes_task(i).subject(j).left_side_trial(k);
			q_task(i).subject(j).trial(k) = q_trial2q(trial);
		elseif k > 3
			k_right = k-3;
			trial = strokes_task(i).subject(j).right_side_trial(k_right);
			q_task(i).subject(j).trial(k) = q_trial2q(trial);
		end
		
		str = ['task ', num2str(i), ' subject ', num2str(j), ' trial ', num2str(k), '\n'];
		fprintf(str)
	end

	% after task.subject is done, we complete the substructure
	for kk = 1:(2*nTrial)
		if kk <= 3
			q_task(i).subject(j).trial(kk).stroke_task = ...
				strokes_task(i).subject(j).left_side_trial(kk).stroke_task;
			q_task(i).subject(j).trial(kk).stroke_side = ...
				strokes_task(i).subject(j).left_side_trial(kk).stroke_side;
			q_task(i).subject(j).trial(kk).task_side = ...
				strokes_task(i).subject(j).left_side_trial(kk).task_side;
		elseif kk > 3
			kk_right = kk - 3;
			q_task(i).subject(j).trial(kk).stroke_task = ...
				strokes_task(i).subject(j).right_side_trial(kk_right).stroke_task;
			q_task(i).subject(j).trial(kk).stroke_side = ...
				strokes_task(i).subject(j).right_side_trial(kk_right).stroke_side;
			q_task(i).subject(j).trial(kk).task_side = ...
				strokes_task(i).subject(j).right_side_trial(kk_right).task_side;
		end	
	end

end






end
		