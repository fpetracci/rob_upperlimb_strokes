%% anovan

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

%% anovan with sum of variance
g1 = [ones(10,1); zeros(10,1)]; % healthy 1 stroke 0
p1 = anovan(var_sum,{g1});
%% anovan with division of task and joint 
length4 = length(var_vect_pc1)/4;
var_vect_pc1_Rielab = [var_vect_pc1(1:length4,1);var_vect_pc1(2*length4 + 1:3*length4,1);...
					   var_vect_pc1(length4 + 1:2*length4,1); var_vect_pc1(3*length4 + 1:4*length4,1)];

 g1 = [ones(15*10,1); zeros(15*10,1)]; % healthy
 g2 = [3*ones(15*10,1); 2*ones(15*10,1)]; % stroke
 
 [P,n,stat]=anovan(var_vect_pc1_Rielab,{[g1;g1]  },'model','full');
%% 10 anovan one for each joint
length4 = length(var_vect_pc1)/4;
var_vect_pc1_Rielab = [var_vect_pc1(1:length4,1);var_vect_pc1(2*length4 + 1:3*length4,1);...
					   var_vect_pc1(length4 + 1:2*length4,1); var_vect_pc1(3*length4 + 1:4*length4,1)];

g1 = [ones(30*10,1); zeros(30*10,1)]; % healthy 1 stroke 0
g2 = zeros(600,1);

 for ntask = 1:30
	g2((ntask-1)*10+1:ntask*10,1) = [ntask * ones(10,1)];
	g2((ntask+30-1)*10+1:(ntask+30)*10,1) = [ntask * ones(10,1)];
 end
 
 g3_prova = 5*repmat(linspace(1,10,10),60);
 g3 = g3_prova(1,:)';
[P,n,stat]=anovan(var_vect_pc1,{g1 g3},'model','full');