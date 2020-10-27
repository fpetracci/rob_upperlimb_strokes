function spider_plot_rPCs(rPCs_mat, flag_col)
%SPIDER_PLOT_RPCS Summary of this function goes here
%   Detailed explanation goes here

% Initialize data points
% flag_col da generare coerente con rPCs_mat
no_col = 0;

if nargin == 1
	warning('default colour: brg');
	no_col = 1;
end

num_col = length(flag_col);
njoints = size(rPCs_mat, 1);

if size(rPCs_mat, 2) ~= num_col
	error('number of rPCs is not equal to number of colour')
end

%% colour choice
h_col = [0 0 1];	% h
s_col = [1 0 0];	% s
la_col = [0 1 0];	% l
ad_col = [1 0 0];	% D
and_col = [1 0 1];	% d
lad_col = [0 1 0];	% F
land_col = [0 1 1];	% f

col = zeros(num_col, 3);

if no_col == 0
	%color choice
	if find(flag_col == 'h')
		% blue for healthy
		n = (find(flag_col == 'h'));
		for i = 1:length(n)
			j = n(i); %- num_col*(i-1)
			col(j, :) = h_col;
		end
	end 

	if find(flag_col == 's')
		% red for stroke
		n = find(flag_col == 's');
		for i = 1:length(n)
			j = n(i); %- num_col*(i-1);
			col(j, :) = s_col;
		end
	end 

	if find(flag_col == 'l')
		% green for less affected
		n = find(flag_col == 'l');
		for i = 1:length(n)
			j = n(i); %- num_col*(i-1);
			col(j, :) = la_col;
		end
	end 

	if find(flag_col == 'D')
		% red for strokes dominant
		n = find(flag_col == 'D');
		for i = 1:length(n)
			j = n(i); %- num_col*(i-1);
			col(j, :) = ad_col;
		end
	end 

	if find(flag_col == 'd')
		% magent for strokes non dominant
		n = find(flag_col == 'd');
		for i = 1:length(n)
			j = n(i); %- num_col*(i-1);
			col(j, :) = and_col;
		end
	end 

	if find(flag_col == 'F')
		% green for less affected dominant
		n = find(flag_col == 'F');
		for i = 1:length(n)
			j = n(i); %- num_col*(i-1);
			col(j, :) = lad_col;
		end
	end 

	if find(flag_col == 'f')
		% cian for less affected non dominant
		n = find(flag_col == 'f');
		for i = 1:length(n)
			j = n(i); %- num_col*(i-1);
			col(j, :) = land_col;
		end
	end 
end
%% main
P = rPCs_mat';

% Spider plot
if no_col == 0
	spider_plot(P,...
    'AxesLabels', {'q_1', 'q_2', 'q_3', 'q_4', 'q_5', 'q_6', 'q_7', 'q_8', 'q_9', 'q_{10}'},...
    'AxesInterval', 4,...
    'AxesPrecision', 1,...
    'AxesDisplay', 'one',...
    'AxesLimits', [-ones(1, njoints); ones(1,njoints)],...
    'FillOption', 'on',...
    'FillTransparency', 0.1,...
	'Color', col,...
    'LineStyle', {'--'},...
    'LineWidth', 1,...
    'AxesFontSize', 12,...
    'LabelFontSize', 10,...
    'Direction', 'clockwise',...%'AxesDirection', {'normal', 'normal', 'normal', 'normal', 'normal'},...
    'AxesLabelsOffset', 0.1,...
    'AxesScaling', 'linear',...
    'AxesColor', [0.8, 0.8, 0.8],...
    'AxesLabelsEdge', 'none');
elseif no_col == 1
	spider_plot(P,...
    'AxesLabels', {'q_1', 'q_2', 'q_3', 'q_4', 'q_5', 'q_6', 'q_7', 'q_8', 'q_9', 'q_{10}'},...
    'AxesInterval', 4,...
    'AxesPrecision', 1,...
    'AxesDisplay', 'one',...
    'AxesLimits', [-ones(1, njoints); ones(1,njoints)],...
    'FillOption', 'on',...
    'FillTransparency', 0.1,...
    'LineStyle', {'--'},...
    'LineWidth', 1,...
    'AxesFontSize', 12,...
    'LabelFontSize', 10,...
    'Direction', 'clockwise',...%'AxesDirection', {'normal', 'normal', 'normal', 'normal', 'normal'},...
    'AxesLabelsOffset', 0.1,...
    'AxesScaling', 'linear',...
    'AxesColor', [0.8, 0.8, 0.8],...
    'AxesLabelsEdge', 'none');
end
end

