% script to test fpca on the joints angle of a singular trial execution



%% load

clear; clc; close;

oldfolder = cd;
cd ../
cd 99_folder_mat
load('healthy_task.mat');
load('strokes_task.mat');
load('q_task.mat');
% load q warped
cd(oldfolder);
clear oldfolder;

trial = healthy_task(23).subject(1).left_side_trial(1);
q = q_task(23).subject(1).trial(1).q_grad';

arms = create_arms(trial);
arm = arms.left;

 %% fpca
 
n = size(q,1);

frequenza = 1;						% sampling rate
intervallo=[0, n/frequenza];		% time range
t=linspace(intervallo(1),intervallo(2),n);

base = creaBase(intervallo, 15, 5);
oggettoFD = calcolaCurve(t, q, base);
oggettoFD_medio = calcolaMediaCurve(oggettoFD);
lista_pca_nr = calcolaFPCA(oggettoFD,3);

FD = lista_pca_nr.fd;
pc1 = FD.fPCA{1};
pc2 = FD.fPCA{2};
pc3 = FD.fPCA{3};
 
scores = lista_pca_nr.componenti;
media = lista_pca_nr.media;

sc1=scores(:,1);
sc2=scores(:,2);
sc3=scores(:,3);

PC1 = zeros(size(q));
%PC1=[sc11.*pc1(:,1)+media(:,1)];
for i = 1:length(pc1)
	PC1(i,:) = pc1(i) * sc1 + media(i);
end
PC12 = zeros(size(q));
for i = 1:length(pc1)
	PC12(i,:) = pc2(i) * sc2 + pc1(i) * sc1 + media(i);
end
PC123 = zeros(size(q));
for i = 1:length(pc1)
	PC123(i,:) = pc3(i) * sc3 + pc2(i) * sc2 + pc1(i) * sc1 + media(i);
end


%% plots
figure(1)
grid on
plot(q, 'r')
hold on
plot(PC1, 'b')
plot(PC12, 'g')
plot(PC123, 'c')


%% animation
figure(2)
arm.plot(q/180*pi)
arm.plot(PC1/180*pi)
arm.plot(PC12/180*pi)
arm.plot(PC123/180*pi)
