%% anovan
check = exist("q_stacked_task");
if check ~= 1 % return 1 if a variable is in the workspace
	fpca_RUNME
end
var_vect_pc1 = zeros(30*10*2,1);
var_sum_h = zeros(10,1);
var_sum_s = zeros(10,1);
for i = 1:30
	ii = (i-1)*10;
	for j = 1:10
		var_tmp_h = fPCA_task(i).h_joint(j).var(1);
		var_tmp_s = fPCA_task(i).s_joint(j).var(1);
		var_vect_pc1(ii+j) = var_tmp_h;
		var_vect_pc1(30*10+ii+j) = var_tmp_s;
		var_sum_h(j) = var_sum_h(j) + fPCA_task(i).h_joint(j).var(1);
		var_sum_s(j) = var_sum_s(j) + fPCA_task(i).s_joint(j).var(1);
	end
end
var_sum_h = var_sum_h/30;
var_sum_s = var_sum_s/30;
var_sum = [var_sum_h ;var_sum_h];

% anovan with sum of variance
g1 = [ones(10,1); zeros(10,1)]; % healthy 1 stroke 0
p1 = anovan(var_sum,{g1});
%% anovan with division of task and joint 
% length4 = length(var_vect_pc1)/4;
% var_vect_pc1_Rielab = [var_vect_pc1(1:length4,1);var_vect_pc1(2*length4 + 1:3*length4,1);...
% 					   var_vect_pc1(length4 + 1:2*length4,1); var_vect_pc1(3*length4 + 1:4*length4,1)];
% 
%  g1 = [ones(15*10,1); zeros(15*10,1)]; % healthy
%  g2 = [3*ones(15*10,1); 2*ones(15*10,1)]; % stroke
%  
%  [P,n,stat]=anovan(var_vect_pc1_Rielab,{[g1;g1]  },'model','full');
%% 1 anovan comparing H/S and joint and anova1 for only H/S

g1 = [ones(30*10,1); zeros(30*10,1)]; % healthy 1 stroke 0
g2 = zeros(600,1); % task

 for ntask = 1:30
	g2((ntask-1)*10+1:ntask*10,1) = [ntask * ones(10,1)];
	g2((ntask+30-1)*10+1:(ntask+30)*10,1) = [ntask * ones(10,1)];
 end
 
 g3_prova = repmat(linspace(1,10,10),60);
 g3 = g3_prova(1,:)'; %joint
% [h,p] = ttest2(var_vect_pc1(1:300),var_vect_pc1(301:600))
[p,tbl,stats] = anovan(var_vect_pc1,{g1,g3});
 multcompare(stats,'Dimension',[1 2]);
%anova1
[p,tbl,stats] = anova1([var_vect_pc1(1:300),var_vect_pc1(301:600)]);
porcoDio1 = var_vect_pc1(1:300);
porcoDio2 = var_vect_pc1(301:600);
 multcompare(stats,'Dimension',[1 2]);
 

%% 3 anovan one for each goup of task

%first group
var_vect_pc1_first =	[var_vect_pc1(1:100,1); var_vect_pc1(301:400,1)];
%second group
var_vect_pc1_second =	[var_vect_pc1(101:200,1); var_vect_pc1(401:500,1)];
%third group
var_vect_pc1_third =	[var_vect_pc1(201:300,1); var_vect_pc1(501:600,1)];

%check if anova is correct doing mean and std of each joint 
for i = 1:10
	joint1(i) = var_vect_pc1_third((i-1)*10+1);
	joint2(i) = var_vect_pc1_third((i-1)*10+2);
	joint3(i) = var_vect_pc1_third((i-1)*10+3);
	joint4(i) = var_vect_pc1_third((i-1)*10+4);
	joint5(i) = var_vect_pc1_third((i-1)*10+5);
	joint6(i) = var_vect_pc1_third((i-1)*10+6);
	joint7(i) = var_vect_pc1_third((i-1)*10+7);
	joint8(i) = var_vect_pc1_third((i-1)*10+8);
	joint9(i) = var_vect_pc1_third((i-1)*10+9);
	joint10(i) = var_vect_pc1_third((i-1)*10+10);
end
for i = 11:20
	joint1_s(i-10) = var_vect_pc1_third((i-1)*10+1);
	joint2_s(i-10) = var_vect_pc1_third((i-1)*10+2);
	joint3_s(i-10) = var_vect_pc1_third((i-1)*10+3);
	joint4_s(i-10) = var_vect_pc1_third((i-1)*10+4);
	joint5_s(i-10) = var_vect_pc1_third((i-1)*10+5);
	joint6_s(i-10) = var_vect_pc1_third((i-1)*10+6);
	joint7_s(i-10) = var_vect_pc1_third((i-1)*10+7);
	joint8_s(i-10) = var_vect_pc1_third((i-1)*10+8);
	joint9_s(i-10) = var_vect_pc1_third((i-1)*10+9);
	joint10_s(i-10) = var_vect_pc1_third((i-1)*10+10);
end
media1 = [mean(joint1) mean(joint1_s) std(joint1) std(joint1_s)];
media2 = [mean(joint2) mean(joint2_s) std(joint2) std(joint2_s)];
media3 = [mean(joint3) mean(joint3_s) std(joint3) std(joint3_s)];
media4 = [mean(joint4) mean(joint4_s) std(joint4) std(joint4_s)];
media5 = [mean(joint5) mean(joint5_s) std(joint5) std(joint5_s)];
media6 = [mean(joint6) mean(joint6_s) std(joint6) std(joint6_s)];
media7 = [mean(joint7) mean(joint7_s) std(joint7) std(joint7_s)];
media8 = [mean(joint8) mean(joint8_s) std(joint8) std(joint8_s)];
media9 = [mean(joint9) mean(joint9_s) std(joint9) std(joint9_s)];
media10 = [mean(joint10) mean(joint10_s) std(joint10) std(joint10_s)];

g1 = [ones(10*10,1); zeros(10*10,1)]; % healthy 1 stroke 0

g2_prova = repmat(linspace(1,10,10),20);
g2 = g2_prova(1,:)'; %joint

% [h,p] = ttest2(var_vect_pc1(1:300),var_vect_pc1(301:600))
[p,tbl,stats1] = anovan(var_vect_pc1_first,{g1,g2});
multcompare(stats1,'Dimension',[1 2]);

[p,tbl,stats2] = anovan(var_vect_pc1_second,{g1,g2});
multcompare(stats2,'Dimension',[1 2]);
 
[p,tbl,stats3] = anovan(var_vect_pc1_third,{g1,g2});
multcompare(stats3,'Dimension',[1 2]);

