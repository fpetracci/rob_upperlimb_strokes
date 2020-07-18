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

%% analysis of pc1
y1 = var1;
y2 = var2;
y3 = var3;
y  = var;
ys =var_sum;

G = {task, joint, subject};
G_t = {repmat(task,1,3), repmat(joint,1,3), repmat(subject,1,3)};

[p1,~,stats1] = anovan(y1,G);
multcompare(stats1,'Dimension',[1 2]);

[p2,~,stats2] = anovan(y2,G);
multcompare(stats2,'Dimension',[1 2]);

[p3,~,stats3] = anovan(y3,G);
multcompare(stats3,'Dimension',[1 2]);

[p,~,stats] = anovan(y,G_t);
multcompare(stats,'Dimension',[1 2]);

[ps,~,stats] = anovan(ys,G);
multcompare(stats,'Dimension',[1 2]);




