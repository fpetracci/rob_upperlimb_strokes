clear all; close all; clc;
%% rpca

ngroup = 1;
data = rpca_hsla(ngroup);

%%
t = 120;
%% h


figure(1)
clf
spider_plot_rPCs(data.h.coeff(:,1,t), 'h')

% set current figure
f_width		= 650;
f_heigth	= 650;
dim_font	= 13;
set(gcf, 'Position',  [200, 0, f_width, f_heigth])
set(findall(gcf,'type','text'),'FontSize', dim_font)           
set(gca,'FontSize', dim_font) 
% export
filename = ['h' num2str(t) '.pdf'];
f = gcf;
exportgraphics(f, filename, 'BackgroundColor','none', 'ContentType','vector')

%% stroke
figure(1)
clf
spider_plot_rPCs(data.s.coeff(:,1,t), 's')

% set current figure
f_width		= 650;
f_heigth	= 650;
dim_font	= 13;
set(gcf, 'Position',  [200, 0, f_width, f_heigth])
set(findall(gcf,'type','text'),'FontSize', dim_font)           
set(gca,'FontSize', dim_font) 
% export
filename = ['s' num2str(t) '.pdf'];
f = gcf;
exportgraphics(f, filename, 'BackgroundColor','none', 'ContentType','vector')


%% less
figure(1)
clf
spider_plot_rPCs(data.la.coeff(:,1,t), 'l')

% set current figure
f_width		= 650;
f_heigth	= 650;
dim_font	= 13;
set(gcf, 'Position',  [200, 0, f_width, f_heigth])
set(findall(gcf,'type','text'),'FontSize', dim_font)           
set(gca,'FontSize', dim_font) 
% export
filename = ['la' num2str(t) '.pdf'];
f = gcf;
exportgraphics(f, filename, 'BackgroundColor','none', 'ContentType','vector')


%%