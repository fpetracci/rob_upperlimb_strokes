%% set current figure
f_width		= 650;
f_heigth	= 650;
dim_font	= 13;

set(gcf, 'Position',  [200, 0, f_width, f_heigth])
set(findall(gcf,'type','text'),'FontSize', dim_font)           
set(gca,'FontSize', dim_font) 

%% export
filename = 'single_s.pdf';
f = gcf;
exportgraphics(f, filename, 'BackgroundColor','none', 'ContentType','vector')

