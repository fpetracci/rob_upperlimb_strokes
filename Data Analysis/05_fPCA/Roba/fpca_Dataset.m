%% Generate Dataset for FPCA

close all
clear all
clc

addpath('FPCA_Armando')
% dirName = 'plots/';

%load('Actual_Dataset.mat')
load('Dataset_Warped')
%Actual_Dataset = Warped_Datasets_mean;

%%

Dataset_copia = Dataset_Warped;
for j = 1:length(Dataset_copia)
      mov = Dataset_Warped{j,1};
      % if abs(mov(6,end)-mov(6,1)) > 0.61
      if abs(mov(6,end)-mov(6,1)) > 2/3*pi || abs(mov(5,end)-mov(5,1)) > 2/3*pi || abs(mov(4,end)-mov(4,1)) > 2/3*pi
           Dataset_copia{j,1} = [];
      end
end
emptycells = find(cellfun(@isempty,Dataset_copia));
Dataset_copia(emptycells) = []; 
Dataset_Warped = Dataset_copia;

% Dataset_copia = Dataset_Warped;
% for j = 1:length(Dataset_copia)
%       mov = Dataset_Warped{j,1};
%       mov(4,:) = wrapToPi(mov(4,:));
%       mov(5,:) = wrapToPi(mov(5,:));
%       mov(6,:) = wrapToPi(mov(6,:));
%       Dataset_copia{j,1} = mov;
%       % if abs(mov(6,end)-mov(6,1)) > 0.61
% %       if abs(mov(6,end)-mov(6,1)) > 2/3*pi || abs(mov(5,end)-mov(5,1)) > 2/3*pi || abs(mov(4,end)-mov(4,1)) > 2/3*pi
% %            Dataset_copia{j,1} = [];
% %       end
% end
% %emptycells = find(cellfun(@isempty,Dataset_copia));
% %Dataset_copia(emptycells) = []; 
% Dataset_Warped = Dataset_copia;

%%

tic
Warped_Datasets_mean = cell(length(Dataset_Warped),1);

ndata = size(Warped_Datasets_mean,1);

MEAN = zeros(ndata,6);
for i = 1 : ndata
        tmp = Dataset_Warped{i};
        for k = 1 : 6
            MEAN(i,k) = mean(tmp(k,:));
            tmp(k,:) = tmp(k,:)-mean(tmp(k,:));
        end
        Warped_Datasets_mean{i} = tmp;
end
toc
%%

figure;
for j = 1 : size(Warped_Datasets_mean,1)
    hold on;
        tmp = Warped_Datasets_mean{j};
        subplot(2,3,1);hold on; plot(tmp(1,:))
        subplot(2,3,2);hold on; plot(tmp(2,:))
        subplot(2,3,3);hold on; plot(tmp(3,:))
        subplot(2,3,4);hold on; plot(tmp(4,:))
        subplot(2,3,5);hold on; plot(tmp(5,:))
        subplot(2,3,6);hold on; plot(tmp(6,:))
end

%%
tic
Warped_Datasets_ridotto = Warped_Datasets_mean(1:length(Dataset_copia));
[lista_pca_nr_dof1, lista_pca_nr_dof2, lista_pca_nr_dof3, lista_pca_nr_dof4,...
    lista_pca_nr_dof5, lista_pca_nr_dof6 ] = calculate_fpca_mine(Warped_Datasets_ridotto);
toc

%%

FD_dof1 = lista_pca_nr_dof1.fd;
FD_dof2 = lista_pca_nr_dof2.fd;
FD_dof3 = lista_pca_nr_dof3.fd;
FD_dof4 = lista_pca_nr_dof4.fd;
FD_dof5 = lista_pca_nr_dof5.fd;
FD_dof6 = lista_pca_nr_dof6.fd;

pc1_dof1 = FD_dof1.fPCA{1};pc2_dof1 = FD_dof1.fPCA{2};pc3_dof1 = FD_dof1.fPCA{3};...
pc4_dof1 = FD_dof1.fPCA{4};pc5_dof1 = FD_dof1.fPCA{5};pc6_dof1 = FD_dof1.fPCA{6};
pc7_dof1 = FD_dof1.fPCA{7};pc8_dof1 = FD_dof1.fPCA{8};pc9_dof1 = FD_dof1.fPCA{9};pc10_dof1 = FD_dof1.fPCA{10};

pc1_dof2 = FD_dof2.fPCA{1};pc2_dof2 = FD_dof2.fPCA{2};pc3_dof2 = FD_dof2.fPCA{3};...
pc4_dof2 = FD_dof2.fPCA{4};pc5_dof2 = FD_dof2.fPCA{5};pc6_dof2 = FD_dof2.fPCA{6};
pc7_dof2 = FD_dof2.fPCA{7};pc8_dof2 = FD_dof2.fPCA{8};pc9_dof2 = FD_dof2.fPCA{9};pc10_dof2 = FD_dof2.fPCA{10};

pc1_dof3 = FD_dof3.fPCA{1};pc2_dof3 = FD_dof3.fPCA{2};pc3_dof3 = FD_dof3.fPCA{3};...
pc4_dof3 = FD_dof3.fPCA{4};pc5_dof3 = FD_dof3.fPCA{5};pc6_dof3 = FD_dof3.fPCA{6};
pc7_dof3 = FD_dof3.fPCA{7};pc8_dof3 = FD_dof3.fPCA{8};pc9_dof3 = FD_dof3.fPCA{9};pc10_dof3 = FD_dof3.fPCA{10};

pc1_dof4 = FD_dof4.fPCA{1};pc2_dof4 = FD_dof4.fPCA{2};pc3_dof4 = FD_dof4.fPCA{3};...
pc4_dof4 = FD_dof4.fPCA{4};pc5_dof4 = FD_dof4.fPCA{5};pc6_dof4 = FD_dof4.fPCA{6};
pc7_dof4 = FD_dof4.fPCA{7};pc8_dof4 = FD_dof4.fPCA{8};pc9_dof4 = FD_dof4.fPCA{9};pc10_dof4 = FD_dof4.fPCA{10};

pc1_dof5 = FD_dof5.fPCA{1};pc2_dof5 = FD_dof5.fPCA{2};pc3_dof5 = FD_dof5.fPCA{3};...
pc4_dof5 = FD_dof5.fPCA{4};pc5_dof5 = FD_dof5.fPCA{5};pc6_dof5 = FD_dof5.fPCA{6};
pc7_dof5 = FD_dof5.fPCA{7};pc8_dof5 = FD_dof5.fPCA{8};pc9_dof5 = FD_dof5.fPCA{9};pc10_dof5 = FD_dof5.fPCA{10};

pc1_dof6 = FD_dof6.fPCA{1};pc2_dof6 = FD_dof6.fPCA{2};pc3_dof6 = FD_dof6.fPCA{3};...
pc4_dof6 = FD_dof6.fPCA{4};pc5_dof6 = FD_dof6.fPCA{5};pc6_dof6 = FD_dof6.fPCA{6};
pc7_dof6 = FD_dof6.fPCA{7};pc8_dof6 = FD_dof6.fPCA{8};pc9_dof6 = FD_dof6.fPCA{9};pc10_dof6 = FD_dof6.fPCA{10};

%%

disp(['VARIANZA COPERTA PC1 dof 1 ', num2str(lista_pca_nr_dof1.perc_varianza(1)) ]);
disp(['VARIANZA COPERTA PC1 dof 2 ', num2str(lista_pca_nr_dof2.perc_varianza(1)) ]);
disp(['VARIANZA COPERTA PC1 dof 3 ', num2str(lista_pca_nr_dof3.perc_varianza(1)) ]);
disp(['VARIANZA COPERTA PC1 dof 4 ', num2str(lista_pca_nr_dof4.perc_varianza(1)) ]);
disp(['VARIANZA COPERTA PC1 dof 5 ', num2str(lista_pca_nr_dof5.perc_varianza(1)) ]);
disp(['VARIANZA COPERTA PC1 dof 6 ', num2str(lista_pca_nr_dof6.perc_varianza(1)) ]);

%%

sms = [sum(lista_pca_nr_dof1.perc_varianza(1:3))*100 sum(lista_pca_nr_dof2.perc_varianza(1:3))*100 ...
    sum(lista_pca_nr_dof3.perc_varianza(1:3))*100 sum(lista_pca_nr_dof4.perc_varianza(1:3))*100 ...
    sum(lista_pca_nr_dof5.perc_varianza(1:3))*100 sum(lista_pca_nr_dof6.perc_varianza(1:3))*100];

mean(sms) 
std(sms)

%%

figure;
subplot(2,3,1);bar(lista_pca_nr_dof1.perc_varianza*100);title({'Explained Variance';'DOF 1'});
axis([0.5 10.5 0 100]);xlabel('Principal Function');ylabel('%'); 
subplot(2,3,2);bar(lista_pca_nr_dof2.perc_varianza*100);title({'Explained Variance';'DOF 2'});
axis([0.5 10.5 0 100]);xlabel('Principal Function');ylabel('%');
subplot(2,3,3);bar(lista_pca_nr_dof3.perc_varianza*100);title({'Explained Variance';'DOF 3'});
axis([0.5 10.5 0 100]);xlabel('Principal Function');ylabel('%');
subplot(2,3,4);bar(lista_pca_nr_dof4.perc_varianza*100);title({'Explained Variance';'DOF 4'});
axis([0.5 10.5 0 100]);xlabel('Principal Function');ylabel('%');
subplot(2,3,5);bar(lista_pca_nr_dof5.perc_varianza*100);title({'Explained Variance';'DOF 5'});
axis([0.5 10.5 0 100]);xlabel('Principal Function');ylabel('%');
subplot(2,3,6);bar(lista_pca_nr_dof6.perc_varianza*100);title({'Explained Variance';'DOF 6'});
axis([0.5 10.5 0 100]);xlabel('Principal Function');ylabel('%');
plotName = 'ExplainedVariances';
Subject = [''];

%%

figure;
subplot(2,2,1);plot(pc1_dof1(:,1),'r');title('pc1 dof1')
subplot(2,2,2);plot(pc2_dof1(:,1),'g');title('pc2 dof1')
subplot(2,2,3);plot(pc3_dof1(:,1),'b');title('pc3 dof1')
subplot(2,2,4);plot(pc4_dof1(:,1),'k');title('pc4 dof1')
plotName = 'PCs';
Subject = 'Dof1';

figure;
subplot(2,2,1);plot(pc1_dof2(:,1),'r');title('pc1 dof2')
subplot(2,2,2);plot(pc2_dof2(:,1),'g');title('pc2 dof2')
subplot(2,2,3);plot(pc3_dof2(:,1),'b');title('pc3 dof2')
subplot(2,2,4);plot(pc4_dof2(:,1),'k');title('pc4 dof2')
plotName = 'PCs';
Subject = 'Dof2';

figure;
subplot(2,2,1);plot(pc1_dof3(:,1),'r');title('pc1 dof3')
subplot(2,2,2);plot(pc2_dof3(:,1),'g');title('pc2 dof3')
subplot(2,2,3);plot(pc3_dof3(:,1),'b');title('pc3 dof3')
subplot(2,2,4);plot(pc4_dof3(:,1),'k');title('pc4 dof3')
plotName = 'PCs';
Subject = 'Dof3';

figure;
subplot(2,2,1);plot(pc1_dof4(:,1),'r');title('pc1 dof4')
subplot(2,2,2);plot(pc2_dof4(:,1),'g');title('pc2 dof4')
subplot(2,2,3);plot(pc3_dof4(:,1),'b');title('pc3 dof4')
subplot(2,2,4);plot(pc4_dof4(:,1),'k');title('pc4 dof4')
plotName = 'PCs';
Subject = 'Dof4';

figure;
subplot(2,2,1);plot(pc1_dof5(:,1),'r');title('pc1 dof5')
subplot(2,2,2);plot(pc2_dof5(:,1),'g');title('pc2 dof5')
subplot(2,2,3);plot(pc3_dof5(:,1),'b');title('pc3 dof5')
subplot(2,2,4);plot(pc4_dof5(:,1),'k');title('pc4 dof5')
plotName = 'PCs';
Subject = 'Dof5';

figure;
subplot(2,2,1);plot(pc1_dof6(:,1),'r');title('pc1 dof6')
subplot(2,2,2);plot(pc2_dof6(:,1),'g');title('pc2 dof6')
subplot(2,2,3);plot(pc3_dof6(:,1),'b');title('pc3 dof6')
subplot(2,2,4);plot(pc4_dof6(:,1),'k');title('pc4 dof6')
plotName = 'PCs';
Subject = 'Dof6';

%%

vars=[lista_pca_nr_dof1.perc_varianza';...
lista_pca_nr_dof2.perc_varianza';...
lista_pca_nr_dof3.perc_varianza';...
lista_pca_nr_dof4.perc_varianza';...
lista_pca_nr_dof5.perc_varianza';...
lista_pca_nr_dof6.perc_varianza'];

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

%% Approssimazione Curve utilizzando FPCA
 
sample_num = 120;  %93 is giada task 7??

scores_dof1 = lista_pca_nr_dof1.componenti;
scores_dof2 = lista_pca_nr_dof2.componenti;
scores_dof3 = lista_pca_nr_dof3.componenti;
scores_dof4 = lista_pca_nr_dof4.componenti;
scores_dof5 = lista_pca_nr_dof5.componenti;
scores_dof6 = lista_pca_nr_dof6.componenti;
media_dof1 = lista_pca_nr_dof1.media;
media_dof2 = lista_pca_nr_dof2.media;
media_dof3 = lista_pca_nr_dof3.media;
media_dof4 = lista_pca_nr_dof4.media;
media_dof5 = lista_pca_nr_dof5.media;
media_dof6 = lista_pca_nr_dof6.media;

define_sc_sample_num;

% ricostruisco una funzione usando un certo numero di pcs

define_PCS_DOF;
% plotting PC1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% plot aux

%if sample_num == 93
realTrack = Warped_Datasets_mean{sample_num};
%save Savings/realTrack realTrack
PC0All = [media_dof1'+MEAN(sample_num,1); media_dof2'+MEAN(sample_num,2); media_dof3'+MEAN(sample_num,3);...
          media_dof4'+MEAN(sample_num,4); media_dof5'+MEAN(sample_num,5); media_dof6'+MEAN(sample_num,6)];

PC1All = [PC1_dof1'+MEAN(sample_num,1); PC1_dof2'+MEAN(sample_num,2); PC1_dof3'+MEAN(sample_num,3);...
          PC1_dof4'+MEAN(sample_num,4); PC1_dof5'+MEAN(sample_num,5); PC1_dof6'+MEAN(sample_num,6)];
PC2All = [PC2_dof1'+MEAN(sample_num,1); PC2_dof2'+MEAN(sample_num,2); PC2_dof3'+MEAN(sample_num,3);...
          PC2_dof4'+MEAN(sample_num,4); PC2_dof5'+MEAN(sample_num,5); PC2_dof6'+MEAN(sample_num,6)];
PC3All = [PC3_dof1'+MEAN(sample_num,1); PC3_dof2'+MEAN(sample_num,2); PC3_dof3'+MEAN(sample_num,3);...
          PC3_dof4'+MEAN(sample_num,4); PC3_dof5'+MEAN(sample_num,5); PC3_dof6'+MEAN(sample_num,6)];
PC4All = [PC4_dof1'+MEAN(sample_num,1); PC4_dof2'+MEAN(sample_num,2); PC4_dof3'+MEAN(sample_num,3);...
          PC4_dof4'+MEAN(sample_num,4); PC4_dof5'+MEAN(sample_num,5); PC4_dof6'+MEAN(sample_num,6)];
PC5All = [PC5_dof1'+MEAN(sample_num,1); PC5_dof2'+MEAN(sample_num,2); PC5_dof3'+MEAN(sample_num,3);...
          PC5_dof4'+MEAN(sample_num,4); PC5_dof5'+MEAN(sample_num,5); PC5_dof6'+MEAN(sample_num,6)];
PC6All = [PC6_dof1'+MEAN(sample_num,1); PC6_dof2'+MEAN(sample_num,2); PC6_dof3'+MEAN(sample_num,3);...
          PC6_dof4'+MEAN(sample_num,4); PC6_dof5'+MEAN(sample_num,5); PC6_dof6'+MEAN(sample_num,6)];
PC7All = [PC7_dof1'+MEAN(sample_num,1); PC7_dof2'+MEAN(sample_num,2); PC7_dof3'+MEAN(sample_num,3);...
          PC7_dof4'+MEAN(sample_num,4); PC7_dof5'+MEAN(sample_num,5); PC7_dof6'+MEAN(sample_num,6)];
PC8All = [PC8_dof1'+MEAN(sample_num,1); PC8_dof2'+MEAN(sample_num,2); PC8_dof3'+MEAN(sample_num,3);...
          PC8_dof4'+MEAN(sample_num,4); PC8_dof5'+MEAN(sample_num,5); PC8_dof6'+MEAN(sample_num,6)];
PC9All = [PC9_dof1'+MEAN(sample_num,1); PC9_dof2'+MEAN(sample_num,2); PC9_dof3'+MEAN(sample_num,3);...
          PC9_dof4'+MEAN(sample_num,4); PC9_dof5'+MEAN(sample_num,5); PC9_dof6'+MEAN(sample_num,6)];
PC10All = [PC10_dof1'+MEAN(sample_num,1); PC10_dof2'+MEAN(sample_num,2); PC10_dof3'+MEAN(sample_num,3);...
          PC10_dof4'+MEAN(sample_num,4); PC10_dof5'+MEAN(sample_num,5); PC10_dof6'+MEAN(sample_num,6)];

tmp = Warped_Datasets_mean{sample_num};
figure;
subplot(2,3,1);plot(tmp(1,:),'k','LineWidth',2);hold on;
plot(media_dof1(:),'c','LineWidth',2);legend('Real data','Mean');
title('dof1 reconstruction');xlabel('Time Sample');ylabel('mm')

subplot(2,3,2);plot(tmp(2,:),'k','LineWidth',2);hold on;
plot(media_dof2(:),'c','LineWidth',2);legend('Real data','Mean');
title('dof2 reconstruction');xlabel('Time Sample');ylabel('mm')

subplot(2,3,3);plot(tmp(3,:),'k','LineWidth',2);hold on;
plot(media_dof3(:),'c','LineWidth',2);legend('Real data','Mean');
title('dof3 reconstruction');xlabel('Time Sample');ylabel('mm')

subplot(2,3,4);plot(tmp(4,:),'k','LineWidth',2);hold on;
plot(media_dof4(:),'c','LineWidth',2);legend('Real data','Mean');
title('dof4 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,3,5);plot(tmp(5,:),'k','LineWidth',2);hold on;
plot(media_dof5(:),'c','LineWidth',2);legend('Real data','Mean');
title('dof5 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,3,6);plot(tmp(6,:),'k','LineWidth',2);hold on;
plot(media_dof6(:),'c','LineWidth',2);legend('Real data','Mean');
title('dof6 reconstruction');xlabel('Time Sample');ylabel('rad')

plotName = 'Reconstruction';
Subject = ['mean_sample' num2str(sample_num)];

%%

tmp = Warped_Datasets_mean{sample_num};
figure;
subplot(2,3,1);plot(tmp(1,:),'k','LineWidth',2);hold on;
plot(PC1_dof1(:),'r','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof1 reconstruction');xlabel('Time Sample');ylabel('mm')

subplot(2,3,2);plot(tmp(2,:),'k','LineWidth',2);hold on;
plot(PC1_dof2(:),'r','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof2 reconstruction');xlabel('Time Sample');ylabel('mm')

subplot(2,3,3);plot(tmp(3,:),'k','LineWidth',2);hold on;
plot(PC1_dof3(:),'r','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof3 reconstruction');xlabel('Time Sample');ylabel('mm')

subplot(2,3,4);plot(tmp(4,:),'k','LineWidth',2);hold on;
plot(PC1_dof4(:),'r','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof4 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,3,5);plot(tmp(5,:),'k','LineWidth',2);hold on;
plot(PC1_dof5(:),'r','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof5 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,3,6);plot(tmp(6,:),'k','LineWidth',2);hold on;
plot(PC1_dof6(:),'r','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof6 reconstruction');xlabel('Time Sample');ylabel('rad')

plotName = 'Reconstruction';
Subject = ['PC1_sample' num2str(sample_num)];

%%

tmp = Warped_Datasets_mean{sample_num};
figure;
subplot(2,3,1);plot(tmp(1,:),'k','LineWidth',2);hold on;
plot(PC1_dof1(:),'r','LineWidth',2);plot(PC2_dof1(:),'b','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof1 reconstruction');xlabel('Time Sample');ylabel('mm')

subplot(2,3,2);plot(tmp(2,:),'k','LineWidth',2);hold on;
plot(PC1_dof2(:),'r','LineWidth',2);plot(PC2_dof2(:),'b','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof2 reconstruction');xlabel('Time Sample');ylabel('mm')

subplot(2,3,3);plot(tmp(3,:),'k','LineWidth',2);hold on;
plot(PC1_dof3(:),'r','LineWidth',2);plot(PC2_dof3(:),'b','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof3 reconstruction');xlabel('Time Sample');ylabel('mm')

subplot(2,3,4);plot(tmp(4,:),'k','LineWidth',2);hold on;
plot(PC1_dof4(:),'r','LineWidth',2);plot(PC2_dof4(:),'b','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof4 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,3,5);plot(tmp(5,:),'k','LineWidth',2);hold on;
plot(PC1_dof5(:),'r','LineWidth',2);plot(PC2_dof5(:),'b','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof5 reconstruction');xlabel('Time Sample');ylabel('rad')

subplot(2,3,6);plot(tmp(6,:),'k','LineWidth',2);hold on;
plot(PC1_dof6(:),'r','LineWidth',2);plot(PC2_dof6(:),'b','LineWidth',2);legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2');
title('dof6 reconstruction');xlabel('Time Sample');ylabel('rad')

plotName = 'Reconstruction';
Subject = ['PC2_sample' num2str(sample_num)];

%%
tmp = Warped_Datasets_mean{sample_num};
figure;
subplot(2,3,1);plot(tmp(1,:),'k','LineWidth',2);hold on;
plot(PC1_dof1(:),'r','LineWidth',2);plot(PC2_dof1(:),'b','LineWidth',2);plot(PC3_dof1(:),'g','LineWidth',2);
title('dof1 reconstruction');legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2', 'Mean + a_1*PC1 + a_2*PC2 + a_3*PC3');
xlabel('Time Sample');ylabel('mm')

subplot(2,3,2);plot(tmp(2,:),'k','LineWidth',2);hold on;
plot(PC1_dof2(:),'r','LineWidth',2);plot(PC2_dof2(:),'b','LineWidth',2);plot(PC3_dof2(:),'g','LineWidth',2);
title('dof2 reconstruction');legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2', 'Mean + a_1*PC1 + a_2*PC2 + a_3*PC3');
xlabel('Time Sample');ylabel('mm')

subplot(2,3,3);plot(tmp(3,:),'k','LineWidth',2);hold on;
plot(PC1_dof3(:),'r','LineWidth',2);plot(PC2_dof3(:),'b','LineWidth',2);plot(PC3_dof3(:),'g','LineWidth',2);
title('dof3 reconstruction');legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2', 'Mean + a_1*PC1 + a_2*PC2 + a_3*PC3');
xlabel('Time Sample');ylabel('mm')

subplot(2,3,4);plot(tmp(4,:),'k','LineWidth',2);hold on;
plot(PC1_dof4(:),'r','LineWidth',2);plot(PC2_dof4(:),'b','LineWidth',2);plot(PC3_dof4(:),'g','LineWidth',2);
title('dof4 reconstruction');legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2', 'Mean + a_1*PC1 + a_2*PC2 + a_3*PC3');
xlabel('Time Sample');ylabel('rad')

subplot(2,3,5);plot(tmp(5,:),'k','LineWidth',2);hold on;
plot(PC1_dof5(:),'r','LineWidth',2);plot(PC2_dof5(:),'b','LineWidth',2);plot(PC3_dof5(:),'g','LineWidth',2);
title('dof5 reconstruction');legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2', 'Mean + a_1*PC1 + a_2*PC2 + a_3*PC3');
xlabel('Time Sample');ylabel('rad')

subplot(2,3,6);plot(tmp(6,:),'k','LineWidth',2);hold on;
plot(PC1_dof6(:),'r','LineWidth',2);plot(PC2_dof6(:),'b','LineWidth',2);plot(PC3_dof6(:),'g','LineWidth',2);
title('dof6 reconstruction');legend('Real data','Mean + a_1*PC1', 'Mean + a_1*PC1 + a_2*PC2', 'Mean + a_1*PC1 + a_2*PC2 + a_3*PC3');
xlabel('Time Sample');ylabel('rad')

plotName = 'Reconstruction';
Subject = ['PC3_sample' num2str(sample_num)];

%%

l = length(tmp(1,:));
MSE_media_1 = rms([tmp(1,:)-media_dof1']);MSE_media_2 = rms([tmp(2,:)-media_dof2']);MSE_media_3 = rms([tmp(3,:)-media_dof3']);
MSE_media_4 = rms([tmp(4,:)-media_dof4']);MSE_media_5 = rms([tmp(5,:)-media_dof5']);MSE_media_6 = rms([tmp(6,:)-media_dof6']);
MSE_mean_pos = [MSE_media_1 MSE_media_2 MSE_media_3];
MSE_mean_or = [MSE_media_4 MSE_media_5 MSE_media_6];

MSE_PC1_1 = rms([tmp(1,:)-PC1_dof1']);MSE_PC1_2 = rms([tmp(2,:)-PC1_dof2']);MSE_PC1_3 = rms([tmp(3,:)-PC1_dof3']);
MSE_PC1_4 = rms([tmp(4,:)-PC1_dof4']);MSE_PC1_5 = rms([tmp(5,:)-PC1_dof5']);MSE_PC1_6 = rms([tmp(6,:)-PC1_dof6']);
MSE_PC1_pos = [MSE_PC1_1 MSE_PC1_2 MSE_PC1_3];
MSE_PC1_or = [MSE_PC1_4 MSE_PC1_5 MSE_PC1_6];

MSE_PC2_1 = rms([tmp(1,:)-PC2_dof1']);MSE_PC2_2 = rms([tmp(2,:)-PC2_dof2']);MSE_PC2_3 = rms([tmp(3,:)-PC2_dof3']);
MSE_PC2_4 = rms([tmp(4,:)-PC2_dof4']);MSE_PC2_5 = rms([tmp(5,:)-PC2_dof5']);MSE_PC2_6 = rms([tmp(6,:)-PC2_dof6']);
MSE_PC2_pos = [MSE_PC2_1 MSE_PC2_2 MSE_PC2_3];
MSE_PC2_or = [MSE_PC2_4 MSE_PC2_5 MSE_PC2_6];

MSE_PC3_1 = rms([tmp(1,:)-PC3_dof1']);MSE_PC3_2 = rms([tmp(2,:)-PC3_dof2']);MSE_PC3_3 = rms([tmp(3,:)-PC3_dof3']);
MSE_PC3_4 = rms([tmp(4,:)-PC3_dof4']);MSE_PC3_5 = rms([tmp(5,:)-PC3_dof5']);MSE_PC3_6 = rms([tmp(6,:)-PC3_dof6']);
MSE_PC3_pos = [MSE_PC3_1 MSE_PC3_2 MSE_PC3_3];
MSE_PC3_or = [MSE_PC3_4 MSE_PC3_5 MSE_PC3_6];

MSE_PC4_1 = rms([tmp(1,:)-PC4_dof1']);MSE_PC4_2 = rms([tmp(2,:)-PC4_dof2']);MSE_PC4_3 = rms([tmp(3,:)-PC4_dof3']);
MSE_PC4_4 = rms([tmp(4,:)-PC4_dof4']);MSE_PC4_5 = rms([tmp(5,:)-PC4_dof5']);MSE_PC4_6 = rms([tmp(6,:)-PC4_dof6']);
MSE_PC4_pos = [MSE_PC4_1 MSE_PC4_2 MSE_PC4_3];
MSE_PC4_or = [MSE_PC4_4 MSE_PC4_5 MSE_PC4_6];

MSE_PC5_1 = rms([tmp(1,:)-PC5_dof1']);MSE_PC5_2 = rms([tmp(2,:)-PC5_dof2']);MSE_PC5_3 = rms([tmp(3,:)-PC5_dof3']);
MSE_PC5_4 = rms([tmp(4,:)-PC5_dof4']);MSE_PC5_5 = rms([tmp(5,:)-PC5_dof5']);MSE_PC5_6 = rms([tmp(6,:)-PC5_dof6']);
MSE_PC5_pos = [MSE_PC5_1 MSE_PC5_2 MSE_PC5_3];
MSE_PC5_or = [MSE_PC5_4 MSE_PC5_5 MSE_PC5_6];

MSE_PC6_1 = rms([tmp(1,:)-PC6_dof1']);MSE_PC6_2 = rms([tmp(2,:)-PC6_dof2']);MSE_PC6_3 = rms([tmp(3,:)-PC6_dof3']);
MSE_PC6_4 = rms([tmp(4,:)-PC6_dof4']);MSE_PC6_5 = rms([tmp(5,:)-PC6_dof5']);MSE_PC6_6 = rms([tmp(6,:)-PC6_dof6']);
MSE_PC6_pos = [MSE_PC6_1 MSE_PC6_2 MSE_PC6_3];
MSE_PC6_or = [MSE_PC6_4 MSE_PC6_5 MSE_PC6_6];

MSE_PC7_1 = rms([tmp(1,:)-PC7_dof1']);MSE_PC7_2 = rms([tmp(2,:)-PC7_dof2']);MSE_PC7_3 = rms([tmp(3,:)-PC7_dof3']);
MSE_PC7_4 = rms([tmp(4,:)-PC7_dof4']);MSE_PC7_5 = rms([tmp(5,:)-PC7_dof5']);MSE_PC7_6 = rms([tmp(6,:)-PC7_dof6']);
MSE_PC7_pos = [MSE_PC7_1 MSE_PC7_2 MSE_PC7_3];
MSE_PC7_or = [MSE_PC7_4 MSE_PC7_5 MSE_PC7_6];

MSE_PC8_1 = rms([tmp(1,:)-PC8_dof1']);MSE_PC8_2 = rms([tmp(2,:)-PC8_dof2']);MSE_PC8_3 = rms([tmp(3,:)-PC8_dof3']);
MSE_PC8_4 = rms([tmp(4,:)-PC8_dof4']);MSE_PC8_5 = rms([tmp(5,:)-PC8_dof5']);MSE_PC8_6 = rms([tmp(6,:)-PC8_dof6']);
MSE_PC8_pos = [MSE_PC8_1 MSE_PC8_2 MSE_PC8_3];
MSE_PC8_or = [MSE_PC8_4 MSE_PC8_5 MSE_PC8_6];

MSE_PC9_1 = rms([tmp(1,:)-PC9_dof1']);MSE_PC9_2 = rms([tmp(2,:)-PC9_dof2']);MSE_PC9_3 = rms([tmp(3,:)-PC9_dof3']);
MSE_PC9_4 = rms([tmp(4,:)-PC9_dof4']);MSE_PC9_5 = rms([tmp(5,:)-PC9_dof5']);MSE_PC9_6 = rms([tmp(6,:)-PC9_dof6']);
MSE_PC9_pos = [MSE_PC9_1 MSE_PC9_2 MSE_PC9_3];
MSE_PC9_or = [MSE_PC9_4 MSE_PC9_5 MSE_PC9_6];

MSE_PC10_1 = rms([tmp(1,:)-PC10_dof1']);MSE_PC10_2 = rms([tmp(2,:)-PC10_dof2']);MSE_PC10_3 = rms([tmp(3,:)-PC10_dof3']);
MSE_PC10_4 = rms([tmp(4,:)-PC10_dof4']);MSE_PC10_5 = rms([tmp(5,:)-PC10_dof5']);MSE_PC10_6 = rms([tmp(6,:)-PC10_dof6']);
MSE_PC10_pos = [MSE_PC10_1 MSE_PC10_2 MSE_PC10_3];
MSE_PC10_or = [MSE_PC10_4 MSE_PC10_5 MSE_PC10_6];

err_ttl_pos = [rms(MSE_mean_pos) rms(MSE_PC1_pos) rms(MSE_PC2_pos) rms(MSE_PC3_pos) rms(MSE_PC4_pos) rms(MSE_PC5_pos) rms(MSE_PC6_pos)...
    rms(MSE_PC7_pos) rms(MSE_PC8_pos) rms(MSE_PC9_pos) rms(MSE_PC10_pos)];
err_ttl_or = [rms(MSE_mean_or) rms(MSE_PC1_or) rms(MSE_PC2_or) rms(MSE_PC3_or) rms(MSE_PC4_or) rms(MSE_PC5_or) rms(MSE_PC6_or)...
    rms(MSE_PC7_or) rms(MSE_PC8_or) rms(MSE_PC9_or) rms(MSE_PC10_or)];
figure;plot([0:10]',err_ttl_pos,'r*-')
%figure;plot([0:10]',err_ttl/max(err_ttl),'r*-')
xlabel('Number of PCs used')
%ylabel('Normalized error')
ylabel('Error [mm]')
%title('Reconstruction RMS Error (Normalized)')
title('Reconstruction RMS Error')

figure;plot([0:10]',err_ttl_or,'r*-')
%figure;plot([0:10]',err_ttl/max(err_ttl),'r*-')
xlabel('Number of PCs used')
%ylabel('Normalized error')
ylabel('Error [rad]')
%title('Reconstruction RMS Error (Normalized)')
title('Reconstruction RMS Error')