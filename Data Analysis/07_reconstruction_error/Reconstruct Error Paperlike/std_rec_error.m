function data = std_rec_error
% mean variance for H, LA and S, if no input

% here we want to summarize results of the entire data set into a sigle
% data information. We do that by computing mean and variance (std) of the
% reconstruction error of H, LA and S to evaluate if they correspond to our
% hypoteses. 

% We should also try doing that with subpopulation (impairment >=..., D and
% F and so on)


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

%% mean
% healthy
mean_E_h_3		=  mean(E_h_3,1);
mean_E_h_7		=  mean(E_h_7,1);
mean_E_h_10		=  mean(E_h_10,1);

% D
mean_E_D_s_3	= mean(E_subj3(subj_D - 5,:,2),1);
mean_E_D_s_7	= mean(E_subj7(subj_D - 5,:,2),1);
mean_E_D_s_10	= mean(E_subj10(subj_D - 5,:,2),1);

mean_E_D_la_3	= mean(E_subj3(subj_D - 5,:,1),1);
mean_E_D_la_7	= mean(E_subj7(subj_D - 5,:,1),1);
mean_E_D_la_10	= mean(E_subj10(subj_D - 5,:,1),1);

% F
mean_E_F_s_3	= mean(E_subj3(subj_F - 5,:,2),1);
mean_E_F_s_7	= mean(E_subj7(subj_F - 5,:,2),1);
mean_E_F_s_10	= mean(E_subj10(subj_F - 5,:,2),1);

mean_E_F_la_3	= mean(E_subj3(subj_F - 5,:,1),1);
mean_E_F_la_7	= mean(E_subj7(subj_F - 5,:,1),1);
mean_E_F_la_10	= mean(E_subj10(subj_F - 5,:,1),1);

% all poststroke subjects
mean_E_s_3		= mean(E_subj3(:,:,2),1);
mean_E_s_7		= mean(E_subj7(:,:,2),1);
mean_E_s_10		= mean(E_subj10(:,:,2),1);

mean_E_la_3		= mean(E_subj3(:,:,1),1);
mean_E_la_7		= mean(E_subj7(:,:,1),1);
mean_E_la_10	= mean(E_subj10(:,:,1),1);



%% std
% healthy
std_E_h_3		=  std(E_h_3);
std_E_h_7		=  std(E_h_7);
std_E_h_10		=  std(E_h_10);

% D
std_E_D_s_3		= std(E_subj3(subj_D - 5,:,2));
std_E_D_s_7		= std(E_subj7(subj_D - 5,:,2));
std_E_D_s_10	= std(E_subj10(subj_D - 5,:,2));

std_E_D_la_3	= std(E_subj3(subj_D - 5,:,1));
std_E_D_la_7	= std(E_subj7(subj_D - 5,:,1));
std_E_D_la_10	= std(E_subj10(subj_D - 5,:,1));

% F
std_E_F_s_3		= std(E_subj3(subj_F - 5,:,2));
std_E_F_s_7		= std(E_subj7(subj_F - 5,:,2));
std_E_F_s_10	= std(E_subj10(subj_F - 5,:,2));

std_E_F_la_3	= std(E_subj3(subj_F - 5,:,1));
std_E_F_la_7	= std(E_subj7(subj_F - 5,:,1));
std_E_F_la_10	= std(E_subj10(subj_F - 5,:,1));

% all poststroke subjects
std_E_s_3		= std(E_subj3(:,:,2));
std_E_s_7		= std(E_subj7(:,:,2));
std_E_s_10		= std(E_subj10(:,:,2));

std_E_la_3		= std(E_subj3(:,:,1));
std_E_la_7		= std(E_subj7(:,:,1));
std_E_la_10		= std(E_subj10(:,:,1));

%% output struct
lowlevel_struct = struct;
lowlevel_struct.j3 = struct;
lowlevel_struct.j7 = struct;
lowlevel_struct.j10 = struct;

data = struct;
data.H = lowlevel_struct;
data.S = lowlevel_struct;
data.D = lowlevel_struct;
data.F = lowlevel_struct;


%healhy
data.H.j3.mean  = mean_E_h_3;
data.H.j7.mean  = mean_E_h_7;
data.H.j10.mean = mean_E_h_10;

data.H.j3.std  = std_E_h_3;
data.H.j7.std  = std_E_h_7;
data.H.j10.std = std_E_h_10;

% stroke
%s
data.S.j3.s_mean  = mean_E_s_3;
data.S.j7.s_mean  = mean_E_s_7;
data.S.j10.s_mean = mean_E_s_10;

data.S.j3.s_std  = std_E_s_3;
data.S.j7.s_std  = std_E_s_7;
data.S.j10.s_std = std_E_s_10;

%la
data.S.j3.la_mean  = mean_E_la_3;
data.S.j7.la_mean  = mean_E_la_7;
data.S.j10.la_mean = mean_E_la_10;

data.S.j3.la_std  = std_E_la_3;
data.S.j7.la_std  = std_E_la_7;
data.S.j10.la_std = std_E_la_10;

% D - dominant stroke
data.D.FMMA		= subj_D_FMMA;
%s
data.D.j3.s_mean  = mean_E_D_s_3;
data.D.j7.s_mean  = mean_E_D_s_7;
data.D.j10.s_mean = mean_E_D_s_10;

data.D.j3.s_std  = std_E_D_s_3;
data.D.j7.s_std  = std_E_D_s_7;
data.D.j10.s_std = std_E_D_s_10;

%la
data.D.j3.la_mean  = mean_E_D_la_3;
data.D.j7.la_mean  = mean_E_D_la_7;
data.D.j10.la_mean = mean_E_D_la_10;

data.D.j3.la_std  = std_E_D_la_3;
data.D.j7.la_std  = std_E_D_la_7;
data.D.j10.la_std = std_E_D_la_10;

% F - non dominant stroke
data.F.FMMA		= subj_F_FMMA;
%s
data.F.j3.s_mean  = mean_E_F_s_3;
data.F.j7.s_mean  = mean_E_F_s_7;
data.F.j10.s_mean = mean_E_F_s_10;

data.F.j3.s_std  = std_E_F_s_3;
data.F.j7.s_std  = std_E_F_s_7;
data.F.j10.s_std = std_E_F_s_10;

%la
data.F.j3.la_mean  = mean_E_F_la_3;
data.F.j7.la_mean  = mean_E_F_la_7;
data.F.j10.la_mean = mean_E_F_la_10;

data.F.j3.la_std  = std_E_F_la_3;
data.F.j7.la_std  = std_E_F_la_7;
data.F.j10.la_std = std_E_F_la_10;


end