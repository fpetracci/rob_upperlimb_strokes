%% anovan init
% check if it's necessasary import data
check = exist("q_stacked_task");
if check ~= 1 % return 1 if a variable is in the workspace
	fpca_RUNME
end

%% creation of all necessary vectors

%% var vectors
	% healthy
	% less affected
	% strokes	

% no tasks distinctions
var_h1	= zeros(30*10,1);	% stores first fPC var of 30 task and 10 joint for healthy subjects 
var_la1 = zeros(30*10,1);	% stores first fPC var of 30 task and 10 joint for less affected subjects
var_s1	= zeros(30*10,1);	% stores first fPC var of 30 task and 10 joint for strokes subjects

var_h2	= zeros(30*10,1);	% stores second fPC var of 30 task and 10 joint for healthy subjects 
var_la2 = zeros(30*10,1);	% stores second fPC var of 30 task and 10 joint for less affected subjects
var_s2	= zeros(30*10,1);	% stores second fPC var of 30 task and 10 joint for strokes subjects

var_h3	= zeros(30*10,1);	% stores third fPC var of 30 task and 10 joint for healthy subjects 
var_la3 = zeros(30*10,1);	% stores third fPC var of 30 task and 10 joint for less affected subjects
var_s3	= zeros(30*10,1);	% stores third fPC var of 30 task and 10 joint for strokes subjects

% separated into 3 tasks groups
% first: int (intransitive)
var_int_h1	= zeros(10*10,1);	% stores first fPC var of first 10 task and 10 joint for healthy subjects 
var_int_la1 = zeros(10*10,1);	% stores first fPC var of first 10 task and 10 joint for less affected subjects
var_int_s1	= zeros(10*10,1);	% stores first fPC var of first 10 task and 10 joint for strokes subjects

var_int_h2	= zeros(10*10,1);	% stores second fPC var of first 10 task and 10 joint for healthy subjects 
var_int_la2 = zeros(10*10,1);	% stores second fPC var of first 10 task and 10 joint for less affected subjects
var_int_s2	= zeros(10*10,1);	% stores second fPC var of first 10 task and 10 joint for strokes subjects

var_int_h3	= zeros(10*10,1);	% stores third fPC var of first 10 task and 10 joint for healthy subjects 
var_int_la3 = zeros(10*10,1);	% stores third fPC var of first 10 task and 10 joint for less affected subjects
var_int_s3	= zeros(10*10,1);	% stores third fPC var of first 10 task and 10 joint for strokes subjects

% second: tr (transitive)
var_tr_h1	= zeros(10*10,1);	% stores first fPC var of second 10 task and 10 joint for healthy subjects 
var_tr_la1	= zeros(10*10,1);	% stores first fPC var of second 10 task and 10 joint for less affected subjects
var_tr_s1	= zeros(10*10,1);	% stores first fPC var of second 10 task and 10 joint for strokes subjects

var_tr_h2	= zeros(10*10,1);	% stores second fPC var of second 10 task and 10 joint for healthy subjects 
var_tr_la2	= zeros(10*10,1);	% stores second fPC var of second 10 task and 10 joint for less affected subjects
var_tr_s2	= zeros(10*10,1);	% stores second fPC var of second 10 task and 10 joint for strokes subjects

var_tr_h3	= zeros(10*10,1);	% stores third fPC var of second 10 task and 10 joint for healthy subjects 
var_tr_la3	= zeros(10*10,1);	% stores third fPC var of second 10 task and 10 joint for less affected subjects
var_tr_s3	= zeros(10*10,1);	% stores third fPC var of second 10 task and 10 joint for strokes subjects

% third: tm (tool mediated)
var_tm_h1	= zeros(10*10,1);	% stores first fPC var of third 10 task and 10 joint for healthy subjects 
var_tm_la1	= zeros(10*10,1);	% stores first fPC var of third 10 task and 10 joint for less affected subjects
var_tm_s1	= zeros(10*10,1);	% stores first fPC var of third 10 task and 10 joint for strokes subjects

var_tm_h2	= zeros(10*10,1);	% stores second fPC var of third 10 task and 10 joint for healthy subjects 
var_tm_la2	= zeros(10*10,1);	% stores second fPC var of third 10 task and 10 joint for less affected subjects
var_tm_s2	= zeros(10*10,1);	% stores second fPC var of third 10 task and 10 joint for strokes subjects

var_tm_h3	= zeros(10*10,1);	% stores third fPC var of third 10 task and 10 joint for healthy subjects 
var_tm_la3	= zeros(10*10,1);	% stores third fPC var of third 10 task and 10 joint for less affected subjects
var_tm_s3	= zeros(10*10,1);	% stores third fPC var of third 10 task and 10 joint for strokes subjects

%% var_mean vectors 
	% healthy
	% less affected
	% strokes

% no tasks distinctions
var_mean_h1	 = zeros(10,1);
var_mean_la1 = zeros(10,1);
var_mean_s1	 = zeros(10,1);

% separate into 3 task groups
% no tasks distinctions inside first group: int (intransitive)
var_mean_int_h1	 = zeros(10,1);
var_mean_int_la1 = zeros(10,1);
var_mean_int_s1	 = zeros(10,1);

% no tasks distinctions inside second group: tr (transitive)
var_mean_tr_h1	 = zeros(10,1);
var_mean_tr_la1	 = zeros(10,1);
var_mean_tr_s1	 = zeros(10,1);

% no tasks distinctions inside third group: tm (tool mediated)
var_mean_tm_h1	 = zeros(10,1);
var_mean_tm_la1	 = zeros(10,1);
var_mean_tm_s1	 = zeros(10,1);

% no tasks distinctions
var_mean_h2	 = zeros(10,1);
var_mean_la2 = zeros(10,1);
var_mean_s2	 = zeros(10,1);

% separate into 3 task groups
% no tasks distinctions inside first group: int (intransitive)
var_mean_int_h2	 = zeros(10,1);
var_mean_int_la2 = zeros(10,1);
var_mean_int_s2	 = zeros(10,1);

% no tasks distinctions inside second group: tr (transitive)
var_mean_tr_h2	 = zeros(10,1);
var_mean_tr_la2	 = zeros(10,1);
var_mean_tr_s2	 = zeros(10,1);

% no tasks distinctions inside third group: tm (tool mediated)
var_mean_tm_h2	 = zeros(10,1);
var_mean_tm_la2	 = zeros(10,1);
var_mean_tm_s2	 = zeros(10,1);

% no tasks distinctions
var_mean_h3	 = zeros(10,1);
var_mean_la3 = zeros(10,1);
var_mean_s3	 = zeros(10,1);

% separate into 3 task groups
% no tasks distinctions inside first group: int (intransitive)
var_mean_int_h3	 = zeros(10,1);
var_mean_int_la3 = zeros(10,1);
var_mean_int_s3	 = zeros(10,1);

% no tasks distinctions inside second group: tr (transitive)
var_mean_tr_h3	 = zeros(10,1);
var_mean_tr_la3	 = zeros(10,1);
var_mean_tr_s3	 = zeros(10,1);

% no tasks distinctions inside third group: tm (tool mediated)
var_mean_tm_h3	 = zeros(10,1);
var_mean_tm_la3	 = zeros(10,1);
var_mean_tm_s3	 = zeros(10,1);

%% n_expl vectors
	% healthy
	% less affected
	% strokes	

% no tasks distinctions
n_expl_h	= zeros(30*10,1);	% number of first fPCs needed to explain at least threshold (thr_var) % of the movement for healthy subjects
n_expl_la	= zeros(30*10,1);	% number of first fPCs needed to explain at least threshold (thr_var) % of the movement for less affected subjects
n_expl_s	= zeros(30*10,1);	% number of first fPCs needed to explain at least threshold (thr_var) % of the movement for strokes subjects

% separate into 3 task groups
% intransitive tasks
n_expl_int_h	= zeros(10*10,1);	% number of first fPCs needed to explain at least threshold (thr_var) % of the movement for healthy subjects
n_expl_int_la	= zeros(10*10,1);	% number of first fPCs needed to explain at least threshold (thr_var) % of the movement for less affected subjects
n_expl_int_s	= zeros(10*10,1);	% number of first fPCs needed to explain at least threshold (thr_var) % of the movement for strokes subjects

% transitive tasks
n_expl_tr_h		= zeros(10*10,1);	% number of first fPCs needed to explain at least threshold (thr_var) % of the movement for healthy subjects
n_expl_tr_la	= zeros(10*10,1);	% number of first fPCs needed to explain at least threshold (thr_var) % of the movement for less affected subjects
n_expl_tr_s		= zeros(10*10,1);	% number of first fPCs needed to explain at least threshold (thr_var) % of the movement for strokes subjects

% tool mediated tasks
n_expl_tm_h		= zeros(10*10,1);	% number of first fPCs needed to explain at least threshold (thr_var) % of the movement for healthy subjects
n_expl_tm_la	= zeros(10*10,1);	% number of first fPCs needed to explain at least threshold (thr_var) % of the movement for less affected subjects
n_expl_tm_s		= zeros(10*10,1);	% number of first fPCs needed to explain at least threshold (thr_var) % of the movement for strokes subjects

%% n_expl_mean vectors (mean of n_expl for each joint)
% no tasks distinctions
n_expl_mean_h	= zeros(10,1);	% mean of the number of first fPCs needed to explain at least threshold (thr_var) % of the movement for healthy subjects
n_expl_mean_la	= zeros(10,1);	% mean of the number of first fPCs needed to explain at least threshold (thr_var) % of the movement for less affected subjects
n_expl_mean_s	= zeros(10,1);	% mean of the number of first fPCs needed to explain at least threshold (thr_var) % of the movement for strokes subjects

% separate into 3 task groups
% intransitive tasks
n_expl_mean_int_h	= zeros(10,1);	% mean of the number of first fPCs needed to explain at least threshold (thr_var) % of the movement for healthy subjects
n_expl_mean_int_la	= zeros(10,1);	% mean of the number of first fPCs needed to explain at least threshold (thr_var) % of the movement for less affected subjects
n_expl_mean_int_s	= zeros(10,1);	% mean of the number of first fPCs needed to explain at least threshold (thr_var) % of the movement for strokes subjects

% transitive tasks
n_expl_mean_tr_h	= zeros(10,1);	% mean of the number of first fPCs needed to explain at least threshold (thr_var) % of the movement for healthy subjects
n_expl_mean_tr_la	= zeros(10,1);	% mean of the number of first fPCs needed to explain at least threshold (thr_var) % of the movement for less affected subjects
n_expl_mean_tr_s	= zeros(10,1);	% mean of the number of first fPCs needed to explain at least threshold (thr_var) % of the movement for strokes subjects

% tool mediated tasks
n_expl_mean_tm_h	= zeros(10,1);	% mean of the number of first fPCs needed to explain at least threshold (thr_var) % of the movement for healthy subjects
n_expl_mean_tm_la	= zeros(10,1);	% mean of the number of first fPCs needed to explain at least threshold (thr_var) % of the movement for less affected subjects
n_expl_mean_tm_s	= zeros(10,1);	% mean of the number of first fPCs needed to explain at least threshold (thr_var) % of the movement for strokes subjects

% mean among all joints
n_expl_mean_tj_h	= 0;
n_expl_mean_tj_la	= 0;
n_expl_mean_tj_s	= 0;

%% slope vectors
	% healthy
	% less affected
	% strokes

% no tasks distinctions
slope_h		= zeros(30*10,1);	% slope of the variance associated with first n fPCs needed to overcome the threshold (thr_var) % of the movement for healthy subjects
slope_la	= zeros(30*10,1);	% slope of the variance associated with first n fPCs needed to overcome the threshold (thr_var) % of the movement for less affected subjects
slope_s		= zeros(30*10,1);	% slope of the variance associated with first n fPCs needed to overcome the threshold (thr_var) % of the movement for strokes subjects

% separate into 3 task groups
% intransitive tasks
slope_int_h		= zeros(10*10,1);	% slope of the variance associated with first n fPCs needed to overcome the threshold (thr_var) % of the movement for healthy subjects
slope_int_la	= zeros(10*10,1);	% slope of the variance associated with first n fPCs needed to overcome the threshold (thr_var) % of the movement for less affected subjects
slope_int_s		= zeros(10*10,1);	% slope of the variance associated with first n fPCs needed to overcome the threshold (thr_var) % of the movement for strokes subjects

% transitive tasks
slope_tr_h		= zeros(10*10,1);	% slope of the variance associated with first n fPCs needed to overcome the threshold (thr_var) % of the movement for healthy subjects
slope_tr_la		= zeros(10*10,1);	% slope of the variance associated with first n fPCs needed to overcome the threshold (thr_var) % of the movement for less affected subjects
slope_tr_s		= zeros(10*10,1);	% slope of the variance associated with first n fPCs needed to overcome the threshold (thr_var) % of the movement for strokes subjects

% tool mediated tasks
slope_tm_h		= zeros(10*10,1);	% slope of the variance associated with first n fPCs needed to overcome the threshold (thr_var) % of the movement for healthy subjects
slope_tm_la		= zeros(10*10,1);	% slope of the variance associated with first n fPCs needed to overcome the threshold (thr_var) % of the movement for less affected subjects
slope_tm_s		= zeros(10*10,1);	% slope of the variance associated with first n fPCs needed to overcome the threshold (thr_var) % of the movement for strokes subjects

%% slope_mean vectors (mean of n_expl for each joint)
% no tasks distinctions
slope_mean_h	= zeros(10,1);	
slope_mean_la	= zeros(10,1);	
slope_mean_s	= zeros(10,1);	

% separate into 3 task groups
% intransitive tasks
slope_mean_int_h	= zeros(10,1);	
slope_mean_int_la	= zeros(10,1);	
slope_mean_int_s	= zeros(10,1);	

% transitive tasks
slope_mean_tr_h		= zeros(10,1);	
slope_mean_tr_la	= zeros(10,1);	
slope_mean_tr_s		= zeros(10,1);	

% tool mediated tasks
slope_mean_tm_h		= zeros(10,1);	
slope_mean_tm_la	= zeros(10,1);	
slope_mean_tm_s		= zeros(10,1);	

% mean among all joints
slope_mean_tj_h		= 0;
slope_mean_tj_la	= 0;
slope_mean_tj_s		= 0;

%% fill var and var_mean vectors

for i = 1:30 % number of tasks
	ii = (i-1)*10;
	for j = 1:10 % number of joints
		var_tmp_h	= fPCA_task(i).h_joint(j).var(1:3);
		var_tmp_la	= fPCA_task(i).la_joint(j).var(1:3);
		var_tmp_s	= fPCA_task(i).s_joint(j).var(1:3);
		
		%var vectors
		var_h1(ii+j)	= var_tmp_h(1);
		var_la1(ii+j)	= var_tmp_la(1);
		var_s1(ii+j)	= var_tmp_s(1);
		
		var_h2(ii+j)	= var_tmp_h(2);
		var_la2(ii+j)	= var_tmp_la(2);
		var_s2(ii+j)	= var_tmp_s(2);
		
		var_h3(ii+j)	= var_tmp_h(3);
		var_la3(ii+j)	= var_tmp_la(3);
		var_s3(ii+j)	= var_tmp_s(3);
		
		%var mean
		var_mean_h1(j)	= var_mean_h1(j) + fPCA_task(i).h_joint(j).var(1)/30;
		var_mean_la1(j) = var_mean_la1(j) + fPCA_task(i).la_joint(j).var(1)/30;
		var_mean_s1(j)	= var_mean_s1(j) + fPCA_task(i).s_joint(j).var(1)/30;
		
		var_mean_h2(j)	= var_mean_h2(j) + fPCA_task(i).h_joint(j).var(2)/30;
		var_mean_la2(j) = var_mean_la2(j) + fPCA_task(i).la_joint(j).var(2)/30;
		var_mean_s2(j)	= var_mean_s2(j) + fPCA_task(i).s_joint(j).var(2)/30;
		
		var_mean_h3(j)	= var_mean_h3(j) + fPCA_task(i).h_joint(j).var(3)/30;
		var_mean_la3(j) = var_mean_la3(j) + fPCA_task(i).la_joint(j).var(3)/30;
		var_mean_s3(j)	= var_mean_s3(j) + fPCA_task(i).s_joint(j).var(3)/30;
		
		if i<11
			var_mean_int_h1(j)	= var_mean_int_h1(j) + fPCA_task(i).h_joint(j).var(1)/10;
			var_mean_int_la1(j) = var_mean_int_la1(j) + fPCA_task(i).la_joint(j).var(1)/10;
			var_mean_int_s1(j)	= var_mean_int_s1(j) + fPCA_task(i).s_joint(j).var(1)/10;

			var_mean_int_h2(j)	= var_mean_int_h2(j) + fPCA_task(i).h_joint(j).var(2)/10;
			var_mean_int_la2(j) = var_mean_int_la2(j) + fPCA_task(i).la_joint(j).var(2)/10;
			var_mean_int_s2(j)	= var_mean_int_s2(j) + fPCA_task(i).s_joint(j).var(2)/10;

			var_mean_int_h3(j)	= var_mean_int_h3(j) + fPCA_task(i).h_joint(j).var(3)/10;
			var_mean_int_la3(j) = var_mean_int_la3(j) + fPCA_task(i).la_joint(j).var(3)/10;
			var_mean_int_s3(j)	= var_mean_int_s3(j) + fPCA_task(i).s_joint(j).var(3)/10;
			
		elseif i<21 && i >10
			var_mean_tr_h1(j)	= var_mean_tr_h1(j) + fPCA_task(i).h_joint(j).var(1)/10;
			var_mean_tr_la1(j)	= var_mean_tr_la1(j) + fPCA_task(i).la_joint(j).var(1)/10;
			var_mean_tr_s1(j)	= var_mean_tr_s1(j) + fPCA_task(i).s_joint(j).var(1)/10;

			var_mean_tr_h2(j)	= var_mean_tr_h2(j) + fPCA_task(i).h_joint(j).var(2)/10;
			var_mean_tr_la2(j)	= var_mean_tr_la2(j) + fPCA_task(i).la_joint(j).var(2)/10;
			var_mean_tr_s2(j)	= var_mean_tr_s2(j) + fPCA_task(i).s_joint(j).var(2)/10;

			var_mean_tr_h3(j)	= var_mean_tr_h3(j) + fPCA_task(i).h_joint(j).var(3)/10;
			var_mean_tr_la3(j)  = var_mean_tr_la3(j) + fPCA_task(i).la_joint(j).var(3)/10;
			var_mean_tr_s3(j)	= var_mean_tr_s3(j) + fPCA_task(i).s_joint(j).var(3)/10;
			
		elseif i<31 && i >20
			var_mean_tm_h1(j)	= var_mean_tm_h1(j) + fPCA_task(i).h_joint(j).var(1)/10;
			var_mean_tm_la1(j)	= var_mean_tm_la1(j) + fPCA_task(i).la_joint(j).var(1)/10;
			var_mean_tm_s1(j)	= var_mean_tm_s1(j) + fPCA_task(i).s_joint(j).var(1)/10;

			var_mean_tm_h2(j)	= var_mean_tm_h2(j) + fPCA_task(i).h_joint(j).var(2)/10;
			var_mean_tm_la2(j)	= var_mean_tm_la2(j) + fPCA_task(i).la_joint(j).var(2)/10;
			var_mean_tm_s2(j)	= var_mean_tm_s2(j) + fPCA_task(i).s_joint(j).var(2)/10;

			var_mean_tm_h3(j)	= var_mean_tm_h3(j) + fPCA_task(i).h_joint(j).var(3)/10;
			var_mean_tm_la3(j)  = var_mean_tm_la3(j) + fPCA_task(i).la_joint(j).var(3)/10;
			var_mean_tm_s3(j)	= var_mean_tm_s3(j) + fPCA_task(i).s_joint(j).var(3)/10;
		end
	end
end

% separated into 3 tasks groups
% first: int (intransitive)
indexes = 1:(10*10);
var_int_h1	= var_h1(indexes);	
var_int_la1 = var_la1(indexes);		
var_int_s1	= var_s1(indexes);	

var_int_h2	= var_h2(indexes);	
var_int_la2 = var_la2(indexes);	
var_int_s2	= var_s2(indexes);

var_int_h3	= var_h3(indexes);	
var_int_la3 = var_la3(indexes);	
var_int_s3	= var_s3(indexes);

% second: tr (transitive)
indexes = (10*10+1):(20*10);
var_tr_h1	= var_h1(indexes);	
var_tr_la1	= var_la1(indexes);		
var_tr_s1	= var_s1(indexes);	

var_tr_h2	= var_h2(indexes);	
var_tr_la2	= var_la2(indexes);	
var_tr_s2	= var_s2(indexes);

var_tr_h3	= var_h3(indexes);	
var_tr_la3	= var_la3(indexes);	
var_tr_s3	= var_s3(indexes); 

% third: tm (tool mediated)
indexes = (20*10+1):(30*10);
var_tm_h1	= var_h1(indexes);	
var_tm_la1	= var_la1(indexes);		
var_tm_s1	= var_s1(indexes);	

var_tm_h2	= var_h2(indexes);	
var_tm_la2	= var_la2(indexes);	
var_tm_s2	= var_s2(indexes);

var_tm_h3	= var_h3(indexes);	
var_tm_la3	= var_la3(indexes);	
var_tm_s3	= var_s3(indexes); 

%% evaluate n_expl

thr_var = 0.9;
nfpc_used = 11;

for i = 1:30 % number of tasks
	ii = (i-1)*10;
	for j = 1:10 % number of joints
		%healthy
		sums_tmp_h	= cumsum(fPCA_task(i).h_joint(j).var);
		index_tmp_h = find(sums_tmp_h > thr_var, 1 ); 
		%temporary index to store how many fPCs we have to sum to reach thr_var
		if isempty(index_tmp_h)
			index_tmp_h = nfpc_used;
		end
		
		%less affected
		sums_tmp_la	= cumsum(fPCA_task(i).la_joint(j).var);
		index_tmp_la = find(sums_tmp_la > thr_var, 1 ); 
		if isempty(index_tmp_la)
			index_tmp_la = nfpc_used;
		end
		
		%stroke
		sums_tmp_s	= cumsum(fPCA_task(i).s_joint(j).var);
		index_tmp_s = find(sums_tmp_s > thr_var, 1 ); 
		if isempty(index_tmp_s)
			index_tmp_s = nfpc_used;
		end
		
		% no task group distinctions
		n_expl_h(ii+j)  = index_tmp_h;
		n_expl_la(ii+j) = index_tmp_la;
		n_expl_s(ii+j)  = index_tmp_s;
		
		% with task group distinctions
		task_group = floor((i-1)/10) + 1; % 1 for int, 2 for tr, 3 for tm
		jj = j + (i - 10*(task_group - 1) - 1)* 10;
		if task_group == 1
			n_expl_int_h(jj)	= index_tmp_h;
			n_expl_int_la(jj)	= index_tmp_la;
			n_expl_int_s(jj)	= index_tmp_s;
			
		elseif task_group == 2
			n_expl_tr_h(jj)		= index_tmp_h;
			n_expl_tr_la(jj)	= index_tmp_la;
			n_expl_tr_s(jj)		= index_tmp_s;
			
		elseif task_group == 3
			n_expl_tm_h(jj)		= index_tmp_h;
			n_expl_tm_la(jj)	= index_tmp_la;
			n_expl_tm_s(jj)		= index_tmp_s;
		end

	end
end

% mean
for j = 1:10
	% no tasks distinctions
	n_expl_mean_h(j)	= mean(n_expl_h(j:10:end));	
	n_expl_mean_la(j)	= mean(n_expl_la(j:10:end));	
	n_expl_mean_s(j)	= mean(n_expl_s(j:10:end));	

	% separate into 3 task groups
	% intransitive tasks
	n_expl_mean_int_h(j)	= mean(n_expl_int_h(j:10:end));	 
	n_expl_mean_int_la(j)	= mean(n_expl_int_la(j:10:end));	
	n_expl_mean_int_s(j)	= mean(n_expl_int_s(j:10:end));		

	% transitive tasks
	n_expl_mean_tr_h(j)		= mean(n_expl_tr_h(j:10:end));	 
	n_expl_mean_tr_la(j)	= mean(n_expl_tr_la(j:10:end));	 
	n_expl_mean_tr_s(j)		= mean(n_expl_tr_s(j:10:end));	 

	% tool mediated tasks
	n_expl_mean_tm_h(j)		= mean(n_expl_tm_h(j:10:end));	 
	n_expl_mean_tm_la(j)	= mean(n_expl_tm_la(j:10:end));	 
	n_expl_mean_tm_s(j)		= mean(n_expl_tm_s(j:10:end));	 
end

% mean among all joints
n_expl_mean_tj_h	= mean(n_expl_h);
n_expl_mean_tj_la	= mean(n_expl_la);
n_expl_mean_tj_s	= mean(n_expl_s);

%% evaluate slope 

for i = 1:30 % number of tasks
	ii = (i-1)*10;
	for j = 1:10 % number of joints
		%healthy
		var_h = fPCA_task(i).h_joint(j).var;
		sums_tmp_h	= cumsum(var_h);
		index_tmp_h = find(sums_tmp_h > thr_var, 1 ); 
		%temporary index to store how many fPCs we have to sum to reach thr_var
		if isempty(index_tmp_h)
			index_tmp_h = nfpc_used;
		elseif index_tmp_h == 1
			index_tmp_h = 2;
		end
		
		slope_tmp_h = polyfit(1:index_tmp_h, var_h(1:index_tmp_h),1);
		slope_tmp_h = slope_tmp_h(1);
		
		%less affected
		var_la = fPCA_task(i).la_joint(j).var;
		sums_tmp_la	= cumsum(var_la);
		index_tmp_la = find(sums_tmp_la > thr_var, 1 ); 
		
		if isempty(index_tmp_la)
			index_tmp_la = nfpc_used;
		elseif index_tmp_la == 1
			index_tmp_la = 2;
		end
		
		slope_tmp_la = polyfit(1:index_tmp_la, var_la(1:index_tmp_la),1);
		slope_tmp_la = slope_tmp_la(1);
		
		%stroke
		var_s = fPCA_task(i).s_joint(j).var;
		sums_tmp_s	= cumsum(var_s);
		index_tmp_s = find(sums_tmp_s > thr_var, 1 ); 
		
		if isempty(index_tmp_s)
			index_tmp_s = nfpc_used;
		elseif index_tmp_s == 1
			index_tmp_s = 2;
		end
		
		slope_tmp_s = polyfit(1:index_tmp_s, var_s(1:index_tmp_s),1);
		slope_tmp_s = slope_tmp_s(1);
		
		% no task group distinctions
		slope_h(ii+j)  = slope_tmp_h;
		slope_la(ii+j) = slope_tmp_la;
		slope_s(ii+j)  = slope_tmp_s;
		
		% with task group distinctions
		task_group = floor((i-1)/10) + 1; % 1 for int, 2 for tr, 3 for tm
		jj = j + (i - 10*(task_group - 1) - 1)* 10;
		if task_group == 1
			slope_int_h(jj)	= slope_tmp_h;
			slope_int_la(jj)= slope_tmp_la;
			slope_int_s(jj)	= slope_tmp_s;
			
		elseif task_group == 2
			slope_tr_h(jj)	= slope_tmp_h;
			slope_tr_la(jj)	= slope_tmp_la;
			slope_tr_s(jj)	= slope_tmp_s;
			
		elseif task_group == 3
			slope_tm_h(jj)	= slope_tmp_h;
			slope_tm_la(jj)	= slope_tmp_la;
			slope_tm_s(jj)	= slope_tmp_s;
		end

	end
end
for j = 1:10
	% no tasks distinctions
	slope_mean_h(j)	= mean(slope_h(j:10:end));	
	slope_mean_la(j)= mean(slope_la(j:10:end));	
	slope_mean_s(j)	= mean(slope_s(j:10:end));	
	
	% separate into 3 task groups
	% intransitive tasks
	slope_mean_int_h(j)	= mean(slope_int_h(j:10:end));	
	slope_mean_int_la(j)= mean(slope_int_la(j:10:end));	
	slope_mean_int_s(j)	= mean(slope_int_s(j:10:end));	

	% transitive tasks
	slope_mean_tr_h(j)	= mean(slope_tr_h(j:10:end));	
	slope_mean_tr_la(j)	= mean(slope_tr_la(j:10:end));	
	slope_mean_tr_s(j)	= mean(slope_tr_s(j:10:end));		

	% tool mediated tasks
	slope_mean_tm_h(j)	= mean(slope_tm_h(j:10:end));	
	slope_mean_tm_la(j)	= mean(slope_tm_la(j:10:end));		
	slope_mean_tm_s(j)	= mean(slope_tm_s(j:10:end));	

end
% mean among all joints
	slope_mean_tj_h	= mean(slope_h);
	slope_mean_tj_la= mean(slope_la);
	slope_mean_tj_s	= mean(slope_s);