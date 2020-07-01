%% Generate Dataset for FPCA



close all
clear all
clc
addpath('FPCA_Armando')
dirName = 'plots/';

%load('Actual_Dataset.mat')
load('Savings/Warped_Datasets_mean')
load('Savings/MEAN')
%Actual_Dataset = Warped_Datasets_mean;

%%

figure;
for j = 1 : size(Warped_Datasets_mean,1)
    hold on;
        tmp = Warped_Datasets_mean{j};
        subplot(2,4,1);hold on; plot(tmp(1,:))
        subplot(2,4,2);hold on; plot(tmp(2,:))
        subplot(2,4,3);hold on; plot(tmp(3,:))
        subplot(2,4,4);hold on; plot(tmp(4,:))
        subplot(2,4,5);hold on; plot(tmp(5,:))
        subplot(2,4,6);hold on; plot(tmp(6,:))
        subplot(2,4,7);hold on; plot(tmp(7,:))
end

[lista_pca_nr_dof1, lista_pca_nr_dof2, lista_pca_nr_dof3, lista_pca_nr_dof4,...
    lista_pca_nr_dof5, lista_pca_nr_dof6, lista_pca_nr_dof7 ] = calculate_fpca_mine( Warped_Datasets_mean);
%FD = lista_pca_nr.fd;

%save FD_dof1 FD_dof1

% pc1 = FD.fPCA{1};pc2 = FD.fPCA{2};pc3 = FD.fPCA{3};pc4 = FD.fPCA{4};pc5 = FD.fPCA{5};
% pc6 = FD.fPCA{6};pc7 = FD.fPCA{7};pc8 = FD.fPCA{8};pc9 = FD.fPCA{9};pc10 = FD.fPCA{10};
extrapolate_pcs;

disp(['VARIANZA COPERTA PC1 dof 1 ', num2str(lista_pca_nr_dof1.perc_varianza(1)) ]);
disp(['VARIANZA COPERTA PC1 dof 2 ', num2str(lista_pca_nr_dof2.perc_varianza(1)) ]);
disp(['VARIANZA COPERTA PC1 dof 3 ', num2str(lista_pca_nr_dof3.perc_varianza(1)) ]);
disp(['VARIANZA COPERTA PC1 dof 4 ', num2str(lista_pca_nr_dof4.perc_varianza(1)) ]);
disp(['VARIANZA COPERTA PC1 dof 5 ', num2str(lista_pca_nr_dof5.perc_varianza(1)) ]);
disp(['VARIANZA COPERTA PC1 dof 6 ', num2str(lista_pca_nr_dof6.perc_varianza(1)) ]);
disp(['VARIANZA COPERTA PC1 dof 7 ', num2str(lista_pca_nr_dof7.perc_varianza(1)) ]);

sms = [sum(lista_pca_nr_dof1.perc_varianza(1:3))*100 sum(lista_pca_nr_dof2.perc_varianza(1:3))*100 ...
    sum(lista_pca_nr_dof3.perc_varianza(1:3))*100 sum(lista_pca_nr_dof4.perc_varianza(1:3))*100 ...
    sum(lista_pca_nr_dof5.perc_varianza(1:3))*100 sum(lista_pca_nr_dof6.perc_varianza(1:3))*100 ...
    sum(lista_pca_nr_dof7.perc_varianza(1:3))*100];

mean(sms) 
std(sms)


figure;
subplot(2,4,1);bar(lista_pca_nr_dof1.perc_varianza*100);title({'Explained Variance';'DOF 1'});
axis([0.5 10.5 0 100]);xlabel('Principal Function');ylabel('%'); 
subplot(2,4,2);bar(lista_pca_nr_dof2.perc_varianza*100);title({'Explained Variance';'DOF 2'});
axis([0.5 10.5 0 100]);xlabel('Principal Function');ylabel('%');
subplot(2,4,3);bar(lista_pca_nr_dof3.perc_varianza*100);title({'Explained Variance';'DOF 3'});
axis([0.5 10.5 0 100]);xlabel('Principal Function');ylabel('%');
subplot(2,4,4);bar(lista_pca_nr_dof4.perc_varianza*100);title({'Explained Variance';'DOF 4'});
axis([0.5 10.5 0 100]);xlabel('Principal Function');ylabel('%');
subplot(2,4,5);bar(lista_pca_nr_dof5.perc_varianza*100);title({'Explained Variance';'DOF 5'});
axis([0.5 10.5 0 100]);xlabel('Principal Function');ylabel('%');
subplot(2,4,6);bar(lista_pca_nr_dof6.perc_varianza*100);title({'Explained Variance';'DOF 6'});
axis([0.5 10.5 0 100]);xlabel('Principal Function');ylabel('%');
subplot(2,4,7);bar(lista_pca_nr_dof7.perc_varianza*100);title({'Explained Variance';'DOF 7'});
axis([0.5 10.5 0 100]);xlabel('Principal Function');ylabel('%');
plotName = 'ExplainedVariances';
Subject = [''];
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

plot_pcs;


vars=[lista_pca_nr_dof1.perc_varianza';...
lista_pca_nr_dof2.perc_varianza';...
lista_pca_nr_dof3.perc_varianza';...
lista_pca_nr_dof4.perc_varianza';...
lista_pca_nr_dof5.perc_varianza';...
lista_pca_nr_dof6.perc_varianza';...
lista_pca_nr_dof7.perc_varianza']

figure, pareto(mean(vars))
hold on, errorbar(mean(vars),std(vars))
axis([0 15 0 1])
xlabel('fPC')
ylabel('Explained Variance [%]')
xticks([1:15])
yticks([0:0.1:1])
xticklabels([{'1'},{'2'},{'3'},{'4'},{'5'},{'6'},{'7'},{'8'},{'9'},{'10'},{'11'},{'12'},{'13'},{'14'},{'15'}])
yticklabels([{'0%'},{'10%'},{'20%'},{'30%'},{'40%'},{'50%'},{'60%'},{'70%'},{'80%'},{'90%'},{'100%'}])
grid on

plotName = 'ExplainedVariancesPretty';
Subject = [''];
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

save Savings/lista_pca_nr_dof1 lista_pca_nr_dof1
save Savings/lista_pca_nr_dof2 lista_pca_nr_dof2
save Savings/lista_pca_nr_dof3 lista_pca_nr_dof3
save Savings/lista_pca_nr_dof4 lista_pca_nr_dof4
save Savings/lista_pca_nr_dof5 lista_pca_nr_dof5
save Savings/lista_pca_nr_dof6 lista_pca_nr_dof6
save Savings/lista_pca_nr_dof7 lista_pca_nr_dof7
%% Approssimazione Curve utilizzando FPCA
 
sample_num = 54;  %93 is giada task 7??

scores_dof1 = lista_pca_nr_dof1.componenti;
scores_dof2 = lista_pca_nr_dof2.componenti;
scores_dof3 = lista_pca_nr_dof3.componenti;
scores_dof4 = lista_pca_nr_dof4.componenti;
scores_dof5 = lista_pca_nr_dof5.componenti;
scores_dof6 = lista_pca_nr_dof6.componenti;
scores_dof7 = lista_pca_nr_dof7.componenti;
media_dof1 = lista_pca_nr_dof1.media;
media_dof2 = lista_pca_nr_dof2.media;
media_dof3 = lista_pca_nr_dof3.media;
media_dof4 = lista_pca_nr_dof4.media;
media_dof5 = lista_pca_nr_dof5.media;
media_dof6 = lista_pca_nr_dof6.media;
media_dof7 = lista_pca_nr_dof7.media;

define_sc_sample_num;

% ricostruisco una funzione usando un certo numero di pcs

define_PCS_DOF;
% plotting PC1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% plot aux

%if sample_num == 93
realTrack = Warped_Datasets_mean{sample_num};
save Savings/realTrack realTrack
PC0All = [media_dof1'+MEAN(sample_num,1); media_dof2'+MEAN(sample_num,2); media_dof3'+MEAN(sample_num,3);...
          media_dof4'+MEAN(sample_num,4); media_dof5'+MEAN(sample_num,5); media_dof6'+MEAN(sample_num,6); media_dof7'+MEAN(sample_num,7)];

PC1All = [PC1_dof1'+MEAN(sample_num,1); PC1_dof2'+MEAN(sample_num,2); PC1_dof3'+MEAN(sample_num,3);...
          PC1_dof4'+MEAN(sample_num,4); PC1_dof5'+MEAN(sample_num,5); PC1_dof6'+MEAN(sample_num,6); PC1_dof7'+MEAN(sample_num,7)];
PC2All = [PC2_dof1'+MEAN(sample_num,1); PC2_dof2'+MEAN(sample_num,2); PC2_dof3'+MEAN(sample_num,3);...
          PC2_dof4'+MEAN(sample_num,4); PC2_dof5'+MEAN(sample_num,5); PC2_dof6'+MEAN(sample_num,6); PC2_dof7'+MEAN(sample_num,7)];
PC3All = [PC3_dof1'+MEAN(sample_num,1); PC3_dof2'+MEAN(sample_num,2); PC3_dof3'+MEAN(sample_num,3);...
          PC3_dof4'+MEAN(sample_num,4); PC3_dof5'+MEAN(sample_num,5); PC3_dof6'+MEAN(sample_num,6); PC3_dof7'+MEAN(sample_num,7)];
PC4All = [PC4_dof1'+MEAN(sample_num,1); PC4_dof2'+MEAN(sample_num,2); PC4_dof3'+MEAN(sample_num,3);...
          PC4_dof4'+MEAN(sample_num,4); PC4_dof5'+MEAN(sample_num,5); PC4_dof6'+MEAN(sample_num,6); PC4_dof7'+MEAN(sample_num,7)];
PC5All = [PC5_dof1'+MEAN(sample_num,1); PC5_dof2'+MEAN(sample_num,2); PC5_dof3'+MEAN(sample_num,3);...
          PC5_dof4'+MEAN(sample_num,4); PC5_dof5'+MEAN(sample_num,5); PC5_dof6'+MEAN(sample_num,6); PC5_dof7'+MEAN(sample_num,7)];
PC6All = [PC6_dof1'+MEAN(sample_num,1); PC6_dof2'+MEAN(sample_num,2); PC6_dof3'+MEAN(sample_num,3);...
          PC6_dof4'+MEAN(sample_num,4); PC6_dof5'+MEAN(sample_num,5); PC6_dof6'+MEAN(sample_num,6); PC6_dof7'+MEAN(sample_num,7)];
PC7All = [PC7_dof1'+MEAN(sample_num,1); PC7_dof2'+MEAN(sample_num,2); PC7_dof3'+MEAN(sample_num,3);...
          PC7_dof4'+MEAN(sample_num,4); PC7_dof5'+MEAN(sample_num,5); PC7_dof6'+MEAN(sample_num,6); PC7_dof7'+MEAN(sample_num,7)];
PC8All = [PC8_dof1'+MEAN(sample_num,1); PC8_dof2'+MEAN(sample_num,2); PC8_dof3'+MEAN(sample_num,3);...
          PC8_dof4'+MEAN(sample_num,4); PC8_dof5'+MEAN(sample_num,5); PC8_dof6'+MEAN(sample_num,6); PC8_dof7'+MEAN(sample_num,7)];
PC9All = [PC9_dof1'+MEAN(sample_num,1); PC9_dof2'+MEAN(sample_num,2); PC9_dof3'+MEAN(sample_num,3);...
          PC9_dof4'+MEAN(sample_num,4); PC9_dof5'+MEAN(sample_num,5); PC9_dof6'+MEAN(sample_num,6); PC9_dof7'+MEAN(sample_num,7)];
PC10All = [PC10_dof1'+MEAN(sample_num,1); PC10_dof2'+MEAN(sample_num,2); PC10_dof3'+MEAN(sample_num,3);...
          PC10_dof4'+MEAN(sample_num,4); PC10_dof5'+MEAN(sample_num,5); PC10_dof6'+MEAN(sample_num,6); PC10_dof7'+MEAN(sample_num,7)];

save Savings/PC0All PC0All
save Savings/PC1All PC1All
save Savings/PC2All PC2All
save Savings/PC3All PC3All
save Savings/PC4All PC4All
save Savings/PC5All PC5All
save Savings/PC6All PC6All
save Savings/PC7All PC7All
save Savings/PC8All PC8All
save Savings/PC9All PC9All
save Savings/PC10All PC10All


%end
%%
tmp = Warped_Datasets_mean{sample_num};
figure;
subplot(2,4,1);plot(tmp(1,:),'k','LineWidth',2);hold on;
plot(media_dof1(:),'c','LineWidth',2);legend('Real data','Mean');
title('dof1 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,2);plot(tmp(2,:),'k','LineWidth',2);hold on;
plot(media_dof2(:),'c','LineWidth',2);legend('Real data','Mean');
title('dof2 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,3);plot(tmp(3,:),'k','LineWidth',2);hold on;
plot(media_dof3(:),'c','LineWidth',2);legend('Real data','Mean');
title('dof3 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,4);plot(tmp(4,:),'k','LineWidth',2);hold on;
plot(media_dof4(:),'c','LineWidth',2);legend('Real data','Mean');
title('dof4 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,5);plot(tmp(5,:),'k','LineWidth',2);hold on;
plot(media_dof5(:),'c','LineWidth',2);legend('Real data','Mean');
title('dof5 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,6);plot(tmp(6,:),'k','LineWidth',2);hold on;
plot(media_dof6(:),'c','LineWidth',2);legend('Real data','Mean');
title('dof6 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,7);plot(tmp(7,:),'k','LineWidth',2);hold on;
plot(media_dof7(:),'c','LineWidth',2);legend('Real data','Mean');
title('dof7 reconstruction');xlabel('Time Sample');ylabel('rad')



plotName = 'Reconstruction';
Subject = ['mean_sample' num2str(sample_num)];
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

%%

tmp = Warped_Datasets_mean{sample_num};
figure;
subplot(2,4,1);plot(tmp(1,:),'k','LineWidth',2);hold on;
plot(PC1_dof1(:),'r','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof1 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,2);plot(tmp(2,:),'k','LineWidth',2);hold on;
plot(PC1_dof2(:),'r','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof2 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,3);plot(tmp(3,:),'k','LineWidth',2);hold on;
plot(PC1_dof3(:),'r','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof3 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,4);plot(tmp(4,:),'k','LineWidth',2);hold on;
plot(PC1_dof4(:),'r','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof4 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,5);plot(tmp(5,:),'k','LineWidth',2);hold on;
plot(PC1_dof5(:),'r','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof5 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,6);plot(tmp(6,:),'k','LineWidth',2);hold on;
plot(PC1_dof6(:),'r','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof6 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,7);plot(tmp(7,:),'k','LineWidth',2);hold on;
plot(PC1_dof7(:),'r','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof7 reconstruction');xlabel('Time Sample');ylabel('rad')



plotName = 'Reconstruction';
Subject = ['PC1_sample' num2str(sample_num)];
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));
 
%%

tmp = Warped_Datasets_mean{sample_num};
figure;
subplot(2,4,1);plot(tmp(1,:),'k','LineWidth',2);hold on;
plot(PC1_dof1(:),'r','LineWidth',2);plot(PC2_dof1(:),'b','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof1 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,2);plot(tmp(2,:),'k','LineWidth',2);hold on;
plot(PC1_dof2(:),'r','LineWidth',2);plot(PC2_dof2(:),'b','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof2 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,3);plot(tmp(3,:),'k','LineWidth',2);hold on;
plot(PC1_dof3(:),'r','LineWidth',2);plot(PC2_dof3(:),'b','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof3 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,4);plot(tmp(4,:),'k','LineWidth',2);hold on;
plot(PC1_dof4(:),'r','LineWidth',2);plot(PC2_dof4(:),'b','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof4 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,5);plot(tmp(5,:),'k','LineWidth',2);hold on;
plot(PC1_dof5(:),'r','LineWidth',2);plot(PC2_dof5(:),'b','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof5 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,6);plot(tmp(6,:),'k','LineWidth',2);hold on;
plot(PC1_dof6(:),'r','LineWidth',2);plot(PC2_dof6(:),'b','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof6 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,4,7);plot(tmp(7,:),'k','LineWidth',2);hold on;
plot(PC1_dof7(:),'r','LineWidth',2);plot(PC2_dof7(:),'b','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof7 reconstruction');xlabel('Time Sample');ylabel('rad')


plotName = 'Reconstruction';
Subject = ['PC2_sample' num2str(sample_num)];
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

%%

tmp = Warped_Datasets_mean{sample_num};
figure;
subplot(2,4,1);plot(tmp(1,:),'k','LineWidth',2);hold on;
plot(PC1_dof1(:),'r','LineWidth',2);plot(PC2_dof1(:),'b','LineWidth',2);plot(PC3_dof1(:),'g','LineWidth',2);
title('dof1 reconstruction');legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2', 'Mean + a_1*PC1 + a_2*PC2 + a_3*PC3');
xlabel('Time Sample');ylabel('rad')

subplot(2,4,2);plot(tmp(2,:),'k','LineWidth',2);hold on;
plot(PC1_dof2(:),'r','LineWidth',2);plot(PC2_dof2(:),'b','LineWidth',2);plot(PC3_dof2(:),'g','LineWidth',2);
title('dof2 reconstruction');legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2', 'Mean + a_1*PC1 + a_2*PC2 + a_3*PC3');
xlabel('Time Sample');ylabel('rad')

subplot(2,4,3);plot(tmp(3,:),'k','LineWidth',2);hold on;
plot(PC1_dof3(:),'r','LineWidth',2);plot(PC2_dof3(:),'b','LineWidth',2);plot(PC3_dof3(:),'g','LineWidth',2);
title('dof3 reconstruction');legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2', 'Mean + a_1*PC1 + a_2*PC2 + a_3*PC3');
xlabel('Time Sample');ylabel('rad')

subplot(2,4,4);plot(tmp(4,:),'k','LineWidth',2);hold on;
plot(PC1_dof4(:),'r','LineWidth',2);plot(PC2_dof4(:),'b','LineWidth',2);plot(PC3_dof4(:),'g','LineWidth',2);
title('dof4 reconstruction');legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2', 'Mean + a_1*PC1 + a_2*PC2 + a_3*PC3');
xlabel('Time Sample');ylabel('rad')

subplot(2,4,5);plot(tmp(5,:),'k','LineWidth',2);hold on;
plot(PC1_dof5(:),'r','LineWidth',2);plot(PC2_dof5(:),'b','LineWidth',2);plot(PC3_dof5(:),'g','LineWidth',2);
title('dof5 reconstruction');legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2', 'Mean + a_1*PC1 + a_2*PC2 + a_3*PC3');
xlabel('Time Sample');ylabel('rad')

subplot(2,4,6);plot(tmp(6,:),'k','LineWidth',2);hold on;
plot(PC1_dof6(:),'r','LineWidth',2);plot(PC2_dof6(:),'b','LineWidth',2);plot(PC3_dof6(:),'g','LineWidth',2);
title('dof6 reconstruction');legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2', 'Mean + a_1*PC1 + a_2*PC2 + a_3*PC3');
xlabel('Time Sample');ylabel('rad')

subplot(2,4,7);plot(tmp(7,:),'k','LineWidth',2);hold on;
plot(PC1_dof7(:),'r','LineWidth',2);plot(PC2_dof7(:),'b','LineWidth',2);plot(PC3_dof7(:),'g','LineWidth',2);
title('dof7 reconstruction');legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2', 'Mean + a_1*PC1 + a_2*PC2 + a_3*PC3');
xlabel('Time Sample');ylabel('rad')

plotName = 'Reconstruction';
Subject = ['PC3_sample' num2str(sample_num)];
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

%%
l = length(tmp(1,:));
MSE_media_1 = rms([tmp(1,:)-media_dof1']);MSE_media_2 = rms([tmp(2,:)-media_dof2']);MSE_media_3 = rms([tmp(3,:)-media_dof3']);
MSE_media_4 = rms([tmp(4,:)-media_dof4']);MSE_media_5 = rms([tmp(5,:)-media_dof5']);MSE_media_6 = rms([tmp(6,:)-media_dof6']);
MSE_media_7 = rms([tmp(7,:)-media_dof7']);
MSE_mean = [MSE_media_1 MSE_media_2 MSE_media_3 MSE_media_4 MSE_media_5 MSE_media_6 MSE_media_7];

MSE_PC1_1 = rms([tmp(1,:)-PC1_dof1']);MSE_PC1_2 = rms([tmp(2,:)-PC1_dof2']);MSE_PC1_3 = rms([tmp(3,:)-PC1_dof3']);
MSE_PC1_4 = rms([tmp(4,:)-PC1_dof4']);MSE_PC1_5 = rms([tmp(5,:)-PC1_dof5']);MSE_PC1_6 = rms([tmp(6,:)-PC1_dof6']);
MSE_PC1_7 = rms([tmp(7,:)-PC1_dof7']);
MSE_PC1 = [MSE_PC1_1 MSE_PC1_2 MSE_PC1_3 MSE_PC1_4 MSE_PC1_5 MSE_PC1_6 MSE_PC1_7];

MSE_PC2_1 = rms([tmp(1,:)-PC2_dof1']);MSE_PC2_2 = rms([tmp(2,:)-PC2_dof2']);MSE_PC2_3 = rms([tmp(3,:)-PC2_dof3']);
MSE_PC2_4 = rms([tmp(4,:)-PC2_dof4']);MSE_PC2_5 = rms([tmp(5,:)-PC2_dof5']);MSE_PC2_6 = rms([tmp(6,:)-PC2_dof6']);
MSE_PC2_7 = rms([tmp(7,:)-PC2_dof7']);
MSE_PC2 = [MSE_PC2_1 MSE_PC2_2 MSE_PC2_3 MSE_PC2_4 MSE_PC2_5 MSE_PC2_6 MSE_PC2_7];

MSE_PC3_1 = rms([tmp(1,:)-PC3_dof1']);MSE_PC3_2 = rms([tmp(2,:)-PC3_dof2']);MSE_PC3_3 = rms([tmp(3,:)-PC3_dof3']);
MSE_PC3_4 = rms([tmp(4,:)-PC3_dof4']);MSE_PC3_5 = rms([tmp(5,:)-PC3_dof5']);MSE_PC3_6 = rms([tmp(6,:)-PC3_dof6']);
MSE_PC3_7 = rms([tmp(7,:)-PC3_dof7']);
MSE_PC3 = [MSE_PC3_1 MSE_PC3_2 MSE_PC3_3 MSE_PC3_4 MSE_PC3_5 MSE_PC3_6 MSE_PC3_7];

MSE_PC4_1 = rms([tmp(1,:)-PC4_dof1']);MSE_PC4_2 = rms([tmp(2,:)-PC4_dof2']);MSE_PC4_3 = rms([tmp(3,:)-PC4_dof3']);
MSE_PC4_4 = rms([tmp(4,:)-PC4_dof4']);MSE_PC4_5 = rms([tmp(5,:)-PC4_dof5']);MSE_PC4_6 = rms([tmp(6,:)-PC4_dof6']);
MSE_PC4_7 = rms([tmp(7,:)-PC4_dof7']);
MSE_PC4 = [MSE_PC4_1 MSE_PC4_2 MSE_PC4_3 MSE_PC4_4 MSE_PC4_5 MSE_PC4_6 MSE_PC4_7];

MSE_PC5_1 = rms([tmp(1,:)-PC5_dof1']);MSE_PC5_2 = rms([tmp(2,:)-PC5_dof2']);MSE_PC5_3 = rms([tmp(3,:)-PC5_dof3']);
MSE_PC5_4 = rms([tmp(4,:)-PC5_dof4']);MSE_PC5_5 = rms([tmp(5,:)-PC5_dof5']);MSE_PC5_6 = rms([tmp(6,:)-PC5_dof6']);
MSE_PC5_7 = rms([tmp(7,:)-PC5_dof7']);
MSE_PC5 = [MSE_PC5_1 MSE_PC5_2 MSE_PC5_3 MSE_PC5_4 MSE_PC5_5 MSE_PC5_6 MSE_PC5_7];

MSE_PC6_1 = rms([tmp(1,:)-PC6_dof1']);MSE_PC6_2 = rms([tmp(2,:)-PC6_dof2']);MSE_PC6_3 = rms([tmp(3,:)-PC6_dof3']);
MSE_PC6_4 = rms([tmp(4,:)-PC6_dof4']);MSE_PC6_5 = rms([tmp(5,:)-PC6_dof5']);MSE_PC6_6 = rms([tmp(6,:)-PC6_dof6']);
MSE_PC6_7 = rms([tmp(7,:)-PC6_dof7']);
MSE_PC6 = [MSE_PC6_1 MSE_PC6_2 MSE_PC6_3 MSE_PC6_4 MSE_PC6_5 MSE_PC6_6 MSE_PC6_7];

MSE_PC7_1 = rms([tmp(1,:)-PC7_dof1']);MSE_PC7_2 = rms([tmp(2,:)-PC7_dof2']);MSE_PC7_3 = rms([tmp(3,:)-PC7_dof3']);
MSE_PC7_4 = rms([tmp(4,:)-PC7_dof4']);MSE_PC7_5 = rms([tmp(5,:)-PC7_dof5']);MSE_PC7_6 = rms([tmp(6,:)-PC7_dof6']);
MSE_PC7_7 = rms([tmp(7,:)-PC7_dof7']);
MSE_PC7 = [MSE_PC7_1 MSE_PC7_2 MSE_PC7_3 MSE_PC7_4 MSE_PC7_5 MSE_PC7_6 MSE_PC7_7];

MSE_PC8_1 = rms([tmp(1,:)-PC8_dof1']);MSE_PC8_2 = rms([tmp(2,:)-PC8_dof2']);MSE_PC8_3 = rms([tmp(3,:)-PC8_dof3']);
MSE_PC8_4 = rms([tmp(4,:)-PC8_dof4']);MSE_PC8_5 = rms([tmp(5,:)-PC8_dof5']);MSE_PC8_6 = rms([tmp(6,:)-PC8_dof6']);
MSE_PC8_7 = rms([tmp(7,:)-PC8_dof7']);
MSE_PC8 = [MSE_PC8_1 MSE_PC8_2 MSE_PC8_3 MSE_PC8_4 MSE_PC8_5 MSE_PC8_6 MSE_PC8_7];

MSE_PC9_1 = rms([tmp(1,:)-PC9_dof1']);MSE_PC9_2 = rms([tmp(2,:)-PC9_dof2']);MSE_PC9_3 = rms([tmp(3,:)-PC9_dof3']);
MSE_PC9_4 = rms([tmp(4,:)-PC9_dof4']);MSE_PC9_5 = rms([tmp(5,:)-PC9_dof5']);MSE_PC9_6 = rms([tmp(6,:)-PC9_dof6']);
MSE_PC9_7 = rms([tmp(7,:)-PC9_dof7']);
MSE_PC9 = [MSE_PC9_1 MSE_PC9_2 MSE_PC9_3 MSE_PC9_4 MSE_PC9_5 MSE_PC9_6 MSE_PC9_7];

MSE_PC10_1 = rms([tmp(1,:)-PC10_dof1']);MSE_PC10_2 = rms([tmp(2,:)-PC10_dof2']);MSE_PC10_3 = rms([tmp(3,:)-PC10_dof3']);
MSE_PC10_4 = rms([tmp(4,:)-PC10_dof4']);MSE_PC10_5 = rms([tmp(5,:)-PC10_dof5']);MSE_PC10_6 = rms([tmp(6,:)-PC10_dof6']);
MSE_PC10_7 = rms([tmp(7,:)-PC10_dof7']);
MSE_PC10 = [MSE_PC10_1 MSE_PC10_2 MSE_PC10_3 MSE_PC10_4 MSE_PC10_5 MSE_PC10_6 MSE_PC10_7];


err_ttl = [rms(MSE_mean) rms(MSE_PC1) rms(MSE_PC2) rms(MSE_PC3) rms(MSE_PC4) rms(MSE_PC5) rms(MSE_PC6)...
    rms(MSE_PC7) rms(MSE_PC8) rms(MSE_PC9) rms(MSE_PC10)];
figure;plot([0:10]',err_ttl,'r*-')
%figure;plot([0:10]',err_ttl/max(err_ttl),'r*-')
xlabel('Number of PCs used')
%ylabel('Normalized error')
ylabel('Error [rad]')
%title('Reconstruction RMS Error (Normalized)')
title('Reconstruction RMS Error')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tmp = Warped_Datasets_mean{sample_num};
figure;
subplot(2,4,1);plot(tmp(1,:),'g','LineWidth',2);hold on;plot(PC1_dof1(:),'r','LineWidth',2);title('reconstruct dof1 using PC1');
subplot(2,4,2);plot(tmp(2,:),'g','LineWidth',2);hold on;plot(PC1_dof2(:),'r','LineWidth',2);title('reconstruct dof2 using PC1');
subplot(2,4,3);plot(tmp(3,:),'g','LineWidth',2);hold on;plot(PC1_dof3(:),'r','LineWidth',2);title('reconstruct dof3 using PC1');
subplot(2,4,4);plot(tmp(4,:),'g','LineWidth',2);hold on;plot(PC1_dof4(:),'r','LineWidth',2);title('reconstruct dof4 using PC1');
subplot(2,4,5);plot(tmp(5,:),'g','LineWidth',2);hold on;plot(PC1_dof5(:),'r','LineWidth',2);title('reconstruct dof5 using PC1');
subplot(2,4,6);plot(tmp(6,:),'g','LineWidth',2);hold on;plot(PC1_dof6(:),'r','LineWidth',2);title('reconstruct dof6 using PC1');
subplot(2,4,7);plot(tmp(7,:),'g','LineWidth',2);hold on;plot(PC1_dof7(:),'r','LineWidth',2);title('reconstruct dof7 using PC1');
plotName = 'Reconstruction';
Subject = ['PC1_sample' num2str(sample_num)];
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

figure;
subplot(2,4,1);plot(tmp(1,:),'g');hold on;plot(PC2_dof1(:),'*r');title('reconstruct dof1 using PC1 and PC2');
subplot(2,4,2);plot(tmp(2,:),'g');hold on;plot(PC2_dof2(:),'*r');title('reconstruct dof2 using PC1 and PC2');
subplot(2,4,3);plot(tmp(3,:),'g');hold on;plot(PC2_dof3(:),'*r');title('reconstruct dof3 using PC1 and PC2');
subplot(2,4,4);plot(tmp(4,:),'g');hold on;plot(PC2_dof4(:),'*r');title('reconstruct dof4 using PC1 and PC2');
subplot(2,4,5);plot(tmp(5,:),'g');hold on;plot(PC2_dof5(:),'*r');title('reconstruct dof5 using PC1 and PC2');
subplot(2,4,6);plot(tmp(6,:),'g');hold on;plot(PC2_dof6(:),'*r');title('reconstruct dof6 using PC1 and PC2');
subplot(2,4,7);plot(tmp(7,:),'g');hold on;plot(PC2_dof7(:),'*r');title('reconstruct dof7 using PC1 and PC2');
plotName = 'Reconstruction';
Subject = ['PC1_2_sample' num2str(sample_num)];
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

figure;
subplot(2,4,1);plot(tmp(1,:),'g');hold on;plot(PC3_dof1(:),'*r');title('reconstruct dof1 using PC1 -> PC3');
subplot(2,4,2);plot(tmp(2,:),'g');hold on;plot(PC3_dof2(:),'*r');title('reconstruct dof2 using PC1 -> PC3');
subplot(2,4,3);plot(tmp(3,:),'g');hold on;plot(PC3_dof3(:),'*r');title('reconstruct dof3 using PC1 -> PC3');
subplot(2,4,4);plot(tmp(4,:),'g');hold on;plot(PC3_dof4(:),'*r');title('reconstruct dof4 using PC1 -> PC3');
subplot(2,4,5);plot(tmp(5,:),'g');hold on;plot(PC3_dof5(:),'*r');title('reconstruct dof5 using PC1 -> PC3');
subplot(2,4,6);plot(tmp(6,:),'g');hold on;plot(PC3_dof6(:),'*r');title('reconstruct dof6 using PC1 -> PC3');
subplot(2,4,7);plot(tmp(7,:),'g');hold on;plot(PC3_dof7(:),'*r');title('reconstruct dof7 using PC1 -> PC3');
plotName = 'Reconstruction';
Subject = ['PC1_3_sample' num2str(sample_num)];
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

figure;
subplot(2,4,1);plot(tmp(1,:),'g');hold on;plot(PC4_dof1(:),'*r');title('reconstruct dof1 using PC1 -> PC4');
subplot(2,4,2);plot(tmp(2,:),'g');hold on;plot(PC4_dof2(:),'*r');title('reconstruct dof2 using PC1 -> PC4');
subplot(2,4,3);plot(tmp(3,:),'g');hold on;plot(PC4_dof3(:),'*r');title('reconstruct dof3 using PC1 -> PC4');
subplot(2,4,4);plot(tmp(4,:),'g');hold on;plot(PC4_dof4(:),'*r');title('reconstruct dof4 using PC1 -> PC4');
subplot(2,4,5);plot(tmp(5,:),'g');hold on;plot(PC4_dof5(:),'*r');title('reconstruct dof5 using PC1 -> PC4');
subplot(2,4,6);plot(tmp(6,:),'g');hold on;plot(PC4_dof6(:),'*r');title('reconstruct dof6 using PC1 -> PC4');
subplot(2,4,7);plot(tmp(7,:),'g');hold on;plot(PC4_dof7(:),'*r');title('reconstruct dof7 using PC1 -> PC4');
plotName = 'Reconstruction';
Subject = ['PC1_4_sample' num2str(sample_num)];
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

figure;
subplot(2,4,1);plot(tmp(1,:),'g');hold on;plot(PC10_dof1(:),'*r');title('reconstruct dof1 using PC1 -> PC10');
subplot(2,4,2);plot(tmp(2,:),'g');hold on;plot(PC10_dof2(:),'*r');title('reconstruct dof2 using PC1 -> PC10');
subplot(2,4,3);plot(tmp(3,:),'g');hold on;plot(PC10_dof3(:),'*r');title('reconstruct dof3 using PC1 -> PC10');
subplot(2,4,4);plot(tmp(4,:),'g');hold on;plot(PC10_dof4(:),'*r');title('reconstruct dof4 using PC1 -> PC10');
subplot(2,4,5);plot(tmp(5,:),'g');hold on;plot(PC10_dof5(:),'*r');title('reconstruct dof5 using PC1 -> PC10');
subplot(2,4,6);plot(tmp(6,:),'g');hold on;plot(PC10_dof6(:),'*r');title('reconstruct dof6 using PC1 -> PC10');
subplot(2,4,7);plot(tmp(7,:),'g');hold on;plot(PC10_dof7(:),'*r');title('reconstruct dof7 using PC1 -> PC10');
plotName = 'Reconstruction';
Subject = ['PC1_10_sample' num2str(sample_num)];
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

%% mean_value +- pc1

% ricostruisco una funzione usando solo la prima componente principale

delta = 5;

mean_value = [media_dof1, media_dof2, media_dof3, media_dof4, media_dof5, media_dof6, media_dof7];

PC1_exp = [delta*pc1_dof1+media_dof1, delta*pc1_dof2+media_dof2, delta*pc1_dof3+media_dof3, delta*pc1_dof4+media_dof4,...
    delta*pc1_dof5+media_dof5, delta*pc1_dof6+media_dof6, delta*pc1_dof7+media_dof7];
PC1_exp_neg = [-delta*pc1_dof1+media_dof1, -delta*pc1_dof2+media_dof2, -delta*pc1_dof3+media_dof3, -delta*pc1_dof4+media_dof4,...
    -delta*pc1_dof5+media_dof5, -delta*pc1_dof6+media_dof6, -delta*pc1_dof7+media_dof7];

 
figure;
for i = 1 : 7
    subplot(2,4,i);hold on; plot(PC1_exp(:,i),'r--','LineWidth',3)
    subplot(2,4,i);hold on; plot(mean_value(:,i),'k','LineWidth',3)
    subplot(2,4,i);hold on; plot(PC1_exp_neg(:,i),'r:','LineWidth',3)
    xticks([0 242 485 727 970])
    xticklabels({'0','25','50','75','100'})
    title(strcat(['DoF ', num2str(i)]))
    if i == 1 || i == 5
        xlabel('Time Cycle [%]')
        ylabel('Angle [rad]')
    end
    ax = gca;
    ax.FontSize = 20;
    %ax.Interpreter = 'tex';
    if i == 7 
        legend('Mean + \alpha fPC1', 'Mean', 'Mean - \alpha fPC1')
    end
end
plotName = 'ExplanationPC1';
Subject = '';
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

%% mean_value +- pc2


% ricostruisco una funzione usando solo la prima componente principale

delta = 5;

mean_value = [media_dof1, media_dof2, media_dof3, media_dof4, media_dof5, media_dof6, media_dof7];

pc2_exp = [delta*pc2_dof1+media_dof1, delta*pc2_dof2+media_dof2, delta*pc2_dof3+media_dof3, delta*pc2_dof4+media_dof4,...
    delta*pc2_dof5+media_dof5, delta*pc2_dof6+media_dof6, delta*pc2_dof7+media_dof7];
pc2_exp_neg = [-delta*pc2_dof1+media_dof1, -delta*pc2_dof2+media_dof2, -delta*pc2_dof3+media_dof3, -delta*pc2_dof4+media_dof4,...
    -delta*pc2_dof5+media_dof5, -delta*pc2_dof6+media_dof6, -delta*pc2_dof7+media_dof7];

 
figure;
for i = 1 : 7
    subplot(2,4,i);hold on; plot(pc2_exp(:,i),'r--','LineWidth',3)
    subplot(2,4,i);hold on; plot(mean_value(:,i),'k','LineWidth',3)
    subplot(2,4,i);hold on; plot(pc2_exp_neg(:,i),'r:','LineWidth',3)
    xticks([0 242 485 727 970])
    xticklabels({'0','25','50','75','100'})
    title(strcat(['DoF ', num2str(i)]))
    if i == 1 || i == 5
        xlabel('Time Cycle [%]')
        ylabel('Angle [rad]')
    end
    ax = gca;
    ax.FontSize = 20;
    %ax.Interpreter = 'tex';
    if i == 7 
        legend('Mean + \alpha fPC2', 'Mean', 'Mean - \alpha fPC2')
    end
end
plotName = 'Explanationpc2';
Subject = '';
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

%% mean_value +- pc3

% ricostruisco una funzione usando solo la prima componente principale

delta = 5;

mean_value = [media_dof1, media_dof2, media_dof3, media_dof4, media_dof5, media_dof6, media_dof7];

pc3_exp = [delta*pc3_dof1+media_dof1, delta*pc3_dof2+media_dof2, delta*pc3_dof3+media_dof3, delta*pc3_dof4+media_dof4,...
    delta*pc3_dof5+media_dof5, delta*pc3_dof6+media_dof6, delta*pc3_dof7+media_dof7];
pc3_exp_neg = [-delta*pc3_dof1+media_dof1, -delta*pc3_dof2+media_dof2, -delta*pc3_dof3+media_dof3, -delta*pc3_dof4+media_dof4,...
    -delta*pc3_dof5+media_dof5, -delta*pc3_dof6+media_dof6, -delta*pc3_dof7+media_dof7];

 
figure;
for i = 1 : 7
    subplot(2,4,i);hold on; plot(pc3_exp(:,i),'r--','LineWidth',3)
    subplot(2,4,i);hold on; plot(mean_value(:,i),'k','LineWidth',3)
    subplot(2,4,i);hold on; plot(pc3_exp_neg(:,i),'r:','LineWidth',3)
    xticks([0 242 485 727 970])
    xticklabels({'0','25','50','75','100'})
    title(strcat(['DoF ', num2str(i)]))
    if i == 1 || i == 5
        xlabel('Time Cycle [%]')
        ylabel('Angle [rad]')
    end
    ax = gca;
    ax.FontSize = 20;
    %ax.Interpreter = 'tex';
    if i == 7 
        legend('Mean + \alpha fPC3', 'Mean', 'Mean - \alpha fPC3')
    end
end
plotName = 'Explanationpc3';
Subject = '';
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));

%% mean_value +- pc4

% ricostruisco una funzione usando solo la prima componente principale

delta = 5;

mean_value = [media_dof1, media_dof2, media_dof3, media_dof4, media_dof5, media_dof6, media_dof7];

pc4_exp = [delta*pc4_dof1+media_dof1, delta*pc4_dof2+media_dof2, delta*pc4_dof3+media_dof3, delta*pc4_dof4+media_dof4,...
    delta*pc4_dof5+media_dof5, delta*pc4_dof6+media_dof6, delta*pc4_dof7+media_dof7];
pc4_exp_neg = [-delta*pc4_dof1+media_dof1, -delta*pc4_dof2+media_dof2, -delta*pc4_dof3+media_dof3, -delta*pc4_dof4+media_dof4,...
    -delta*pc4_dof5+media_dof5, -delta*pc4_dof6+media_dof6, -delta*pc4_dof7+media_dof7];

 
figure;
for i = 1 : 7
    subplot(2,4,i);hold on; plot(pc4_exp(:,i),'r--','LineWidth',3)
    subplot(2,4,i);hold on; plot(mean_value(:,i),'k','LineWidth',3)
    subplot(2,4,i);hold on; plot(pc4_exp_neg(:,i),'r:','LineWidth',3)
    xticks([0 242 485 727 970])
    xticklabels({'0','25','50','75','100'})
    title(strcat(['DoF ', num2str(i)]))
    if i == 1 || i == 5
        xlabel('Time Cycle [%]')
        ylabel('Angle [rad]')
    end
    ax = gca;
    ax.FontSize = 25;
    %ax.Interpreter = 'tex';
    if i == 7 
        legend('Mean + \alpha fPC4', 'Mean', 'Mean - \alpha fPC4')
    end
end
plotName = 'Explanationpc4';
Subject = '';
saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));



%% Play with tempdata to get immages for ppt
% % % % 
% % % % close all
% % % % clear all
% % % % clc
% % % % 
% % % % load tempdata
% % % % load tempdata1
% % % % %load tempdata2
% % % % load Segmented_Datasets
% % % % load Warped_Datasets
% % % % load Warped_Datasets_mean
% % % % 
% % % % v1 = Segmented_Datasets{1,1}; v1 = v1(1,:); 
% % % % v2 = Segmented_Datasets{1,2}; v2 = v2(1,:); 
% % % % v3 = Segmented_Datasets{1,3}; v3 = v3(1,:); 
% % % % 
% % % % figure;hold on; plot(v1,'r','LineWidth',2);plot(v2,'g','LineWidth',2);plot(v3,'b','LineWidth',2);
% % % % name = ['segmented'];
% % % % xlabel('Time Sample')
% % % % ylabel('rad')
% % % % title('Joint Angle no.1, Subject 1, Task 1, segmented data')
% % % % print(name, '-dpdf');
% % % % 
% % % % 
% % % % figure;hold on; 
% % % % for i = [1 4 3 5 6]
% % % %   
% % % % v1 = Segmented_Datasets{i,1}; v1 = v1(1,:); 
% % % % v2 = Segmented_Datasets{i,2}; v2 = v2(1,:); 
% % % % v3 = Segmented_Datasets{i,3}; v3 = v3(1,:); 
% % % % plot(v1,'LineWidth',2);plot(v2,'LineWidth',2);plot(v3,'LineWidth',2);
% % % % end
% % % % name = ['segmented6'];
% % % % xlabel('Time Sample')
% % % % ylabel('rad')
% % % % title('Joint Angle no.1, 5 Segmented Data Samples')
% % % % print(name, '-dpdf');
% % % % 
% % % % 
% % % % % figure;hold on; 
% % % % % for i = [1 4 3 5 6]
% % % % %   
% % % % % v1 = Warped_Datasets{i,1}; v1 = v1(1,:); 
% % % % % v2 = Warped_Datasets{i,2}; v2 = v2(1,:); 
% % % % % v3 = Warped_Datasets{i,3}; v3 = v3(1,:); 
% % % % % plot(v1,'LineWidth',2);plot(v2,'LineWidth',2);plot(v3,'LineWidth',2);
% % % % % end
% % % % % name = ['warped'];
% % % % % xlabel('Time Sample')
% % % % % ylabel('rad')
% % % % % title('Joint Angle no.1, 5 Warped Data Samples')
% % % % % print(name, '-dpdf');
% % % % 
% % % % figure;hold on; 
% % % % for i = [1 4 3 5 6]
% % % %   
% % % % v1 = Warped_Datasets_mean{i,1}; v1 = v1(1,:); 
% % % % %v2 = Warped_Datasets_mean{i,2}; v2 = v2(1,:); 
% % % % %v3 = Warped_Datasets_mean{i,3}; v3 = v3(1,:); 
% % % % plot(v1,'LineWidth',2);
% % % % end
% % % % name = ['warped'];
% % % % xlabel('Time Sample')
% % % % ylabel('rad')
% % % % title('Joint Angle no.1, 5 Warped Data Samples')
% % % % print(name, '-dpdf');
% % % % 
% % % % 
% % % % figure
% % % % for i = 1 : 15
% % % % hold on
% % % % plot(FD_dof1.base.matriceBase(:,i))
% % % % end
% % % % name = ['base'];
% % % % xlabel('Time Sample')
% % % % ylabel('rad')
% % % % title('Basis functions')
% % % % print(name, '-dpdf');
% % % % 
% % % % s = [];
% % % % for i = 1 : 430
% % % % s = [s sum(FD_dof1.base.matriceBase(i,:))];
% % % % end
% % % % 
% % % % plot(s)
% % % % 
% % % % %%%%%%%%%%%%%%%%
% % % % 
% % % % load Actual_Dataset Actual_Dataset
% % % % 
% % % % tmp1 = Actual_Dataset{1};tmp2 = Actual_Dataset{2};tmp3 = Actual_Dataset{3};
% % % % tmp4 = Actual_Dataset{4};tmp5 = Actual_Dataset{5};tmp6 = Actual_Dataset{6};
% % % % tmp7 = Actual_Dataset{7};tmp8 = Actual_Dataset{8};tmp9 = Actual_Dataset{9};
% % % % tmp10 = Actual_Dataset{10};tmp11 = Actual_Dataset{11};tmp12 = Actual_Dataset{12};
% % % % tmp13 = Actual_Dataset{13};tmp14 = Actual_Dataset{14};tmp15 = Actual_Dataset{15};
% % % % tmp16 = Actual_Dataset{16};tmp17 = Actual_Dataset{17};tmp16 = Actual_Dataset{18};
% % % % 
% % % % meanf = [];
% % % % for i = 1 : length(tmp1(1,:))
% % % %     tmpv = [tmp1(3,i) tmp2(3,i) tmp3(3,i) tmp4(3,i) tmp5(3,i) tmp6(3,i) tmp7(3,i) tmp8(3,i)...
% % % %             tmp9(3,i) tmp10(3,i) tmp11(3,i) tmp12(3,i) tmp13(3,i) tmp14(3,i) tmp15(3,i) tmp16(3,i) ];
% % % % meanf = [ meanf mean_value(tmpv','omitnan')];
% % % % end
% % % % 
% % % % figure;hold on;plot(meanf,'k-*','LineWidth',2);
% % % % plot(tmp1(3,:));plot(tmp5(3,:));plot(tmp9(3,:));plot(tmp13(3,:));
% % % % plot(tmp2(3,:));plot(tmp6(3,:));plot(tmp10(3,:));plot(tmp14(3,:));
% % % % plot(tmp3(3,:));plot(tmp7(3,:));plot(tmp11(3,:));plot(tmp15(3,:));
% % % % plot(tmp4(3,:));plot(tmp8(3,:));plot(tmp12(3,:));plot(tmp16(3,:));
% % % % name = ['meanf'];
% % % % xlabel('Time Sample')
% % % % ylabel('rad')
% % % % title('Sample of dataset and mean_value function (in black)')
% % % % print(name, '-dpdf');
% % % % 
% % % % figure;hold on;
% % % % plot(tmp1(3,:)-meanf);plot(tmp5(3,:)-meanf);plot(tmp9(3,:)-meanf);plot(tmp13(3,:)-meanf);
% % % % plot(tmp2(3,:)-meanf);plot(tmp6(3,:)-meanf);plot(tmp10(3,:)-meanf);plot(tmp14(3,:)-meanf);
% % % % plot(tmp3(3,:)-meanf);plot(tmp7(3,:)-meanf);plot(tmp11(3,:)-meanf);plot(tmp15(3,:)-meanf);
% % % % plot(tmp4(3,:)-meanf);plot(tmp8(3,:)-meanf);plot(tmp12(3,:)-meanf);plot(tmp16(3,:)-meanf);
% % % % name = ['datanomean'];
% % % % xlabel('Time Sample')
% % % % ylabel('rad')
% % % % title('Sample of dataset wihout mean_value function')
% % % % print(name, '-dpdf');
% % % % % figure;
% % % % % subplot(2,4,1);plot(media_dof1(:),'r','LineWidth',2);title('Mean Dof1');
% % % % % subplot(2,4,2);plot(media_dof2(:),'r','LineWidth',2);title('Mean Dof2');
% % % % % subplot(2,4,3);plot(media_dof3(:),'r','LineWidth',2);title('Mean Dof3');
% % % % % subplot(2,4,4);plot(media_dof4(:),'r','LineWidth',2);title('Mean Dof4');
% % % % % subplot(2,4,5);plot(media_dof5(:),'r','LineWidth',2);title('Mean Dof5');
% % % % % subplot(2,4,6);plot(media_dof6(:),'r','LineWidth',2);title('Mean Dof6');
% % % % % subplot(2,4,7);plot(media_dof7(:),'r','LineWidth',2);title('Mean Dof7');
% % % % % plotName = 'Mean';
% % % % % Subject = [''];
% % % % % saveas(gcf,strcat(dirName,plotName,Subject,'.fig'));
% % % % % saveas(gcf,strcat(dirName,plotName,Subject,'.jpg'));
% % % % % 
% % % % % 

