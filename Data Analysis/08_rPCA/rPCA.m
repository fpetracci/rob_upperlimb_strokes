%% intro
clear all; close all; clc;
 
%% Costruction of matrix 
% Xi (nobs x ndof) one for each time sample i
% [coeff,score,latent,tsquared,explained,mu] = pca(___)
%	coeff		= svd values
%	score		= scores (eigenvector for reconstruction)
%	latent		= explained variances
%	tsquared	= Hotelling's T-squared statistic for each observation in X
%	explained	= the percentage of the total variance explained by each principal component 
%	mu			= estimated mean of each variable in X 
%
% we will use:
%	[coeffi, scorei, ~, ~, explainedi, ~] = pca(Xi)




