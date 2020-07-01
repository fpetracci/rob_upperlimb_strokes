function view_trial(task, subject, hORs, lORr, ntrial)
%view_trial plots and animates all relevant steps of our process to analyze
% a single trial specified by task, healthy or stroke subject, left or
% right side trial.
%	In order this function generates:
%	0. Brief description of the chosen task and some info on the subject.
%	1. Animation of the recorded given trial
%	2. Animation of the 10Rarm doing that task, Plot errors???
%	3. Animation of the warped task done by the 10Rarm, plot joint angles
%	before and after
%	4. Animation of the prime componenti analisi cose belle
%
%	How to use:
%	view_trial(task, subject, hORs, lORr, trial)
%	task:			1-30
%	subject:		1-5 for healthy, 1-19 for stroke
%	hORs:			'h' for healthy, 's' stroke subject
%	lORR:			'l' left or 'r' right side
%	ntrial:			1-3 trial number

%% TO DO LIST
% check if trial
% info
% animation of chosen trial
% animation of 10R robot

% capire che fare dopo

%% check if input is correct
%task
if not(isa(task, 'double'))
	error('task number must be an integer number between 1-30')
else
	if task < 1 || task > 30 || (floor(task)-task ~= 0 )
		error('task number must be an integer number between 1-30')
	end
end
%hORs
if not(isa(hORs, 'char')) || norm(size(hORs)) ~= norm([1 1])
	error('hORs must be a char, either ''h'' or ''s'' ')
else
	if hORs == 'h'
	elseif hORs == 's'
	else
		error('hORs must be a char, either ''h'' or ''s'' ')
	end
end

%subject
if not(isa(subject, 'double'))
	error('subject number must be an integer number')
elseif  hORs == 'h' && (subject < 1 || subject > 5 || (floor(subject)-subject ~= 0 ) )
	error('healthy subject number must be an integer number between 1-5')
elseif hORs == 's' && (subject < 1 || subject > 19 || (floor(subject)-subject ~= 0 ) )
	error('stroke subject number must be an integer number between 1-19')

end

%lORr
if not(isa(lORr, 'char')) || norm(size(lORr)) ~= norm([1 1])
	error('lORr must be a char, either ''l'' or ''r'' ')
else
	if lORr == 'l'
	elseif lORr == 'r'
	else
		error('lORr must be a char, either ''l'' or ''r'' ')
	end
end

%ntrial
if not(isa(ntrial, 'double'))
	error('ntrial number must be an integer number between 1-3')
else
	if ntrial < 1 || ntrial > 3 || (floor(ntrial)-ntrial ~= 0 )
		error('ntrial number must be an integer number between 1-3')
	end
end

str_trial = ['Task ' num2str(task) ' executed by ' hORs '-subject ' ...
				num2str(subject) ' with ' lORr '-arm on the ' ...
				num2str(ntrial) ' trial'];
			
disp(str_trial)

%% info on task
switch task
    case 1
        disp('negative one')

end
%% task description

% 1) Ok gesture
% 2) Thumb down gesture
% 3) Exultation gesture
% 4) Hitchhiking
% 5) Block out sun from own face
% 6) Greet
% 7) Military salute
% 8) Stop gesture
% 9) Pointing of somenthing straight ahed
% 10) Silence gesture
% 11) Reach and grasp a small suitcase from the handle, lift it and place
%		it on the floor (close to the chair)
% 12) Reach and grasp a glass. drink for 3 seconds and place it in the
%		initial position
% 13) Reach and grasp a phone receiver, carry it to own ear for 3 seconds
%		and place it in the initial postion
% 14) Reach and grasp a book, put in on the table and open it from right
%		side to left side
% 15) Reach and grasp a small cup from the handle (2 fingers and thumb),
%		drink for 3 seconds and place it in the initial position
% 16) Reach and grasp an apple, mimic biting and put it in the initial
%		position
% 17) Reach and grasp a hat (placed on the right side of the table) from 
%		its top and place it on own head
% 18) Reach and grasp a cup from its top, lift it and put it on the left side of the table
% 19) Receive a tray from someone (straight ahead, with open hand) and put it in the middle of the table
% 20) Reach and grasp a key in a lock (vertical axis), extract it from the lock and put it on the left side of the table
% 21) Reach and grasp a bottle, pour water into a glass, and put the bottle in the initial position
% 22) Reach and grasp a tennis racket (placed along own frontal plane), and play a forehand (the subject is still seated)
% 23) Reach and grasp a toothbrush, brush teeth (horizontal axis, one time on left side one time on right side), and put the
%		toothbrush inside a cylindrical holder (placed on the right side of the table)
% 24) Reach and grasp a laptop and open the laptop (without changing its position) (4 fingers + thumb)
% 25) Reach and grasp a pen (placed on the right side of the table) and draw a vertical line on the table (from the top to the
%		bottom)
% 26) Reach and grasp a pencil (placed along own frontal plane) (3 fingers + thumb) and put it inside a squared pencil
%		holder (placed on the left side of the table)
% 27) Reach and grasp a tea bag in a cup (1 finger + thumb), remove it from the cup, and place it on the table on the right
%		side of the table
% 28) Reach and grasp a doorknob (disk shape), turn it clockwise, and counterclockwise and open the door
% 29) Reach and grasp a tennis ball (with fingertips) and place it in a basket placed on the floor (close to own chair)
% 30) Reach and grasp a cap (2 fingers + thumb) of a bottle (held by left hand), unscrew it, and place it overhead on a shelf
%% load
oldfolder = cd;
cd ../
cd 99_folder_mat
load('healthy_task.mat');
load('strokes_task.mat');
load('q_task.mat');
% load q warped
cd(oldfolder);
clear oldfolder;



%% info on subject

%% check if trial exist
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
		if isempty(stroke_task(task).subject(subject).left_side_trial(ntrial).L5)
			error([str_trial ' is empty']);
		else
			trial = stroke_task(task).subject(subject).left_side_trial(ntrial);
		end
	elseif lORr == 'r'
		if isempty(stroke_task(task).subject(subject).right_side_trial(ntrial).L5)
			error([str_trial ' is empty']);
		else
			trial = stroke_task(task).subject(subject).right_side_trial(ntrial);
		end
	end
	
end
disp('Trial found and loaded!')

%% animation of the trial

%% animation of 10R doing the trial



% animation of all data


end

