Folders, Function and Scripts descriptions.
Before running any scripts or function, be sure to run 'startup_data_analysis'

Folders named 'old' contain old function and or scripts that are no longer useful or are not updated.

00_function_folder
	FPCA_Armando		- Folder containing all general fpca functions.
	arm_fkine 		 	- computes the forward kinematic of given Arm and angle joints. The output is the homogenous matrix T given at the n-th joint.
	arm_gen_plot 		- animates a general right arm given q. The parameters of the animated arm come from a chosen trial and are not editable.
	arm_gen_movie		- generates a movie in which a general right arm does the movement with given q as input. It also puts in the scene a hand and a head.
	check_trial			- checks if there are angles in the trial that are out of bounds.
	correct2pi_err 		- removes the pi discontinuity of input angles.
	create_arms 		- given a specific trial, constructs the 10R serial robot representing a human torso-arm.
	fkine_kalman_marker	- This function generates the measurement vector (33x1) for kalman filter. From angular data it computes virtual marker positions to be used with joint measured positions inside the filter correction step.
	fpca2q				- reconstructs the angular joints signal with the first fPCs given the structure cointaining fpca information.
	J_ergo 				- computes the ergonomic functional.
	load_mvnx 			- loads a .mnvx file into the matlab workspace.
	mean_post			- computes the mean posture of rPCs.
	par_10R				- par_10R this function calculates all parameters needed to build the Denavit-Hartenberg table of the 10R arm.
	reshape_data 		- performs a reshape of input by rearranging its dimension as 1:3:2.
	spider_plot (family)- Create a spider or radar plot with individual axes. By Moses Yoo.
	stlread				- load in a matlab figure a .stl file.
	struct_dataload 	- loads the relevant data from the file .mvnx specified.
	subspacea			- computes angles between subspaces. By Andrew Knyazev, Rico Argentati
	unplot 				- delete the most recently created graphics object(s).

00_ukf	
	ukf_correct 		- computes Unscented Kalman filter correction step, using classic Kalman theory.
	ukf_predict			- computes Unscented Kalman filter prediction step.
	ukf_virtmeas 		- computes the virtual measurement y_virt, its covariance and state-y_virt crosscorelation, all used by Unscented Kalman filter.

01_struct
	struct_main			- runs the needed scripts to generate the dataset, specifically: strokes_data.mat and healthy_data.mat.
	struct_creation.m	- initializes the structures of strokes_data and healthy_data.
	struct_population.m	- searches and read all mvnx files with the proper name and populates the structures of strokes_data and healthy_data with the relevant data.

02_Kalman_marker
	script_comparison_between_ukf_ekf 	- executes EKF and UKF for a selected trial and compares their efficiency.
	script_filter_double 				- that executes EKF and used in order to obtain reasonable filter parameters by a 'trial & error' procedure.
	view_marker 						- function that animates markers evolution in time once selected a trial.
	view_marker_with_virt 				- function that animates markers and reconstructed "virtual" marker evolution in time once selected a trial.

03_q
	q_main 			- runs the needed scripts to generate q_task.mat, specifically: q_creation and q_population.
	q_trial2q 		- implements UKF executions and joint angles estimations on a single trial dataset given as input.
	q_creation 		- script to initializes the structures of q_task. It groups data about every subjects involved and tasks executed. 
	q_population		- populates q_task struct with estimated joint angles values from q_trial2q.m and other informations.

04_time_warp
	TimeWarping		- the function take as input 2 joints angle struct, each struct is composed by 10 joint angle. We chosed the 4 th and 7th angular joint as the referement for choose the optimale strech and shift parameters.
	task_warp_compare	- This script aims to compare joint angle.
	warpa_task		- This script is like the main of the folder. Time warping is performed on the entire data_set: q_task.
	new_TW_dot		- Creation of the Data-set:q_task_warped_dot and performed another TimeWarping where only the movement phases are taken into account.
	find_skip		- function that analyzes the derivative of the angles to identify the phase of the movement, only angles 4 and 7 are used as references.
	TW_checking		- plot of the angles deriving from the execution of task number n_task(taken as input) in 2 figures, to show the difference after the application of TW.
05_fPCA
	1subj_at_time - folder in which we analyze the dataset one subject at a time
		fpca_each_subj_plots 			- analysis and plot each subject individually
		fpca_stacker_subj				- trial stacker 1 subj
		fpca_subj						- fpca computation
		loader_subj						- load all subjects' fpca results inside a struct
	
	hdnd - folder in which we analyze the dataset divided into: healthy, stroke dominant (A, LA), stroke non dominant (A, LA)
		fpca_cumsum_hdnd_analysis		- analysis and plots each group, also with cumulative sum explained variance
		fpca_hdnd						- fpca computation
		fpca_stacker_hdnd				- trial stacker
		fpca_var_expl_pareto_like_hdnd	- plots "like pareto" for each group
	
	hsla - folder in which we analyze the dataset divided into: healthy, stroke, less affected
		fpca_cumsum_hsla_analysis 		- analysis and plots each group, also with cumulative sum explained variance
		fpca_hsla						- fpca computation
		fpca_stacker_hsla				- trial stacker
		fpca_var_expl_pareto_like_hsla	- plots "like pareto" for each group
	
	task - folder in which we analyze the dataset one task at a time
		fpca_stacker_task				- trial stacker
		fpca_struct_task				- load all tasks' fpca results inside a struct
		fpca_task						- fpca computation
		
	fpca2q			- reconstructs the first principal components angular joints given the structure cointaining fpca information.
	q_fpca			- computes the first nfpc functional principal components of the given angular joint for the chosen observations. [q] = degree

06_statistical_analysis
	statistic_analysis_subj 	- runs a simple statisticanalysis between the explained variances among healthy, stroke and less affected
	var_def_statistic_analysis	- defines some interesting tools to analyze explained variance patterns
	statistic_analysis			- statistic analysis of all variables defined in var_def_statistic_analysis
	
07_reconstruction_error
	recon_error_matrix			- computation of reconstruction error using only firsts fPCs
	analysis_mean_subjects		- statistical analysis of the reconstruction error for each subjects' groups (h, la, s) by applying Wilcoxon ranksum test.

	Reconstruct Error Paperlike - folder containing alk the relevant scripts used for data analysis and groups comparisons.
		RE_affected_nonaffected_calc	- computes reconstruction error of firsts fPCs of stroke subjects about affected and less affected side (3R, 7R, 10R).
		RE_analysis_PLOTS				- reconstruct error plots, using 3R, 7R, 10R model, for each subject(3R, 7R, 10R) and among all the groups taken into account(dominant/nondominant & stroke/less affected)
		RE_healthy_calc					- computes reconstruction error of firsts fPCs of healthy subjects (3R, 7R, 10R).
		reconstruct_plot				- plots the reconstruction error associated with subject number given as input
		RE_SELECTED_STROKE_POP			- statistical analysis (p-values) of the reconstruction error (on 3DoFs, 7DoFs and 10DoFs) for a selected subset of subjects' groups (h, la, s) by applying Wilcoxon ranksum test
		RE_stat_analysis				- computes all relevant p-values between subjects groups for the 3DoFs, 7DoFs and 10DoFs models. These results are also reported in an excel file 'recon_error_stat.xlsx'.
		std_rec_error					- computes the mean and standard deviation for subjects groups. 

08_rPCA
	1subjattime	- folder in which we analyze the dataset one subject at a time
		rpca_all_subj			- computes rPCA for all subject and stacks them into a single array of structures.
		rPCA_all_subj_RUNME	 	- plots all explained variances of single subject rPCs computed in 'rpca_all_subj'.
		rPCA_means_std			- computes and plots means and standard deviations among h-s-la and h-d-nd of explained variances.
		rpca_stacker_subj		- stacks all time warped trials of chosen subject and chosen group of task.
		rpca_subj				- computes the rPCA of a given subject and a given group of tasks
		rPCA_subj_RUNME			- This script plots explained variance and spider-plot rPCA for a given subject
		
	hdnd				
		rPCA_all_subj_d_nd_RUNME		- plots all explained variances of the group taken into account (healthy, dom, non dom)
		rpca_all_subj_d_nd				- computes rPCs on dataset divided into healthy, stroke dominant and non dominant affected and less affected groups
		rpca_stacker_all_subj_d_nd		- stacks all time warped trials of chosen group of task in five different groups Healthy, Dominant (A, LA) and Non Dominant (A, LA).
		rPCA_all_subj_d_nd_RUNME_7r		- same as above only for the last 7 joints
		rpca_all_subj_d_nd_7r			- same as above only for the last 7 joints
		rpca_stacker_all_subj_d_nd_7r	- same as above only for the last 7 joints
	hsla
		rpca_hsla						- rPCs on dataset divided into healthy, stroke and less affected groups
		rPCA_hsla_RUNME					- plots all explained variances of the group taken into account (healthy, stroke, less affected)
		rpca_stacker_hsla				- stacks all time warped trials of chosen group of task in  three different groups: Healthy, Stroke and LessAffected.
		rpca_hsla_7r					- same as above only for the last 7 joints
		rPCA_hsla_RUNME_7r				- same as above only for the last 7 joints
		rpca_stacker_hsla_7r			- same as above only for the last 7 joints
	visualizator_rPCs	
		rPC_t_subj						- extrapulates rPCs about a subject and a specific group of tasks at time t
		rPC_visualizator				- this script aims to visualize the movement associated to a signle rPC. 

09_subspace_angle
	1group_at_time
		hdnd_single_rPC_group		- This script computes and plots angle between each rPCs and the mean posture computed as the mean of each rPC among all subjects. It requires the choice of ngroup.
		hdnd_span_rPC_group			- This script computes and plots angle between the subspace generated by the selected rPCs and the one generated by the mean_posture PCs.
		hsla_single_rPC_group		- This script computes and plots angle between each rPCs and the mean  posture computed as the mean of each rPC among all subjects. It requires the choice of ngroup.
		hsla_span_rPC_group			- This script computes and plots angle between the subspace generated by the selected rPCs and the one generated by the mean_posture PCs.
		rPC_angle_group				- This function computes the angle between the subspace generated by the specified rPCs and the subspace of selected PC of the mean postures among all subjects' groups.

In order to make it easier for an external user to compile the code. Two new folders have been created to perform the analysis with angular velocities, these contain the same functions as the homonymous folders.
10_fPCA_dot

11_reconstruction_error_dot

90_ergonomy
	runme_ErgonomyFunctionalStudy - script to check ergonomy functional values over time and mean once specified trial and subjects (an healthy and a stroke).

99_folder
		healthy_task		- Generated in 'struct_population'
		strokes_task		- Generated in 'struct_population'
		these structures are arranged in this way:
					%		Structures' tree:
					%	healthy/strokes_task(1->30).
					%			subject(1->n_subjects).
					%					left/right_trial(1->n_trials).
					% 							L5.
					% 								quat
					% 								pos
					% 							Shoulder_L/R.
					% 								quat
					% 								pos
					% 							Upperarm_L/R.
					% 								...
					% 							Forearm_L/R.
					% 								...
					% 							Hand_L/R.
					% 								...
					% 							stroke_side		% the side damaged by stroke: -1 = healthy, 0 = left, 1 = right.
					% 							stroke_task		% boolean, true if the task is executed using the damaged side, false otherwise.
					% 							task_side		% stores the side which executes the task: 0 = left, 1 = right.

		q_task				-	Generated in 'q_main'. Joint angle signal. 
		q_task_warped 		-	Generated in 'warpa_task'. Time warped joint angle signal.
		q_task_warped_dot 	-	Generated in new_TW_dot. Joints velocities. 
		q_task structures are arranged in this way:
					% Structures' tree:
					%	q_task(1->30).
					%			subject(1->nSubjects_healthy,nSubjects_healthy+1->n_subjects_healthy+n_subjects_strokes).
					%					trial(1->n_trials, n_trials+1->2*n_trials).
					% 							q_grad			% results of UKF estimate of joint angles for every timestep (grad)
					% 							err				% error between measured positions and reconstructed ones using estimated joint angles
					% 							stroke_task		% boolean, true if the task is executed using the damaged side, false otherwise.
					% 							stroke_side		% the side damaged by stroke: -1 = healthy, 0 = left, 1 = right.
					% 			

		Genereted in 07_reconstruction_error
			E3			- Generated in 'RE_affected_nonaffected_calc'. Contains reconstruction error about firsts fPCs and 3DoFs model for each stroke subjects.
			E7			- Generated in 'RE_affected_nonaffected_calc'. Contains reconstruction error about firsts fPCs and 7DoFs model for each stroke subjects.
			E10			- Generated in 'RE_affected_nonaffected_calc'. Contains reconstruction error about firsts fPCs and 10DoFs model for each stroke subjects.
			E_h_3		- Generated in 'RE_healthy_calc'. Contains reconstruction error about firsts fPCs and 3DoFs model for each healthy subjects.
			E_h_mean3	- Generated in 'RE_healthy_calc'. Contains means of E_h_3 among subjects.
			E_h_7		- Generated in 'RE_healthy_calc'. Contains reconstruction error about firsts fPCs and 7DoFs model for each healthy subjects.
			E_h_mean7	- Generated in 'RE_healthy_calc'. Contains means of E_h_7 among subjects.
			E_h_10		- Generated in 'RE_healthy_calc'. Contains reconstruction error about firsts fPCs and 10DoFs model for each healthy subjects.
			E_h_mean10 	- Generated in 'RE_healthy_calc'. Contains means of E_h_10 among subjects.
			mat3_h		- Generated in 'recon_errror_matrix'. Contains reconstruction error about firsts fPCs only 10 DDoFs for each healthy subj
			mat3_la		- Generated in 'recon_errror_matrix'. Contains reconstruction error about firsts fPCs only 10 DDoFs for each less affected side of a stroke subj 
			mat3_s		- Generated in 'recon_errror_matrix'. Contains reconstruction error about firsts fPCs only 10 DDoFs for each affected side of a stroke subj
		Genereted in 11_reconstruction_error
			E3_dot			- Generated in 'RE_affected_nonaffected_calc'. Contains reconstruction error about firsts fPCs and 3DoFs model for each stroke subjects.
			E7_dot			- Generated in 'RE_affected_nonaffected_calc'. Contains reconstruction error about firsts fPCs and 7DoFs model for each stroke subjects.
			E10_dot			- Generated in 'RE_affected_nonaffected_calc'. Contains reconstruction error about firsts fPCs and 10DoFs model for each stroke subjects.
			E_h_3_dot		- Generated in 'RE_healthy_calc'. Contains reconstruction error about firsts fPCs and 3DoFs model for each healthy subjects.
			E_h_mean3_dot		- Generated in 'RE_healthy_calc'. Contains means of E_h_3 among subjects.
			E_h_7_dot		- Generated in 'RE_healthy_calc'. Contains reconstruction error about firsts fPCs and 7DoFs model for each healthy subjects.
			E_h_mean7_dot		- Generated in 'RE_healthy_calc'. Contains means of E_h_7 among subjects.
			E_h_10_dot		- Generated in 'RE_healthy_calc'. Contains reconstruction error about firsts fPCs and 10DoFs model for each healthy subjects.
			E_h_mean10_dot 		- Generated in 'RE_healthy_calc'. Contains means of E_h_10 among subjects.
			mat3_h_dot		- Generated in 'recon_errror_matrix'. Contains reconstruction error about firsts fPCs only 10 DDoFs for each healthy subj
			mat3_la_dot		- Generated in 'recon_errror_matrix'. Contains reconstruction error about firsts fPCs only 10 DDoFs for each less affected side of a stroke subj 
			mat3_s_dot		- Generated in 'recon_errror_matrix'. Contains reconstruction error about firsts fPCs only 10 DDoFs for each affected side of a stroke subj  
