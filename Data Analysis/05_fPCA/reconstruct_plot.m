%reconstruct PLOTS
function reconstruct_plot(nsub)

if nsub <= 0 || nsub >24
	error('subject number must be in [1 24]')
else
	nsubj = nsub;
	if nsub <= 6
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

if subj_status == 0
	figure(1)
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

	figure(1)
	clf
	plot(E_h_10(nsubj,:), 'g', 'DisplayName', 'Healthy' )
	hold on
	plot(E_h, 'b', 'DisplayName', 'Healthy mean')
	legend
	title(['Healthy subj ' num2str(nsubj) ': all 10 DOFs'])
	
	%% Plot 7R
	% load
	load('E_h_7.mat', 'E_h_7');
	E7 = E_h_7;

	load('E_h_mean7','E_h_mean7');

	E_h_7 = E7;
	E_h = E_h_mean7;

	figure(2)
	clf
	plot(E_h_7(nsubj,:), 'g', 'DisplayName', 'Healthy' )
	hold on
	plot(E_h, 'b', 'DisplayName', 'Healthy mean')
	legend
	title(['Healthy subj ' num2str(nsubj) ': last 7 DOFs'])
%% Plot 3R
	% load
	load('E_h_3.mat', 'E_h_3');
	E3 = E_h_3;

	load('E_h_mean3','E_h_mean3');

	E_h_3 = E3;
	E_h = E_h_mean3;

	figure(3)
	clf
	plot(E_h_3(nsubj,:), 'g', 'DisplayName', 'Healthy' )
	hold on
	plot(E_h, 'b', 'DisplayName', 'Healthy mean')
	legend
	title(['Healthy subj ' num2str(nsubj) ': first 3 DOFs'])
else 
	error('something wrong, cannot plot anything')
end