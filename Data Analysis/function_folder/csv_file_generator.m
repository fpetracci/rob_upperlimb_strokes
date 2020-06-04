% This script generates .csv files containting all informations needed
% inside our Mathematica notebook about a single trial.

trial = struct_dataload('H01_T07_L1');
par = par_10R(trial);

hand_pos_L=trial.Hand_L.Pos;
hand_quat_L=trial.Hand_L.Quat;
hand_L = [hand_pos_L,hand_quat_L];

hand_pos_R=trial.Hand_R.Pos;
hand_quat_R=trial.Hand_R.Quat;
hand_R = [hand_pos_R,hand_quat_R];

par_L = [par.L5_pos', par.L5_shoulder.left, par.depth_shoulder.left, par.theta_shoulder.left, par.upperarm.left, par.forearm.left];
par_R = [par.L5_pos', par.L5_shoulder.right, par.depth_shoulder.right, par.theta_shoulder.right, par.upperarm.right, par.forearm.right];

hand_index = ["hand_x_pos","hand_y_pos","hand_z_pos","hand_quat_q","hand_quat_p1","hand_quat_p2","hand_quat_p3"];
par_index = ["L5_pos_x", "L5_pos_y", "L5_pos_z", "L5_shoulder_dist", "depth_shoulder",...
"theta_shoulder", "upperarm_length", "forearm_length"];

writematrix([hand_index; hand_L],'H01_T07_L1_hand_L.csv');
writematrix([hand_index; hand_R],'H01_T07_L1_hand_R.csv');

writematrix([par_index; par_L],'H01_T07_L1_par_L.csv');
writematrix([par_index; par_R],'H01_T07_L1_par_R.csv');

