% This script plots a simple example to clarify spiderplots


%% intro
clear
clc


%% gen signal
% initial arm pose
q0 = zeros(10,1);

%final arm poses
q1 = q0;
q1(4) = -40;
q1(5) = -30;
q1(7) = 45;
q1(9) = 40;

q2 = q0;
q2(3) = -10;
q2(5) = -50;
q2(6) = -30;
q2(7) = 100;
q2(8) = 60;
q2(9) = 5;

q1_norm = q1/norm(q1,2);

% interpol
n_iter = 240;
q = zeros(10, n_iter);
q_other = q;
q_norm = q;
q_other_norm = q;

for i = 1:n_iter
	q(:,i)		= q0 + q1.*(i/n_iter);
	q_norm(:,i) = q(:,i)/norm(q(:,i),2);
	
	q_other(:,i) = q1 + (q2-q1).*(i/n_iter);
	q_other_norm(:,i) = q_other(:,i)/norm(q_other(:,i),2);
end

%% spiderplots
spider_plot_rPCs(q0, 'h')
spider_plot_rPCs(q1_norm, 'r')

%% spiderplot movie
movie_mode = 1;
movie_fps = 20;

figh = figure(6);
clf;
D = zeros(10, 1);
k = 1;
%first rPC of healthy, less affected and strokes subjects
for i=1:240
	%D(:, 1) = q_norm(:, i);
	D(:, 1) = q_other_norm(:, i);
	spider_plot_rPCs(D, 'h')
	%title(['first rPC of healthy, stroke and less affected. Frame: ' num2str(i)])
	drawnow
	
	% set width
	f_width		= 650;
	f_heigth	= 650;
	dim_font	= 13;
	set(gcf, 'Position',  [200, 0, f_width, f_heigth])
	set(findall(gcf,'type','text'),'FontSize', dim_font)           
	set(gca,'FontSize', dim_font) 
	
	if movie_mode
% 		figh.WindowState = 'maximize';
		movieVector(k) = getframe(figh);
		%open to fullscreen figure(1) before using the next line
% 		movieVector(k) = getframe(figh, [10,10,1910,960]);
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

%% arm final and initial pose
arm_gen_movie(q0, 1, 1)
arm_gen_movie(q1, 1, 1)
arm_gen_movie(q, 1, 1, 2)
arm_gen_movie(q_other, 1, 1, 2)
% view angles
view_ang = [   45, 13];
view(view_ang)

%% arm movie



