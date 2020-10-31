FARE FUNZIONE CHE METTE NEL PATH DI MATLAB LE COSE CHE CI INTERESSANO:
	00_function_folder
	00_ukf
	03_q
	08_rPCA


Folders, Function and Scripts descriptions.
Folders named 'old' contain old function and or scripts that are no longer useful or are not updated.

00_function_folder
	FPCA_Armando		- Folder containing all general fpca functions.
	arm_fkine 		 	- computes the forward kinematic of given Arm and angle joints. The output is the homogenous matrix T given at the n-th joint.
	arm_gen_plot 		- animates a general right arm given q. The parameters of the animated arm come from a chosen trial and are not editable.
	check_trial			- checks if there are angles in the trial that are out of bounds.
	correct2pi_err 		- removes the pi discontinuity of input angles.
	create_arms 		- given a specific trial, constructs the 10R serial robot representing a human torso-arm.
	fkine_kalman_marker	- This function generates the measurement vector (33x1) for kalman filter. From angular data it computes virtual marker positions to be used with joint measured positions inside the filter correction step.
	fpca2q				- reconstructs the angular joints signal with the first fPCs given the structure cointaining fpca information.
	J_ergo 				- computes the ergonomic functional.
	load_mvnx 			- loads a .mnvx file into the matlab workspace.
	par_10R				- par_10R this function calculates all parameters needed to build the Denavit-Hartenberg table of the 10R arm.
	reshape_data 		- performs a reshape of input by rearranging its dimension as 1:3:2.
	spider_plot (family)- Create a spider or radar plot with individual axes. By Moses Yoo.
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
	q_main 		- runs the needed scripts to generate q_task.mat, specifically: q_creation and q_population.
	q_trial2q 	- implements UKF executions and joint angles estimations on a single trial dataset given as input.
    q_creation 	- script to initializes the structures of q_task. It groups data about every subjects involved and tasks executed. 
	q_population- populates q_task struct with estimated joint angles values from q_trial2q.m and other informations.

04_time_warp

05_fPCA

06_statistical_analysis

07_reconstruction_error

08_rPCA

09_subspace_angle

90_ergonomy
	runme_ErgonomyFunctionalStudy -script to check ergonomy functional values over time and mean once specified trial and subjects (an healthy and a stroke).