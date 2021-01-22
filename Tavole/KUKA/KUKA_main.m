% This script does all the necessary computations for first extra-project 
% work. In particular applies (Adaptive) Backstepping and (Adaptive)
% Computed Torque.
% Some parts are in italian to ease the coding process.


%% Clean Matlab Environment & setup

clear all;
close all;
clc;

addpath(genpath("functions_kuka"));

KUKA_createmodels; % load KUKA and KUKAmodel robots in the workspace
%% Choose Trajectory

KUKA_trajectory;

%% Select controller

fprintf('Choose controller: \n')
fprintf('1: Computed Torque \n');
fprintf('2: Computed Torque Adaptive \n');
fprintf('3: Backstepping \n');
fprintf('4: Backstepping Adaptive \n');
controller = input('');

%% Simulations
switch controller
                    
    case 1 
		KUKA_CT;
	
	case 2
		KUKA_CT_ad;
		
	case 3
		KUKA_BS;
		
	case 4
		KUKA_BS_ad;
		
end

%% plot

KUKA_plot;