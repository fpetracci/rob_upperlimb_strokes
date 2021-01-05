function q_trial = load_q(task, subject, hORs, lORr, ntrial, q_task)
	% loading of angular joints estimate from q_task struct
	if hORs == 'h'
		if lORr == 'l'
			% nothing to correct
			q_trial = q_task(task).subject(subject).trial(ntrial);
		elseif lORr == 'r'
			% correct only ntrial
			q_trial = q_task(task).subject(subject).trial(ntrial+3);
		end
	elseif hORs == 's'
		if lORr == 'l'
			% correct subject
			q_trial = q_task(task).subject(subject+5).trial(ntrial);
		elseif lORr == 'r'
			% correct subject and ntrial
			q_trial = q_task(task).subject(subject+5).trial(ntrial+3);
		end
	end
end

