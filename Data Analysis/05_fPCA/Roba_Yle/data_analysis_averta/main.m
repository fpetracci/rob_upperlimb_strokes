%close all
clear all
clc

plotsDirName = 'plots/';
addpath('dynamic_time_warping')

%% Let's start

Ntask = 30;

list_of_subj;
               
Nsubj = numel(Subj);
Maxnumrep = 6;
Datasets = cell(Nsubj*Ntask*Maxnumrep,1);

%selected_subj = randsample(1:33,20);

for i = 1:33
    for j = 1 : Ntask
        for k = 1 : Maxnumrep
            try
                filename = ['../Collected_data/' Subj{i} '/EstimatedAngles/EstimatedQArm' AnglesName{i} '_' num2str(j) '_' num2str(k) '.mat'];
                tmp = load(filename);
                tmp = tmp.EstimatedQ;
                
                if tmp == zeros(7,1)
                    continue
                end
                
                if i == 22 && j == 4 && k == 2
                    Datasets{(i-1)*Ntask*Maxnumrep + (j-1)*Maxnumrep + k} = [];

                else
                    Datasets{(i-1)*Ntask*Maxnumrep + (j-1)*Maxnumrep + k} = tmp(:,1:end); %200 150
                end
                
            catch
                Datasets{(i-1)*Ntask*Maxnumrep + (j-1)*Maxnumrep + k} = [];
            end
        end
    end
end

emptycells = find(cellfun(@isempty,Datasets));
Datasets(emptycells) = []; 

% figure, 
% for j = 1 : size(Datasets)
%     tmp = Datasets{j};
%     for i = 1 : 7
%         subplot(2,4,i);hold on;plot(tmp(i,:))
%     end
%     drawnow
% end

%filtering data and remove divergent samples
Filt_Datasets = cell(length(Datasets),1);
Len = [];

hmn=0;
for i = 1 : numel(Datasets)
    
     tmp = Datasets{i};
     if sum(tmp(4,:)<-0.5) == 0 && tmp(2,100) > -1.55 ... 
            && abs(mean(tmp(1,1:10))-mean(tmp(1,end-10:end))) <pi && abs(mean(tmp(1,:)))<pi ...
            && abs(mean(tmp(2,1:10))-mean(tmp(2,end-10:end))) <pi && abs(mean(tmp(2,:)))<pi ...
            && abs(mean(tmp(3,1:10))-mean(tmp(3,end-10:end))) <pi && abs(mean(tmp(3,:)))<pi ...
            && abs(mean(tmp(4,1:10))-mean(tmp(4,end-10:end))) <pi && abs(mean(tmp(4,:)))<pi ...
            && abs(mean(tmp(5,1:10))-mean(tmp(5,end-10:end))) <pi && abs(mean(tmp(5,:)))<pi ...
            && abs(mean(tmp(6,1:10))-mean(tmp(6,end-10:end))) <pi && abs(mean(tmp(6,:)))<pi ...
            && abs(mean(tmp(7,1:10))-mean(tmp(7,end-10:end))) <pi && abs(mean(tmp(7,:)))<pi ...
            
         for j = 1 : 7

            angle_rad = smooth(tmp(j,:),10); %50
            %angle_rad = angle_rad - mean(angle_rad);
            tmp(j,:) = angle_rad;%wrapTo2Pi( angle_rad) ;%- 2*pi*floor( (angle_rad+pi)/(2*pi) ); 
         end
         Filt_Datasets{i} = tmp;

     else
         Filt_Datasets{i} = [];
         hmn = hmn + 1;
     end

    %[a,b] = size(tmp);
    %Len = [Len b];
end
emptycells = find(cellfun(@isempty,Filt_Datasets));
Filt_Datasets(emptycells) = []; 
% 
% figure, 
% for j = 1 : size(Filt_Datasets)
%     tmp = Filt_Datasets{j};
%     for i = 1 : 7
%         subplot(2,4,i);hold on;plot(tmp(i,:))
%     end
%     drawnow
% end

%% WARPING

%select the longest sample

X = 0; l = 0;
for i = 1 : length(Filt_Datasets)
        tmp = Filt_Datasets{i};
        if length(tmp(3,:)) > l && ~isnan(tmp(3,1))
            l = length(tmp(3,:));
            X = i; 
        end
end

% warp everything w.r.t the ---------

RefSign =  Filt_Datasets{1};
Warped_Datasets = cell(length(Filt_Datasets),1);
tic
parfor i = 1 : length(Filt_Datasets)
        tmp = Filt_Datasets{i};
        if ~isnan(tmp(3,10))
            tmp1 = TimeWarpingSingleND(RefSign,tmp);
        else
            tmp1 = RefSign*NaN;
        end
        Warped_Datasets{i} = tmp1(:,1:end);
        disp(['warping done vector ', num2str(i)]);
end
toc

%         figure, 
%         for j = 1 : size(Warped_Datasets,1)
%             tmp = Warped_Datasets{j};
%             for i = 1 : 7
%                 subplot(2,4,i);hold on;plot(tmp(i,:))
%             end
%             drawnow
%         end

save Savings/Datasets Datasets
save Savings/Filt_Datasets Filt_Datasets
save Savings/Warped_Datasets Warped_Datasets

%% Remove the mean values

Warped_Datasets_mean = cell(length(Warped_Datasets),1);

ndata = size(Warped_Datasets_mean,1);

MEAN = zeros(ndata,7);
for i = 1 : ndata
    
        tmp = Warped_Datasets{i};
        for k = 1 : 7
            MEAN(i,k) = mean(tmp(k,:));
            tmp(k,:) = tmp(k,:)-mean(tmp(k,:));
        end
        Warped_Datasets_mean{i} = tmp;

end

% 
% figure, 
% for j = 1 : size(Warped_Datasets_mean)
%     tmp = Warped_Datasets_mean{j};
%     for i = 1 : 7
%         subplot(2,4,i);hold on;plot(tmp(i,:))
%     end
%     drawnow
% end
save Savings/Warped_Datasets_mean Warped_Datasets_mean
save Savings/MEAN MEAN

%% Build Bigm
%   load Savings/Bigm
%   load Savings/Warped_Datasets

cutt_frames = 399;
num_dofs = 7;
num_frames = size(Warped_Datasets{1},2)-cutt_frames;
num_samples = size(Warped_Datasets,1);

Bigm = zeros(num_dofs,num_frames,num_samples);

for i = 1 : num_samples
    tmp = Warped_Datasets{i};
    Bigm(:,:,i) = tmp(:,200:end-200);
end

save Savings/Bigm Bigm

Bigm_extended = zeros(21,571,2648);

for i = 1 : 571
    
    
matrix_i = squeeze(Bigm(:,i,:));
matrix_i_1 = circshift(matrix_i',-1)';
matrix_i_2 = circshift(matrix_i',-2)';
matrix_l = [matrix_i; matrix_i_1; matrix_i_2];

Bigm_extended(:,i,:) = matrix_l;
    
end
save Savings/Bigm_extended Bigm_extended

%Bigm = Bigm_extended;

%% Functional PCA

functional_analysis

%% Workspace analysis
% 
% load (['UpperLimbParametersDEFAndrea.mat'])
% 
% UpperLimbParametersDEF(10) = UpperLimbParametersDEF(10)*2;
% 
% [coeff_All(:,1) coeff_All(:,2) coeff_All(:,3)];
% 
% save WspAnalys
