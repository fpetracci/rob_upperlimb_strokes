%% analysis of fpca_subj struct

check = exist("fPCA_subj");
if check ~= 1 % return 1 if a variable is in the workspace
	fpca_subj_RUNME
end
%% all healthy, all stroke, all less affected
% healthy
var_h1 = zeros(5*10,1);
var_h2 = zeros(5*10,1);
var_h3 = zeros(5*10,1);
for nsubj = 1:5
	ii = (nsubj-1)*10;
	for j = 1:10
		var_h1(ii+j) = fPCA_subj(nsubj).h_joint(j).var(1);
		var_h2(ii+j) = fPCA_subj(nsubj).h_joint(j).var(2);
		var_h3(ii+j) = fPCA_subj(nsubj).h_joint(j).var(3);
	end
end

% less affected & strokes
var_la1 = zeros(19*10,1);
var_la2 = zeros(19*10,1);
var_la3 = zeros(19*10,1);
var_s1 = zeros(19*10,1);
var_s2 = zeros(19*10,1);
var_s3 = zeros(19*10,1);
for nsubj = 6:24
	nsubj_s = nsubj - 5;
	ii = (nsubj_s-1)*10;
	for j = 1:10
		var_s1(ii+j) = fPCA_subj(nsubj).s_joint(j).var(1);
		var_s2(ii+j) = fPCA_subj(nsubj).s_joint(j).var(2);
		var_s3(ii+j) = fPCA_subj(nsubj).s_joint(j).var(3);
		
		var_la1(ii+j) = fPCA_subj(nsubj).la_joint(j).var(1);
		var_la2(ii+j) = fPCA_subj(nsubj).la_joint(j).var(2);
		var_la3(ii+j) = fPCA_subj(nsubj).la_joint(j).var(3);
		
	end
end

%% 

var_subj1 = zeros(10,1)


%% our tests
clc
disp('first')
[mean(var_h1) var(var_h1)]
[mean(var_s1) var(var_s1)]
[mean(var_la1) var(var_la1)]
disp('second')
[mean(var_h2) var(var_h2)]
[mean(var_s2) var(var_s2)]
[mean(var_la2) var(var_la2)]
disp('third')
[mean(var_h3) var(var_h3)]
[mean(var_s3) var(var_s3)]
[mean(var_la3) var(var_la3)]

