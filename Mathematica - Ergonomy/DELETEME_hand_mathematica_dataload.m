% This script saves the relevant hand data inside a file .mvnx.
% filename should be a char with the file path of the chosen .mvnx file.

%Any file contains hand data of a single task, a single subject and a single
%trial.
filename = 'H01_T07_L1';
struct_mvnx = load_mvnx(filename);

%% In this part is checked which row the data start at

nSamples_plus = length(struct_mvnx.subject.frames.frame);
i = 1;
while isempty(struct_mvnx.subject.frames.frame(i).index)
	skip = i; %number of lines not to be considered since data listed in temporal values ??is not provided
	i = i+1;
end

nSamples = nSamples_plus - skip; % number of sample with temporal values

%% Import files outside tree struct

data = struct; %struct definition
%% Position and quaternions

%Right Hand
segment = 11;
Hand_R_AngVel	= zeros(nSamples,3);
Hand_R_Vel		= zeros(nSamples,3);
%data.Hand_R.Pos		= zeros(nSamples,3);

if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        Hand_R_AngVel(i,:)	= struct_mvnx.subject.frames.frame(i+skip).angularVelocity((segment*3-2):(segment*3));
		Hand_R_Vel(i,:)	= struct_mvnx.subject.frames.frame(i+skip).velocity((segment*3-2):(segment*3));
		%data.Hand_R.Pos(i,:)	= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
	end
end

% data.Hand_R.Quat= zeros(nSamples,4);
% if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
%     for i = 1:nSamples
%         data.Hand_R.Quat(i,:)= struct_mvnx.subject.frames.frame(i+skip).orientation((segment*4-3):(segment*4));
%     end
% end

%Left Hand
segment = 15;
Hand_L_AngVel	= zeros(nSamples,3);
Hand_L_Vel		= zeros(nSamples,3);
%data.Hand_L.Pos		= zeros(nSamples,3);

if isfield(struct_mvnx.subject.frames.frame(1),'position')
    for i = 1:nSamples
        Hand_L_AngVel(i,:)	= struct_mvnx.subject.frames.frame(i+skip).angularVelocity((segment*3-2):(segment*3));
		Hand_L_Vel(i,:)	= struct_mvnx.subject.frames.frame(i+skip).velocity((segment*3-2):(segment*3));
		%data.Hand_L.Pos(i,:)	= struct_mvnx.subject.frames.frame(i+skip).position((segment*3-2):(segment*3));
	end
end

% data.Hand_L.Quat = zeros(nSamples,4);
% if isfield(struct_mvnx.subject.frames.frame(1),'orientation')
%     for i = 1:nSamples
%         data.Hand_L.Quat(i,:) = struct_mvnx.subject.frames.frame(i+skip).orientation((segment*4-3):(segment*4));
%     end
% end
%% ikunc for q0

trial = struct_dataload(filename);
arms = create_arms(trial);

% right
yMeas_EE_rot_r = quat2rotm(trial.Hand_L.Quat(i,:))* Rs210_l;
pos_wrist_meas_r = reshape_data(trial.Hand_L.Pos);
yMeas_EE_pos_r = pos_wrist_meas_r(:,1,1);
TgEE_i_r = rt2tr(yMeas_EE_rot_r, yMeas_EE_pos_r);		
q0_r = arms.right.ikunc(TgEE_i_r);

% left
yMeas_EE_rot_l = quat2rotm(trial.Hand_L.Quat(i,:))* Rs210_l;
pos_wrist_meas_l = reshape_data(trial.Hand_L.Pos);
yMeas_EE_pos_l = pos_wrist_meas_l(:,1,1);
TgEE_i_l = rt2tr(yMeas_EE_rot_l, yMeas_EE_pos_l);		
q0_l = arms.left.ikunc(TgEE_i_l);
q0 = [q0_r; q0_l];

%% save data inside .csv file

header_vel = ["vx", "vy", "vz", "wx", "wy", "wz"];
vel_hand_R = [header_vel ;Hand_R_Vel, Hand_R_AngVel];
vel_hand_L = [header_vel ;Hand_L_Vel, Hand_L_AngVel];

writematrix(q0,			'H01_T07_L1_q0.csv')
writematrix(vel_hand_R, 'H01_T07_L1_hand_vR.csv');
writematrix(vel_hand_L, 'H01_T07_L1_hand_vL.csv');