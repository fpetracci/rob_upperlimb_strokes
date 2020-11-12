%% parameters

f_width		= 650;
f_heigth	= 650;
dim_font	= 13;

filename = 'rPCA_expl_var_7R_HDND_12.pdf';

%% set current figure

set(gcf, 'Position',  [200, 0, f_width, f_heigth])
set(findall(gcf,'type','text'),'FontSize', dim_font)           
set(gca,'FontSize', dim_font) 

f = gcf;

%% export
exportgraphics(f, filename, 'BackgroundColor','none', 'ContentType','vector')

