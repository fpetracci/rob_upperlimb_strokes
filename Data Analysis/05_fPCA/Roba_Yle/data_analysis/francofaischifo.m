figure, 

for i = 1 : ndof
    subplot(3,4,i);hold on;plot(dataset_frame(i,:))
end

dataset_frame1 = [];
for i = 1 : 476
    if dataset_frame(10,i) >0
        dataset_frame1 = [dataset_frame1 dataset_frame(:,i)];
    
    else
        i
    end
end

figure, 

for i = 1 : ndof
    subplot(3,4,i);hold on;plot(dataset_frame1(i,:))
end

[coeff_tmp,score_tmp,latent_tmp,tsquared_tmp,explained_tmp] = pca(dataset_frame');

[coeff_tmp,score_tmp,latent_tmp,tsquared_tmp,explained_tmp] = pca(dataset_frame1');



%%
figure
for i = 1 : ndof
    subplot(3,4,i);hold on;plot(PCA_Dataset_All(i,:))
end


hold on
for i = 1 : ndof
    subplot(3,4,i);hold on;plot(coeff_All(i,1)*ones(1,length(PCA_Dataset_All)))
end


hold on
for i = 1 : ndof
    subplot(3,4,i);hold on;plot(Coeffs_1(i,:),'*k')
end

%%

figure
%%%%%% pca per frame %%%%%%
for i =  1: num_samples
    dataset_frame =  squeeze(Bigm(:,:,i));

    hold on
    for j = 1 : ndof
        subplot(3,4,j);hold on;plot(dataset_frame(j,:))
    end
drawnow
end
