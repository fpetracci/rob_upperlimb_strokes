function reconstruct_plot(nsub)
%reconstruct_plot plots the reconstruction error associated with subject
%number given as input.

if nsub <= 0 || nsub >24
	error('subject number must be in [1 24]')
else
	nsubj = nsub;
	if nsub < 6
		disp('healthy subject')
		subj_status = 1;
	else
		disp('stroke subject')
		subj_status = 0;
	end
end
% %% plot E_la vs E_s
% figure(1)
% clf
% title(['Subj ' num2str(nsubj) ' ID '   num2str(ID(nsubj-5)) ])
% plot(E_la, 'g')
% hold on
% plot(E_s, 'r')

figure(nsub)
if subj_status == 0
	
	%% Plot 10R
	% load
	load('E10.mat', 'E_subj10');
	E10 = E_subj10;

	load('E_h_mean10','E_h_mean10');

	E_la = E10(:,:,1);
	E_s = E10(:,:,2);
	E_h = E_h_mean10;

	i_subj = nsubj -5;
	ID = sum(E_la(i_subj,:) - E_s(i_subj,:));
	%figure(1)
	subplot(1,3,1)
	plot(E_la(i_subj,:), 'g', 'DisplayName', 'Less Affected' )
	hold on
	plot(E_s(i_subj,:), 'r', 'DisplayName', 'Stroke')
	plot(E_h, 'b', 'DisplayName', 'Healthy mean')
	%asterisks
	a = plot(E_la(i_subj,:), 'dg' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	a = plot(E_s(i_subj,:), 'dr' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	a = plot(E_h, 'db' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	xlim([1,10])
	ylim([0 inf])
	xlabel('Number of fPCs used')
	ylabel('Reconstruction Error [deg]')
	grid on
	legend
	title(['Stroke subj ' num2str(nsubj) ' ID '   num2str(ID) ': all 10 DOFs'])
	
	%% Plot 7R
	% load
	load('E7.mat', 'E_subj7');
	E7 = E_subj7;

	load('E_h_mean7','E_h_mean7');

	E_la = E7(:,:,1);
	E_s = E7(:,:,2);
	E_h = E_h_mean7;

	i_subj = nsubj -5;
	ID = sum(E_la(i_subj,:) - E_s(i_subj,:));
	%figure(2)
	subplot(1,3,2)
	plot(E_la(i_subj,:), 'g', 'DisplayName', 'Less Affected')
	hold on
	plot(E_s(i_subj,:), 'r', 'DisplayName', 'Stroke')
	plot(E_h, 'b', 'DisplayName', 'Healthy mean')
	%asterisks
	a = plot(E_la(i_subj,:), 'dg' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	a = plot(E_s(i_subj,:), 'dr' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	a = plot(E_h, 'db' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	xlim([1,10])
	ylim([0 inf])

	xlabel('Number of fPCs used')
	ylabel('Reconstruction Error [deg]')
	grid on
	legend
	title(['Stroke subj ' num2str(nsubj) ' ID '   num2str(ID) ': last 7 DOFs'])
	
	%% Plot 3R
	% load
	load('E3.mat', 'E_subj3');
	E3 = E_subj3;

	load('E_h_mean3','E_h_mean3');

	E_la = E3(:,:,1);
	E_s = E3(:,:,2);
	E_h = E_h_mean3;

	i_subj = nsubj -5;
	ID = sum(E_la(i_subj,:) - E_s(i_subj,:));
	%figure(3)
	subplot(1,3,3)
	plot(E_la(i_subj,:), 'g', 'DisplayName', 'Less Affected')
	hold on
	plot(E_s(i_subj,:), 'r', 'DisplayName', 'Stroke')
	plot(E_h, 'b', 'DisplayName', 'Healthy mean')
	%asterisks
	a = plot(E_la(i_subj,:), 'dg' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	a = plot(E_s(i_subj,:), 'dr' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	a = plot(E_h, 'db' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	grid on
	xlabel('Number of fPCs used')
	ylabel('Reconstruction Error [deg]')
	xlim([1,10])
	ylim([0 inf])
	legend
	title(['Stroke subj ' num2str(nsubj) ' ID '   num2str(ID) ': first 3 DOFs'])
	
elseif subj_status == 1
	%% Plot 10R
	% load
	load('E_h_10.mat', 'E_h_10');
	E10 = E_h_10;

	load('E_h_mean10','E_h_mean10');

	E_h_10 = E10;
	E_h = E_h_mean10;

	subplot(1,3,1)
	plot(E_h_10(nsubj,:), 'g', 'DisplayName', 'Healthy' )
	hold on
	plot(E_h, 'b', 'DisplayName', 'Healthy mean')
	%asterisks
	a = plot(E_h_10(nsubj,:), 'dg' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	a = plot(E_h, 'db' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	xlabel('Number of fPCs used')
	ylabel('Reconstruction Error [deg]')
	xlim([1,10])
	ylim([0 inf])
	legend
	title(['Healthy subj ' num2str(nsubj) ': all 10 DOFs'])
	
	%% Plot 7R
	% load
	load('E_h_7.mat', 'E_h_7');
	E7 = E_h_7;

	load('E_h_mean7','E_h_mean7');

	E_h_7 = E7;
	E_h = E_h_mean7;

	subplot(1,3,2)
	plot(E_h_7(nsubj,:), 'g', 'DisplayName', 'Healthy' )
	xlim([1,10])
	ylim([0 inf])
	hold on
	plot(E_h, 'b', 'DisplayName', 'Healthy mean')
	a = plot(E_h_7(nsubj,:), 'dg' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	a = plot(E_h, 'db' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	legend
	title(['Healthy subj ' num2str(nsubj) ': last 7 DOFs'])
%% Plot 3R
	% load
	load('E_h_3.mat', 'E_h_3');
	E3 = E_h_3;

	load('E_h_mean3','E_h_mean3');

	E_h_3 = E3;
	E_h = E_h_mean3;

	subplot(1,3,3)
	plot(E_h_3(nsubj,:), 'g', 'DisplayName', 'Healthy' )
	hold on
	plot(E_h, 'b', 'DisplayName', 'Healthy mean')
	a = plot(E_h_3(nsubj,:), 'dg' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	a = plot(E_h, 'db' );
	a.Annotation.LegendInformation.IconDisplayStyle = 'off';
	xlabel('Number of fPCs used')
	ylabel('Reconstruction Error [deg]')
	xlim([1,10])
	ylim([0 inf])
	legend
	title(['Healthy subj ' num2str(nsubj) ': first 3 DOFs'])
else 
	error('something wrong, cannot plot anything')
end