% script to test fpca on the joints angle of a singular trial execution



%% load

clear; clc; close;

oldfolder = cd;
cd ../
cd 99_folder_mat
%load('healthy_task.mat');
%load('strokes_task.mat');
load('q_task.mat');
% load q warped
cd(oldfolder);
clear oldfolder;

q = q_task(7).subject(1).trial(1).q_grad';

clear q_task;

 %% fpca
 
n = size(q,2);

frequenza = 60;						% sampling rate
intervallo=[0, n/frequenza];		% time range
t=linspace(intervallo(1),intervallo(2),n);

base = creaBase(intervallo, 13,5)
oggettoFD = calcolaCurve(t, q, base);
oggettoFD_medio = calcolaMediaCurve(oggettoFD);


lista_pca_nr = calcolaFPCA(oggettoFD,3);
FD = lista_pca_nr.fd
pc1 = FD.fPCA{1};
pc2 = FD.fPCA{2};
pc3 = FD.fPCA{3};
 
 