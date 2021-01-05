function trial = check_trial(task, subject, hORs, lORr, ntrial, strokes_task, healthy_task)
if hORs == 'h'
	if lORr == 'l'
		if isempty(healthy_task(task).subject(subject).left_side_trial(ntrial).L5)
			error([str_trial ' is empty']);
		else
			trial = healthy_task(task).subject(subject).left_side_trial(ntrial);
		end
	elseif lORr == 'r'
		if isempty(healthy_task(task).subject(subject).right_side_trial(ntrial).L5)
			error([str_trial ' is empty']);
		else
			trial = healthy_task(task).subject(subject).right_side_trial(ntrial);
		end
	end
elseif hORs == 's'
	if lORr == 'l'
		if isempty(strokes_task(task).subject(subject).left_side_trial(ntrial).L5)
			error([str_trial ' is empty']);
		else
			trial = strokes_task(task).subject(subject).left_side_trial(ntrial);
		end
	elseif lORr == 'r'
		if isempty(strokes_task(task).subject(subject).right_side_trial(ntrial).L5)
			error([str_trial ' is empty']);
		else
			trial = strokes_task(task).subject(subject).right_side_trial(ntrial);
		end
	end
	
end
disp('Trial found and loaded!')

end