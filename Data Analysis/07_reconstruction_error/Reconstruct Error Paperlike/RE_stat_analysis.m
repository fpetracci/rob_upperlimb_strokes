%computes all relevant p-values between subjects groups for the 3DoFs, 
%7DoFs and 10DoFs models. These results are also reported in an excel file 
%'recon_error_stat.xlsx'.

%% load

load('E3.mat', 'E_subj3')
load('E7.mat', 'E_subj7')
load('E10.mat', 'E_subj10')
load('E_h_3.mat', 'E_h_3')
load('E_h_7.mat', 'E_h_7')
load('E_h_10.mat', 'E_h_10')

%% selection between dominant side affected and nondom side affected
% with D we indicate that the dominant side is affected
% with F we indicate that the non dominant side is affected

subj_D			=	[7  8  9  11 14 15 19 20 22 23 24];
subj_D_FMMA		=	[55 55 38 47 43 37 61 42 60 46 21];
subj_F			=	[6  10 12 13 16 17 18 21];
subj_F_FMMA		=	[54 41 40 49 53 59 37 48];

%% vectors

% healthy
% mean_E_h_3		=  mean(E_h_3,1);
% mean_E_h_7		=  mean(E_h_7,1);
% mean_E_h_10		=  mean(E_h_10,1);

% D
E_D_s_3	 = E_subj3(subj_D - 5,:,2);
E_D_s_7	 = E_subj7(subj_D - 5,:,2);
E_D_s_10 = E_subj10(subj_D - 5,:,2);

E_D_la_3  = E_subj3(subj_D - 5,:,1);
E_D_la_7  = E_subj7(subj_D - 5,:,1);
E_D_la_10 = E_subj10(subj_D - 5,:,1);

% F
E_F_s_3	 = E_subj3(subj_F - 5,:,2);
E_F_s_7	 = E_subj7(subj_F - 5,:,2);
E_F_s_10 = E_subj10(subj_F - 5,:,2);

E_F_la_3  = E_subj3(subj_F - 5,:,1);
E_F_la_7  = E_subj7(subj_F - 5,:,1);
E_F_la_10 = E_subj10(subj_F - 5,:,1);

%% analysis D vs F

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% STROKE SIDE
% 10 DOF
% 1 fPC between D and F
% ranksum(E_D_s_10(:,1), E_F_s_10(:,1) )
% 0.0506

% 2 fPC between D and F
% ranksum(E_D_s_10(:,2), E_F_s_10(:,2) )
% 0.0328

% 3 fPC between D and F
% ranksum(E_D_s_10(:,3), E_F_s_10(:,3) )
% 0.0121
%-----------
% 3 DOF
% 1 fPC between D and F
% ranksum(E_D_s_3(:,1), E_F_s_3(:,1) )
% 0.3100

% 2 fPC between D and F
% ranksum(E_D_s_3(:,2), E_F_s_3(:,2) )
% 0.4421

% 3 fPC between D and F
% ranksum(E_D_s_3(:,3), E_F_s_3(:,3) )
% 0.5999

%-----------
% 7 DOF
% 1 fPC between D and F
% ranksum(E_D_s_7(:,1), E_F_s_7(:,1) )
% 0.0203

% 2 fPC between D and F
% ranksum(E_D_s_7(:,2), E_F_s_7(:,2) )
% 0.0157

% 3 fPC between D and F
% ranksum(E_D_s_7(:,3), E_F_s_7(:,3) )
% 0.0050

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% LESS AFFECTED SIDE
% 10 DOF
% 1 fPC between D and F
% ranksum(E_D_la_10(:,1), E_F_la_10(:,1) )
% 0.3950

% 2 fPC between D and F
% ranksum(E_D_la_10(:,2), E_F_la_10(:,2) )
% 0.3511

% 3 fPC between D and F
% ranksum(E_D_la_10(:,3), E_F_la_10(:,3) )
% 0.4920
%-----------
% 3 DOF
% 1 fPC between D and F
% ranksum(E_D_la_3(:,1), E_F_la_3(:,1) )
% 0.8404

% 2 fPC between D and F
% ranksum(E_D_la_3(:,2), E_F_la_3(:,2) )
% 0.7168


% 3 fPC between D and F
% ranksum(E_D_la_3(:,3), E_F_la_3(:,3) )
% 0.7780
%-----------
% 7 DOF
% 1 fPC between D and F
% ranksum(E_D_la_7(:,1), E_F_la_7(:,1) )
%  0.3100

% 2 fPC between D and F
% ranksum(E_D_la_7(:,2), E_F_la_7(:,2) )
% 0.2723

% 3 fPC between D and F
% ranksum(E_D_la_7(:,3), E_F_la_7(:,3) )
% 0.3511

%% analysis D vs H LA side
% 10DoF first fPC
% ranksum(E_h_10(:,1), E_D_la_10(:,1)) 
% 0.1804

% 7DoF first fPC
% ranksum(E_h_7(:,1),E_D_la_7(:,1))
%  0.1804

% 3DoF first fPC
% ranksum(E_h_3(:,1),E_D_la_3(:,1))
% 0.3196

%% analysis F vs H
% 10DoF first fPC
% ranksum(E_h_10(:,1),E_F_la_10(:,1)) 
% 0.5237

% 7DoF first fPC
% ranksum(E_h_7(:,1),E_F_la_7(:,1))
%  0.6216


% 3DoF first fPC
% ranksum(E_h_3(:,1),E_F_la_3(:,1))
% 0.1274
%% analysis LA vs A
% 10DoF first fPC
% ranksum(E_subj10(:,1,1),E_subj10(:,1,2)) 
% 0.0923

% 7DoF first fPC
% ranksum(E_subj7(:,1,1),E_subj7(:,1,2)) 
% 0.0749

% 3DoF first fPC
% ranksum(E_subj3(:,1,1),E_subj3(:,1,2)) 
% 0.8381

%% analysis H vs A
% 10DoF first fPC
% ranksum(E_h_10(:,1),E_subj10(:,1,2)) 
% 0.0880

% 7DoF first fPC
% ranksum(E_h_7(:,1),E_subj7(:,1,2))  
% 0.1021

% 3DoF first fPC
% ranksum(E_h_3(:,1),E_subj3(:,1,2)) 
% 0.15



%% analysis H vs LA
% 10DoF first fPC
% ranksum(E_h_10(:,1),E_subj10(:,1,1)) 
% 0.2269

% 7DoF first fPC
% ranksum(E_h_7(:,1),E_subj7(:,1,1))  
%  0.2554

% 3DoF first fPC
% ranksum(E_h_3(:,1),E_subj3(:,1,1)) 
% 0.1551



