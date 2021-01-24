% This script does all the necessary computations for first extra-project 
% work. In particular applies (Adaptive) Backstepping and (Adaptive)
% Computed Torque.
% Some parts are in italian to ease the coding process.


%% Clean Matlab Environment & setup

clear all;
close all;
clc;

addpath(genpath("Funzioni"));

mdl_franka ; % load franka model in the workspace
%% Choose Trajectory

Franka_trajectory;

%% Select controller

fprintf('Choose controller: \n')
fprintf('1: Computed Torque \n');
fprintf('2: Backstepping \n');
controller = input('');

%% Simulations
switch controller          
    case 1 
		Franka_CT;
	case 2
		Franka_BS;
end

%% plot

Franka_plot;