%% set current figure
f_width		= 650;
f_heigth	= 650;
dim_font	= 13;

set(gcf, 'Position',  [200, 0, f_width, f_heigth])
set(findall(gcf,'type','text'),'FontSize', dim_font)           
set(gca,'FontSize', dim_font) 

%% supersizeme
% fh = figure(24);
% supersizeme(1.5, fh)

%% export
filename = 'temp_export.pdf';
f = gcf;
exportgraphics(f, filename, 'BackgroundColor','none', 'ContentType','vector')
% exportgraphics(f, filename, 'BackgroundColor','none', 'ContentType','image')
