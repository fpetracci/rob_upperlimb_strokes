% questo script fa il run della procedura su un dataset generato su dati
% randomici tramite il modello sys_ok generato in fitting_system

close all
clear all
clc

Warped_Datasets_rand = cell(1000,1);
s1 = randn(7,1);s1 = s1/norm(s1);
s23 = null(s1');
s2 = s23(:,1);
s3 = s23(:,2);

A = [1   0     0    0 0 0 0;...
     0.33 0.33 0.34 0 0 0 0;...
     0.5 0     0    0 0 0 0;...
     1   0     0    0 0 0 0;...
     0   0     0.66 0 0 0 0.34;...
     0   0     0    0 0 0 1;...
     0   0     0    0 0 0 1];
 
A = [s1 zeros(7,6)];
 
%  data = Warped_Datasets{1};
% 
% IDdata = iddata(data,rand(970,7));
% 
% 
% modelOrder = 8*ones(7,1);
% % Fit an AR model to represent the system
% sys = arx(IDdata,[1*eye(7) 1*eye(7) 0*eye(7)])
% 
% 
% 
% 
% % A = [1  -1.5  0.7];
% % B = [0 1 0.5];
% % m0 = idpoly(A,B);
% u = iddata([],randn(100,7));
% e = iddata([],randn(100,7));
% y = sim(sys,[u]);
% % z = [y,u];
% % m = arx(z,[2 2 1]);
% 
% 
%  
 %A = eye(7);
 
% A = rand(7,7);
% A = [s1'; s23'];A = A';

for i = 1 : 7
    A(i,:) = A(i,:)./norm(A(i,:));
end


% for i = 1 : 7
%     A(i,:) = A(i,:)./sum(A(i,:));
% end

%A


load sys_ok

for i = 1 : 1000
    
% % %     tmp = randn(7,1);
% % %     tk = tmp;
% % %     tk0 = tmp;
% % %     for time = 2 : 500
% % %         tk0 = tk;
% % %         tk =  tmp(:,end);
% % %         % = 0.5*tk + 0.5*tk0 + 0.015*randn(7,1);
% % %         tk1 = 0.9*tk + 1*A*randn(7,1) +0.1*randn(7,1);% + 0.1*randn(7,1);
% % %         tmp = [tmp tk1];
% % %     end
    
in = randn(1000,7);
y = sim(sys,in);
tmp =  y(500:end,[1:7]);% + 0.001*randn(500,7); [1:4 6:7]


%tmp = randn(500,7);

    %tmp =   0.5*s1*randn(1,500) + 0.5*s2*randn(1,500) + 0.5*s3*randn(1,500);
%     U = [s1 s23];
%     S = diag([0.33 0.33 0.24 0.1 0 0 0]);
% 
%     C = U*S*U';
%     
%     mu = zeros(7,1);
%     tmp = mvnrnd(mu,C,500);
    Warped_Datasets_rand{i} = tmp';
end

figure, 
for j = 1 : 100%size(Warped_Datasets_rand)
    tmp = Warped_Datasets_rand{j};
    for i = 1 : size(tmp,1)
        subplot(2,4,i);hold on;plot(tmp(i,:))
    end
    drawnow
end


%% Build Bigm
%load Savings/Bigm
%load Savings/Warped_Datasets

cutt_frames = 0;
num_dofs = size(tmp,1);
num_frames = size(Warped_Datasets_rand{1},2)-cutt_frames;
num_samples = size(Warped_Datasets_rand,1);

Bigm = zeros(num_dofs,num_frames,num_samples);

for i = 1 : num_samples
    tmp = Warped_Datasets_rand{i};
    Bigm(:,:,i) = tmp(:,1:end);
end


%% PCA all
%%%%%% calculate PCA of the whole dataset %%%%%%

PCA_Dataset_All = []; 
 %  Filt_Datasets
for i = 1:length(Warped_Datasets_rand)
    PCA_Dataset_All = [PCA_Dataset_All Warped_Datasets_rand{i}];
end

PCA_Dataset_All = PCA_Dataset_All(:,:);

mean_pose = 0*mean(PCA_Dataset_All')';
PCA_Dataset_All = PCA_Dataset_All - repmat(mean_pose,1,size(PCA_Dataset_All,2));

[coeff_All,score_All,latent_All,tsquared_All,explained_All] = pca(PCA_Dataset_All');

all_ds_syns = coeff_All;


%% PCA in time

plotsDirName = 'randfig/';

%%%%%% define empty vars %%%%%%
for j = 1 : num_dofs
    eval(['Coeffs_',num2str(j),' = [];' ])
    eval(['Explained_',num2str(j),' = [];' ])
end
    
%%%%%% pca per frame %%%%%%
for i = 1 : num_frames
        dataset_frame =  squeeze(Bigm(:,i,:));
        [coeff_frame,~,~,~,explained_frame] = pca(dataset_frame'); 
        
    for j = 1 : num_dofs %for each synergy
        
        eval([ 'Coeffs_',num2str(j),' = [Coeffs_',num2str(j),' coeff_frame(:,',num2str(j),')];' ]); 
        %eval(['Coeffs_',num2str(j),' = [Coeffs_',num2str(j),' coeff_frame(:,',num2str(j),')];' ])
        eval(['Explained_',num2str(j),' = [Explained_',num2str(j),' explained_frame(',num2str(j),')];' ])
    end
    
end

%%%%%% plot variances %%%%%%
figure, plot(Explained_1,'*r'), hold on, plot(Explained_2,'*g'), hold on,...
    plot(Explained_3,'*b'), hold on, plot(Explained_1+Explained_2+Explained_3,'*k')
title('Explained Variances'), legend('S1','S2','S3','S1+S2+S3'), ylim([0,100]);
plotName = 'Expl_variances'; subfolder = 'pca/';
saveas(gcf,strcat(plotsDirName,subfolder,'fig/',plotName,'.fig'));
saveas(gcf,strcat(plotsDirName,subfolder,'jpg/',plotName,'.jpg'));

%%%%%% plot the t.v. synergies coefficients %%%%%%
for j = 1 : 3% 7
    figure,     
    for i = 1 : size(tmp,1)
      subplot(2,4,i);hold on;plot(eval(['Coeffs_',num2str(j),'(i,:)']),'r*'),ylim([-1 1]),xlim([0 length(eval(['Coeffs_',num2str(j),'(i,:)']))]);
    end
    
    text(-1000,4,['Time variant values of Syn ',num2str(j),' coefficients.'],'FontSize',14,'FontWeight','bold')
    plotName = ['Syn_' num2str(j) '_tv_coeffs']; subfolder = 'pca/';
    saveas(gcf,strcat(plotsDirName,subfolder,'fig/',plotName,'.fig'));
    saveas(gcf,strcat(plotsDirName,subfolder,'jpg/',plotName,'.jpg'));
end

%%%%%% plot the s1 alphas w.r.t. coeff_all %%%%%%

Sub_1 = [coeff_All(:,1) ];
Alphas = [];
Alphas1 = [];
for i = 1 : num_frames
    Sub_i = [Coeffs_1(:,i) ];
    alpha = subspacea(Sub_1, Sub_i);
    alpha1 = subspace(Sub_1, Sub_i);
    
    Alphas = [Alphas alpha];
    Alphas1 = [Alphas1 alpha1];
end
w=Alphas;figure,plot(rad2deg(Alphas')),hold on,plot(rad2deg(w),'*r')
title('Subspace similarity between the first all-data syns and the correspondent t.d. syns')
plotName = 'Alphas_3_all'; subfolder = 'pca/';
saveas(gcf,strcat(plotsDirName,subfolder,'fig/',plotName,'.fig'));
saveas(gcf,strcat(plotsDirName,subfolder,'jpg/',plotName,'.jpg'));
w1=w;
%%%%%% plot the s2 alphas w.r.t. coeff_all %%%%%%

Sub_1 = [coeff_All(:,2)];
Alphas = [];
Alphas1 = [];
for i = 1 : num_frames
    Sub_i = [Coeffs_2(:,i)];
    alpha = subspacea(Sub_1, Sub_i);
    alpha1 = subspace(Sub_1, Sub_i);
    
    Alphas = [Alphas alpha];
    Alphas1 = [Alphas1 alpha1];
end
w=Alphas;figure,plot(rad2deg(Alphas')),hold on,plot(rad2deg(w),'*r')
title('Subspace similarity between the second all-data syns and the correspondent t.d. syns')
plotName = 'Alphas_3_all'; subfolder = 'pca/';
saveas(gcf,strcat(plotsDirName,subfolder,'fig/',plotName,'.fig'));
saveas(gcf,strcat(plotsDirName,subfolder,'jpg/',plotName,'.jpg'));
w2=w;

%%%%%% plot the s3 alphas w.r.t. coeff_all %%%%%%

Sub_1 = [coeff_All(:,3)];
Alphas = [];
Alphas1 = [];
for i = 1 : num_frames
    Sub_i = [Coeffs_3(:,i)];
    alpha = subspacea(Sub_1, Sub_i);
    alpha1 = subspace(Sub_1, Sub_i);
    
    Alphas = [Alphas alpha];
    Alphas1 = [Alphas1 alpha1];
end
w=Alphas;figure,plot(rad2deg(Alphas')),hold on,plot(rad2deg(w),'*r')
title('Subspace similarity between the third all-data syns and the correspondent t.d. syns')
plotName = 'Alphas_3_all'; subfolder = 'pca/';
saveas(gcf,strcat(plotsDirName,subfolder,'fig/',plotName,'.fig'));
saveas(gcf,strcat(plotsDirName,subfolder,'jpg/',plotName,'.jpg'));
w3=w;

%%%%%% plot the s4 alphas w.r.t. coeff_all %%%%%%

% Sub_1 = [coeff_All(:,4)];
% Alphas = [];
% Alphas1 = [];
% for i = 1 : num_frames
%     Sub_i = [Coeffs_4(:,i)];
%     alpha = subspacea(Sub_1, Sub_i);
%     alpha1 = subspace(Sub_1, Sub_i);
%     
%     Alphas = [Alphas alpha];
%     Alphas1 = [Alphas1 alpha1];
% end
% w=Alphas;figure,plot(rad2deg(Alphas')),hold on,plot(rad2deg(w),'*r')
% title('Subspace similarity between the third all-data syns and the correspondent t.d. syns')
% plotName = 'Alphas_3_all'; subfolder = 'pca/';
% saveas(gcf,strcat(plotsDirName,subfolder,'fig/',plotName,'.fig'));
% saveas(gcf,strcat(plotsDirName,subfolder,'jpg/',plotName,'.jpg'));
% w4=w;

%%%%%% plot the s1-s2-s3 alphas w.r.t. coeff_all %%%%%%

Sub_1 = [coeff_All(:,1) coeff_All(:,2) coeff_All(:,3)];
Alphas = [];
Alphas1 = [];
for i = 1 : num_frames
    Sub_i = [Coeffs_1(:,i) Coeffs_2(:,i) Coeffs_3(:,i)];
    alpha = subspacea(Sub_1, Sub_i);
    alpha1 = subspace(Sub_1, Sub_i);
    
    Alphas = [Alphas alpha];
    Alphas1 = [Alphas1 alpha1];
end
w=vecnorm(Alphas);figure,plot(rad2deg(Alphas')),hold on,plot(rad2deg(w),'*r')
title('Subspace similarity between the first three all-data syns and the correspondent t.d. syns')
plotName = 'Alphas_3_all'; subfolder = 'pca/';
saveas(gcf,strcat(plotsDirName,subfolder,'fig/',plotName,'.fig'));
saveas(gcf,strcat(plotsDirName,subfolder,'jpg/',plotName,'.jpg'));
w123 = w;

mean(rad2deg(w123))
std(rad2deg(w123))
%mean_syns = [mean(Coeffs_1')' mean(Coeffs_2')' mean(Coeffs_3')' mean(Coeffs_4')' mean(Coeffs_5')' mean(Coeffs_6')' mean(Coeffs_7')'];

% 
% Sub_1 = [coeff_All(:,:)];
% Alphas = [];
% Alphas1 = [];
% for i = 1 : num_frames
%     Sub_i = [Coeffs_1(:,i) Coeffs_2(:,i) Coeffs_3(:,i) Coeffs_4(:,i) Coeffs_5(:,i) Coeffs_6(:,i) Coeffs_7(:,i)];
%     alpha = subspacea(Sub_1, Sub_i);
%     alpha1 = subspace(Sub_1, Sub_i);
%     
%     Alphas = [Alphas alpha];
%     Alphas1 = [Alphas1 alpha1];
% end
% w=vecnorm(Alphas);figure,plot(rad2deg(Alphas')),hold on,plot(rad2deg(w),'*r')
% title('Subspace similarity between the first three all-data syns and the correspondent t.d. syns')
% plotName = 'Alphas_3_all'; subfolder = 'pca/';
% saveas(gcf,strcat(plotsDirName,subfolder,'fig/',plotName,'.fig'));
% saveas(gcf,strcat(plotsDirName,subfolder,'jpg/',plotName,'.jpg'));
% 


%% kpsstest
% % % [a, b] = kpsstest(w1(1:end))
% % % kpsstest(w2)
% % % kpsstest(w3)
% % % %kpsstest(w4)
% % % kpsstest(w123)