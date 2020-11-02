%This script loads in the Matlab path all needed scripts and functions.

%%
disp('Data Analysis: Alessia Biondi, Andrea Ferroni and Francesco Petracci')

if verLessThan('matlab', '7.0')
    warning('You are running a very old (and unsupported) version of MATLAB.  You will very likely encounter significant problems using this files but you are on your own with this');
end


script_path = fileparts( mfilename('fullpath') );

addpath(fullfile(script_path, '00_function_folder'));
addpath(fullfile(script_path, '00_ukf'));
addpath(fullfile(script_path, '02_Kalman_marker'));
addpath(fullfile(script_path, '03_q'));
addpath(fullfile(script_path, '05_fPCA'));
addpath(fullfile(script_path, '08_rPCA'));
addpath(fullfile(script_path, '09_subspace_angle'));
addpath(fullfile(script_path, '99_folder_mat'));


clear script_path