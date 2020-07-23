%fpca2q reconstruct debug
figure(3)
clf
j = 1;
q_recon_mat = fpca2q(fPCA_subj(nsubj).s_joint(j));

plot(q_s(:,j)-mean(q_s(:,j)), 'k--')
hold on
plot(q_recon_mat(:,1,2))
plot(q_recon_mat(:,1,3))
plot(q_recon_mat(:,1,4))
plot(q_recon_mat(:,1,5))
plot(q_recon_mat(:,1,6))


%%
figure(3)
clf
plot(q_recon_s(:,7), 'r')
hold on
plot(q_s(:,7) - mean(q_s(:,7)), 'b')


%% 
figure(3)
clf
plot(q_recon_s(:,7) + mean(q_s(:,7)), 'r')
hold on
plot(q_recon_s+ mean(q_s,1), 'b')

%%

mean(q_s, 2)
