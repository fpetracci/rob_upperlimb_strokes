%This scripts plots all explained variances of the group taken into account
%(healthy, stroke, less affected)

%% intro
clear all; close all; clc;
%% rpca

% given task
ngroup = 1;
%ngroup = 'all';
data = rpca_hsla(ngroup);
[mean_posture] = mean_post(ngroup);

%% Analysis sum

%selection of pc
sel= [1 ];

figure(1)
clf
hold on
plot(sum(data.h.var_expl(sel,:),1)','b')
plot(sum(data.s.var_expl(sel,:),1)', 'r')
plot(sum(data.la.var_expl(sel,:),1)', 'g')
grid on
axis([1, 240, 0, 100])
xlabel('Time [samples] ')
ylabel('% explained variance')

%% Analysis

%selection of pc
sel= [1 2];

figure(2)
clf
hold on
plot(data.h.var_expl(1,:)','b--')
plot(data.s.var_expl(1,:)', 'r--')
plot(data.la.var_expl(1,:)', 'g--')

plot(data.h.var_expl(2,:)','b:', 'LineWidth', 1.2)
plot(data.s.var_expl(2,:)', 'r:', 'LineWidth', 1.2)
plot(data.la.var_expl(2,:)', 'g:', 'LineWidth', 1.2)
% 
% plot(sum(data.h.var_expl(sel,:),1)','b', 'LineWidth', 1.2)
% plot(sum(data.s.var_expl(sel,:),1)', 'r', 'LineWidth', 1.2)
% plot(sum(data.la.var_expl(sel,:),1)', 'g', 'LineWidth', 1.2)
grid on
axis([1, 240, 0, 100])
legend('Healthy','Affected','Less Affected', 'first rPC', 'second rPC')
% legend('Healthy','Affected','Less Affected')

xlabel('Time [samples] ')
ylabel('% explained variance')
%%
selr= [1 2 3 4];

figure(50)
clf

hold on
for i=1:max(selr)
	plot3(1:240, i*ones(240, 1), 0* ones(240, 1), 'k')
	plot3(0*ones(100, 1), i*ones(1, 100), linspace(0,100,100), 'k')
	%plot3(linspace(0,100,240), i*ones(1, 100), linspace(0,100,240), 'k')
	plot3(1:240, i*ones(240, 1), data.h.var_expl(i,:)', 'b')
	plot3(1:240, i*ones(240, 1), data.s.var_expl(i,:)', 'r')
	plot3(1:240, i*ones(240, 1), data.la.var_expl(i,:)', 'g')
end
view(50,5);
grid on
%axis([1, 240, 0, 100])
legend('Healthy','Affected','Less Affected')
yticks(selr);

xlabel('Time [samples]')
zlabel('% explained variance')
ylabel('number of used rPCs')
%% spider plot animation
figure(3)
clf;
D = zeros(10, 3);
%first three of healthy subjects
for i=1:240
	D(:, 1) = mean_posture(:,1);
	D(:, 2) = data.h.coeff(:, 1, i);
	D_mean(:, 2) = D_mean(:, 2) + data.h.coeff(:, 1, i);
	D(:, 3) = data.h.coeff(:, 3, i);
	D_mean(:, 3) = D_mean(:, 3) + data.h.coeff(:, 2, i);
	D(:, 4) = data.h.coeff(:, 3, i);
	D_mean(:, 4) = D_mean(:, 4) + data.h.coeff(:, 3, i);
	spider_plot_rPCs(D, 'khsl')
	title(['first 3 rPC of healthy. Frame: ' num2str(i)])
	drawnow
end
figure(11)
clf;
D_mean(:, 1) = mean_posture(:,1);
D_mean(:, 2) = D_mean(:, 2)./240;
D_mean(:, 3) = D_mean(:, 3)./240;
D_mean(:, 4) = D_mean(:, 4)./240;
spider_plot_rPCs(D_mean, 'khsl')
title('mean of first 3 rPC of healthy')
%%
figure(4)
clf;
D = zeros(10, 4);
D_mean = zeros(10, 4);
%first three of less affected subjects
for i=1:240
	D(:, 1) = mean_posture(:,1);
	D(:, 2) = data.la.coeff(:, 1, i);
	D_mean(:, 2) = D_mean(:, 2) + data.la.coeff(:, 1, i);
	D(:, 3) = data.la.coeff(:, 3, i);
	D_mean(:, 3) = D_mean(:, 3) + data.la.coeff(:, 2, i);
	D(:, 4) = data.la.coeff(:, 3, i);
	D_mean(:, 4) = D_mean(:, 4) + data.la.coeff(:, 3, i);
	spider_plot_rPCs(D, 'khsl')
	title(['first 3 rPC of less affected. Frame: ' num2str(i)])
	drawnow
end
figure(11)
clf;
D_mean(:, 1) = mean_posture(:,1);
D_mean(:, 2) = D_mean(:, 2)./240;
D_mean(:, 3) = D_mean(:, 3)./240;
D_mean(:, 4) = D_mean(:, 4)./240;
spider_plot_rPCs(D_mean, 'khsl')
title('mean of first 3 rPC of less affected')
%%
figure(5)
clf;
D = zeros(10, 4);
D_mean = zeros(10, 4);
%first three of stroke subjects
for i=1:240
	D(:, 1) = mean_posture(:,1);
	D(:, 2) = data.s.coeff(:, 1, i);
	D_mean(:, 2) = D_mean(:, 2) + data.s.coeff(:, 1, i);
	D(:, 3) = data.s.coeff(:, 3, i);
	D_mean(:, 3) = D_mean(:, 3) + data.s.coeff(:, 2, i);
	D(:, 4) = data.s.coeff(:, 3, i);
	D_mean(:, 4) = D_mean(:, 4) + data.s.coeff(:, 3, i);
	spider_plot_rPCs(D, 'khsl')
	title(['first 3 rPC of strokes. Frame: ' num2str(i)])
	drawnow
end
figure(11)
clf;
D_mean(:, 1) = mean_posture(:,1);
D_mean(:, 2) = D_mean(:, 2)./240;
D_mean(:, 3) = D_mean(:, 3)./240;
D_mean(:, 4) = D_mean(:, 4)./240;
spider_plot_rPCs(D_mean, 'khsl')
title('mean of first 3 rPC of strokes')
%%
figure(7);
clf;
D = zeros(10, 3);
D_mean = zeros (10, 3);
%first rPC of healthy, less affected and strokes subjects
for i=1:240
	D(:, 1) = data.h.coeff(:, 1, i);
	D_mean(:, 1) = D_mean(:, 1) + data.h.coeff(:, 1, i);
	D(:, 2) = data.s.coeff(:, 1, i);
	D_mean(:, 2) = D_mean(:, 2) + data.s.coeff(:, 1, i);
	D(:, 3) = data.la.coeff(:, 1, i);
	D_mean(:, 3) = D_mean(:, 3) + data.la.coeff(:, 1, i);
	spider_plot_rPCs(D, 'hsl')
	title(['first rPC of healthy, stroke and less affected. Frame: ' num2str(i)])
	drawnow
end	
figure(11)
clf;
D_mean(:, 1) = D_mean(:, 1)./240;
D_mean(:, 2) = D_mean(:, 2)./240;
D_mean(:, 3) = D_mean(:, 3)./240;
spider_plot_rPCs(D_mean, 'hsl')	
title('mean of first rPC of healthy, stroke and less affected')
%% video
movie_mode = 1;
movie_fps = 20;

figh = figure(6);
clf;
D = zeros(10, 4);
k = 1;
%first rPC of healthy, less affected and strokes subjects
for i=1:240
	D(:, 1) = data.h.coeff(:, 1, i);
	D(:, 2) = data.s.coeff(:, 1, i);
	D(:, 3) = data.la.coeff(:, 1, i);
	D(:, 4) = mean_posture(:,1);
	spider_plot_rPCs(D, 'hslm')
	title(['first rPC of healthy, stroke and less affected. Frame: ' num2str(i)])
	drawnow
	
	set(findall(gcf,'type','text'),'FontSize', dim_font)           
	set(gca,'FontSize', dim_font) 
	if movie_mode
		figh.WindowState = 'maximize';
		movieVector(k) = getframe(figh);
		%open to fullscreen figure(1) before using the next line
		%movieVector(k) = getframe(figh, [10,10,1910,960]);
		k = k+1;
	end
end

if movie_mode
  movie = VideoWriter('first rPC of healthy, stroke and less affected', 'MPEG-4');
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