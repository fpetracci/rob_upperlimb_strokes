%% intro
clear all; clc;

%% rpca

% given task
ngroup = 1;
% ngroup = ['all'];

tic
data = rpca_all_subj_d_nd_7r(ngroup);
toc

%% Analysis

% A,d = red
% LA,d = green
% A,nd = magenta
% LA,nd = cyan


%number of rows I want to sum in explained variance
nrow = 1;
sel = 1:2;

figure(1)
clf
hold on
plot(data.h.var_expl(1,:)',	'b--',	'Displayname', 'Healthy' )
plot(data.a_d.var_expl(1,:)','r--',	'Displayname', 'A_d' )
plot(data.la_d.var_expl(1,:)','g--',	'Displayname', 'LA_d')
plot(data.a_nd.var_expl(1,:)','m--',	'Displayname', 'A_{nd}')
plot(data.la_nd.var_expl(1,:)','c--',	'Displayname', 'LA_{nd}')

plot(data.h.var_expl(2,:)',	'b:',	 'LineWidth', 1.2)
plot(data.a_d.var_expl(2,:)','r:',	 'LineWidth', 1.2)
plot(data.la_d.var_expl(2,:)','g:',	 'LineWidth', 1.2)
plot(data.a_nd.var_expl(2,:)','m:',	 'LineWidth', 1.2)
plot(data.la_nd.var_expl(2,:)','c:', 'LineWidth', 1.2)


% 
% plot(sum(data.h.var_expl(sel,:),1)',	'b',	'Displayname', 'Healthy', 'LineWidth', 1.2)
% plot(sum(data.a_d.var_expl(sel,:),1)',	'r',	'Displayname', 'A_d', 'LineWidth', 1.2)
% plot(sum(data.la_d.var_expl(sel,:),1)',	'g',	'Displayname', 'LA_d', 'LineWidth', 1.2)
% plot(sum(data.a_nd.var_expl(sel,:),1)',	'm',	'Displayname', 'A_{nd}', 'LineWidth', 1.2)
% plot(sum(data.la_nd.var_expl(sel,:),1)','c',	'Displayname', 'LA_{nd}', 'LineWidth', 1.2)




% plot(sum(data.h.var_expl(sel,:),1)',		'b',	'Displayname', 'Healthy')
% 
% plot(sum(data.a_d.var_expl(sel,:),1)',	'r',	'Displayname', 'A_d')
% plot(sum(data.la_d.var_expl(sel,:),1)',	'g',	'Displayname', 'LA_d')
% 
% plot(sum(data.a_nd.var_expl(sel,:),1)',	'm',	'Displayname', 'A_{nd}')
% plot(sum(data.la_nd.var_expl(sel,:),1)',	'c',	'Displayname', 'LA_{nd}')
grid on
axis([1, 240, 0, 100])
% legend('Healthy', 'A_d', 'LA_d', 'A_{nd}','LA_{nd}')
legend('Healthy', 'A_d', 'LA_d', 'A_{nd}','LA_{nd}', 'first rPC', 'second rPC')
%legend
xlabel('Time [samples] ')
ylabel('% explained variance')

%% spider plot
% flag to save videos
movie_mode = 1;
movie_fps = 24;

figure(3)
clf;
D = zeros(7, 3);
%first three of healthy subjects
for i=1:240
	D(:, 1) = data.h.coeff(:, 1, i);
	D(:, 2) = data.h.coeff(:, 2, i);
	D(:, 3) = data.h.coeff(:, 3, i);
	spider_plot_rPCs_7r(D, 'hDF')
	title('7R: first three rPCs of healthy group')
	drawnow
end

figure(4)
clf;
D = zeros(7, 3);
%first three of less affected dominant subjects
for i=1:240
	D(:, 1) = data.la_d.coeff(:, 1, i);
	D(:, 2) = data.la_d.coeff(:, 2, i);
	D(:, 3) = data.la_d.coeff(:, 3, i);
	spider_plot_rPCs_7r(D, 'hDF')
	title('7R: first three rPCs of less affected dominant group')
	drawnow
end

figure(5)
clf;
D = zeros(7, 3);
%first three of affected dominant subjects
for i=1:240
	D(:, 1) = data.a_d.coeff(:, 1, i);
	D(:, 2) = data.a_d.coeff(:, 2, i);
	D(:, 3) = data.a_d.coeff(:, 3, i);
	spider_plot_rPCs_7r(D, 'hDF')
	title('7R: first three rPCs of affected dominant group')
	drawnow
end

figure(6)
clf;
D = zeros(7, 3);
%first rPC of healthy, less affected and affected dominant subjects
for i=1:240
	D(:, 1) = data.h.coeff(:, 1, i);
	D(:, 2) = data.a_d.coeff(:, 1, i);
	D(:, 3) = data.la_d.coeff(:, 1, i);
	spider_plot_rPCs_7r(D, 'hDF')
	title('7R: first rPC of healthy and dom: affected and less affected')
	drawnow
end

figure(7)
clf;
D = zeros(7, 3);
%first three of less affected non dominant subjects
for i=1:240
	D(:, 1) = data.la_nd.coeff(:, 1, i);
	D(:, 2) = data.la_nd.coeff(:, 2, i);
	D(:, 3) = data.la_nd.coeff(:, 3, i);
	spider_plot_rPCs_7r(D, 'hdf')
	title('7R: first three rPCs of less affected non dominant group')
	drawnow
end

figure(8)
clf;
D = zeros(7, 3);
%first three of affected non dominant subjects
for i=1:240
	D(:, 1) = data.a_nd.coeff(:, 1, i);
	D(:, 2) = data.a_nd.coeff(:, 2, i);
	D(:, 3) = data.a_nd.coeff(:, 3, i);
	spider_plot_rPCs_7r(D, 'hdf')
	title('7R: first three rPCs of affected non dominant group')
	drawnow
end

figure(9)
clf;
D = zeros(7 , 3);
%first rPC of healthy, less affected and affected non dominant subjects
for i=1:240
	D(:, 1) = data.h.coeff(:, 1, i);
	D(:, 2) = data.a_nd.coeff(:, 1, i);
	D(:, 3) = data.la_nd.coeff(:, 1, i);
	spider_plot_rPCs_7r(D, 'hdf')
	title('7R: first rPC of healthy and non dom: affected and less affected')
	drawnow
end

%% with video
figh = figure(10);
clf;
D = zeros(7, 2);
D_b = zeros(7, 2);

%first rPC of strokes dom vs non dom subjects
k = 1;
for i=1:240
	D(:, 1) = data.a_d.coeff(:, 1, i);
	D(:, 2) = data.a_nd.coeff(:, 1, i);

	subplot(1, 2, 1)
	spider_plot_rPCs_7r(D, 'Dd')
	title(['7R: first rPC of dom and non dom affected. Frame: ' num2str(i)])

	D_b(:, 1) = data.la_d.coeff(:, 1, i);
	D_b(:, 2) = data.la_nd.coeff(:, 1, i);

	subplot(1, 2, 2)
	spider_plot_rPCs_7r(D_b, 'Ff')
	title(['7R: first rPC of dom and non dom less affected. Frame: ' num2str(i)])
	drawnow
	% write video
	if movie_mode
		movieVector(k) = getframe(figh);
		% open to fullscreen figure(1) before using the next line
		% movieVector(k) = getframe(figh, [10,10,1910,960]);
		k = k+1;
	end
end
if movie_mode
  movie = VideoWriter('dominant vs non dominant', 'MPEG-4');
  movie.FrameRate = movie_fps;

  open(movie);
  writeVideo(movie, movieVector);
  close(movie);
end

 %% template video
% % write video
%   if movie_mode
%     movieVector(k) = getframe(figh);
%     %open to fullscreen figure(1) before using the next line
%     %movieVector(k) = getframe(figh, [10,10,1910,960]);
%     k = k+1;
%   end
% 
% 
% if movie_mode
%   movie = VideoWriter('movie_heliocentric', 'MPEG-4');
%   movie.FrameRate = movie_fps;
% 
%   open(movie);
%   writeVideo(movie, movieVector);
%   close(movie);
% end