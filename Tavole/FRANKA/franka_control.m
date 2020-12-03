clear all ; clc ;close all
%modello cinematico e generazione traiettoria
mdl_franka 
%modello dinamico
%% scelta della traiettoria, per il momento sarà una traiettoria sinusoidale
M = get_MassMatrix([0 0 0 0 0 0 0]);
G = get_GravityVector([0 0 0 0 0 0 0]);