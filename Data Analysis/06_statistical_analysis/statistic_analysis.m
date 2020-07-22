%% generate all necessary vectors and init of anovan
var_def_statistic_analysis;

%% anovan inputs (groups, and 
%set of vectors on which compute anovan evaluations

var1 = [var_h1; var_la1; var_s1];
var2 = [var_h2; var_la2; var_s2];
var3 = [var_h3; var_la3; var_s3];
var  = [var1; var2; var3];
var_sum = var1 + var2 + var3;

n_expl = [n_expl_h; n_expl_la; n_expl_s];

slope = [slope_h; slope_la; slope_s];

%groups definition
i = 1:300;
ii = floor((i-1)/10 +1);
task = repmat(ii,1,3);

joint = repmat((1:10),1,30*3);

subjecth = (repmat("h",300,1));
subjectla = (repmat("la",300,1));
subjects = (repmat("s",300,1));
subject = [subjecth; subjectla; subjects]';

%% analysis of pcs
y1 = var1;
y2 = var2;
y3 = var3;
y  = var;
ys =var_sum;

% G = {task, joint, subject};
G = {subject, joint};
% G_t = {repmat(task,1,3), repmat(joint,1,3), repmat(subject,1,3)};

[p1,~,stats1] = anovan(y1,G, 'model', 'interaction');
figure(2)
multcompare(stats1,'Dimension',[1 2]);

[p2,~,stats2] = anovan(y2,G, 'model', 'interaction');
figure(4)
multcompare(stats2,'Dimension',[1 2]);

[p3,~,stats3] = anovan(y3,G, 'model', 'interaction');
figure(6)
multcompare(stats3,'Dimension',[1 2]);

% [p,~,stats] = anovan(y,G_t);
% multcompare(stats,'Dimension',[1 2]);

% [ps,~,stats] = anovan(ys,G);
% multcompare(stats,'Dimension',[1 2]);

%% analysis of n_expl
close all
y_nexpl = [n_expl_h; n_expl_la; n_expl_s];
[p_nexpl,~,stats_nexpl] = anovan(n_expl,G, 'model', 'interaction');
figure(2)
multcompare(stats_nexpl,'Dimension',[1 2]);

%% inside of type of task
subjecth	= (repmat("h",100,1));
subjectla	= (repmat("la",100,1));
subjects	= (repmat("s",100,1));
subject 	= [subjecth; subjectla; subjects]';

joint = repmat((1:10),1,10*3);

G = {subject, joint};

% intransitive
[p_int_l,~,stats_int_l] = anovan([var_int_h1; var_int_la1; var_int_s1], G, 'model', 'interaction');
figure(2)
multcompare(stats_int_l,'Dimension',[1 2]);

% transitive
[p_tr_l,~,stats_tr_l] = anovan([var_tr_h1; var_tr_la1; var_tr_s1], G, 'model', 'interaction');
figure(4)
multcompare(stats_tr_l,'Dimension',[1 2]);

% tool mediated
[p_tm_l,~,stats_tm_l] = anovan([var_tm_h1; var_tm_la1; var_tm_s1], G, 'model', 'interaction');
figure(6)
multcompare(stats_tm_l,'Dimension',[1 2]);


%% ttest

[h_stats1,pvalue_stats1] = ttest(var_tm_h1, var_tm_la1, var_tm_s1)

%% our tests
clear var;
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



