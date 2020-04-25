%main structure script
clear; clc; close;

%global constant definition
nTasks = 30;
nTrial = 3;
nSubject_strokes = 20;
nSubject_healthy = 5;

% script execution
struct_creation
struct_population

%%------------------------COMMENT------------------------%% 

%% struct_main.m		- runs the needed scripts to generate strokes_data.mat and healthy_data.mat
%% load_mvnx.m			- function that loads a specified .mvnx file into a matlab structure
%% struct_dataload.m	- function that extrapolate relevant data from the file .mvnx. It needs load_mvnx in order to work correctly.
%% struct_creation.m	- initializes the structures of strokes_data and healthy_data
%% struct_population.m	- searches and read all mvnx files with the proper name and populates the structures of strokes_data and healthy_data with the relevant data
