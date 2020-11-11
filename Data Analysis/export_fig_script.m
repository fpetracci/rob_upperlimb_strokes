clear
close all
plot(cos(linspace(0, 7, 1000)));

%% set current figure

set(gcf, 'Position',  [200, 0, 650, 650])
%set(gcf, 'Position',  [200, 0, 650, 650], 'color', 'none') 
set(findall(gcf,'type','text'),'FontSize',10)           
set(gca,'FontSize',10) 

f = gcf;

%% export
%exportgraphics(f,'test.pdf', 'ContentType','vector')     
%export_fig('filename', '-dpng', '-transparent', '-r300')
%export_fig('filename', '-dpng', '-r300')

%exportgraphics(gca,'myplot.png','Resolution',300) 

exportgraphics(f,'test.eps','BackgroundColor','none', 'ContentType','vector')
% exportgraphics(f,'test.pdf','BackgroundColor','none', 'ContentType','vector')
%exportgraphics(f,'test.png','BackgroundColor','none')
