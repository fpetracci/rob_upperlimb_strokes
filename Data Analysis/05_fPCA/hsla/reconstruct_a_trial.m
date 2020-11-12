%% description
% this script reconstructs and plot a trial using fPCA.


%% load
clear; clc;
ngroup = 1;

save_mode = 1;  %save option

fPCA_struct = fpca_hsla(ngroup);

q_stacked =  fpca_stacker_hsla(ngroup);

%% plots
% we decided to reconstruct an healthy subject trial and the 'nobs' in the
% stacked matrix

nobs = 200;

nfpc_max = 4;
q_reconstructed = zeros(240,10,nfpc_max+1); %+1 for the mean

for j = 1:10 % joint
	figure(j)
	clf
	hold on
	grid on
	[qmat, ~] = fpca2q(fPCA_struct.h_joint(j));
	
	mean_mat	= mean(q_stacked.q_matrix_h,2);
	mean_tmp	= mean_mat(nobs,1,j);
	
	plot(mean_tmp * ones(1,size(q_stacked.q_matrix_h,2)),...
			 'Linewidth',0.5,'DisplayName','Mean of Signal')
		
	hold on
	plot(qmat(:,nobs,2)+mean_tmp,...
		 'Linewidth',0.5,'DisplayName','Mean + fPC1')
	 plot(qmat(:,nobs,3)+mean_tmp,...
		 'Linewidth',0.5,'DisplayName','Mean + fPC1 + fPC2')
	 plot(qmat(:,nobs,4)+mean_tmp,...
		 'Linewidth',0.5,'DisplayName','Mean + fPC1 + fPC2 + fPC3')
	 plot(qmat(:,nobs,5)+mean_tmp,...
		 'Linewidth',0.5,'DisplayName','Mean + fPC1 + fPC2 + fPC3 + fPC4')
	 
	 plot(q_stacked.q_matrix_h(nobs,:,j), ...
			'k--', 'Linewidth',1.5,'DisplayName','Actual Signal')
		legend('Location','best')
		xlabel('Time samples')
		ylabel(' Angular Value [deg]')
		xlim([1 size(q_stacked.q_matrix_h,2)])
		grid on
		title(['Joint number ' num2str(j)]);
		
		hold off
		
		% export in a reconstructed trial vector
		q_reconstructed(:,j,1) = mean_tmp;
		q_reconstructed(:,j,2) = qmat(:,nobs,2)+mean_tmp;
		q_reconstructed(:,j,3) = qmat(:,nobs,3)+mean_tmp;
		q_reconstructed(:,j,4) = qmat(:,nobs,4)+mean_tmp;
		q_reconstructed(:,j,5) = qmat(:,nobs,5)+mean_tmp;
		
		% save
		if save_mode == 1
			drawnow
			%set(gcf, 'Color', 'w');
			set(gcf, 'Position',  [200, 0, 650, 650]) 
			set(gca,'FontSize',13)
			set(legend,'FontSize',10);
			f = gcf
			exportgraphics(f,['recon_fPCA_joint' num2str(j) '_subj150.pdf'],'BackgroundColor','none', 'ContentType','vector')

		end
	
end
	
%% video of real trial

q_anima = q_stacked.q_matrix_h(nobs,:,:);
q_anima = reshape(q_anima, 240,10,1);

arm_gen_movie(q_anima, 1, 20, 2, 'real_trial_H07')

%% video of reconstructed trial
msg = [];
for i = 1:nfpc_max
	msg = cat(2,msg, num2str(i));
	q_plot = q_reconstructed(:,:,i+1); %+1 to avoid plotting mean
	arm_gen_movie(q_plot, 1, 21, 2, ['recon_trial_H07_mean&' msg 'fpc'])
end

 