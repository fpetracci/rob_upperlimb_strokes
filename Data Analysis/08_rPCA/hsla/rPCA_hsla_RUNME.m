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
sel= [1];

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
plot(data.h.var_expl(sel,:)','b')
plot(data.s.var_expl(sel,:)', 'r')
plot(data.la.var_expl(sel,:)', 'g')
grid on
axis([1, 240, 0, 100])
xlabel('Time [samples] ')
ylabel('% explained variance')

%% spider plot animation
figure(3)
clf;
D = zeros(10, 3);
%first three of healthy subjects
for i=1:240
	D(:, 1) = data.h.coeff(:, 1, i);
	D(:, 2) = data.h.coeff(:, 2, i);
	D(:, 3) = data.h.coeff(:, 3, i);
	D(:, 4) = mean_posture(:,1);
	spider_plot_rPCs(D, 'hsl')
	drawnow
end

figure(4)
clf;
D = zeros(10, 4);
%first three of less affected subjects
for i=1:240
	D(:, 1) = data.la.coeff(:, 1, i);
	D(:, 2) = data.la.coeff(:, 2, i);
	D(:, 3) = data.la.coeff(:, 3, i);
	D(:, 4) = mean_posture(:,1);
	spider_plot_rPCs(D, 'hsl')
	drawnow
end

figure(5)
clf;
D = zeros(10, 4);
%first three of stroke subjects
for i=1:240
	D(:, 1) = data.s.coeff(:, 1, i);
	D(:, 2) = data.s.coeff(:, 2, i);
	D(:, 3) = data.s.coeff(:, 3, i);
	D(:, 4) = mean_posture(:,1);
	spider_plot_rPCs(D, 'hsl')
	drawnow
end

%% video
movie_mode = 0;
movie_fps = 24;

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
	if movie_mode
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