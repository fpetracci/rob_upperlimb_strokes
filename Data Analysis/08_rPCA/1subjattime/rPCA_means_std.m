%% intro

rPCA_all_subj_RUNME;

%% dominant-non dominant
%subj_Ad: -1 for healthy, 1 for Ad, 0 for And
% Ad	= affected on dominant side
% And	= affected on non-dominant side
subj_Ad = [	-1	-1	-1	-1	-1 ...% healthy
			0	1	1	1	0	1	0	0	1	1	0	0	0	1	1	0	1	1	1];
		%	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24
%% mean and stdv
h_rPC = [];
s_rPC = [];
la_rPC = [];
ad_rPC = [];
lad_rPC = [];
and_rPC = [];
land_rPC = [];

%stacking
sel_rPCs = [1];
for i = 1:length(data_all)
	if isfield(data_all(i).h, 'var_expl')
		h_rPC = cat(1, h_rPC, data_all(i).h.var_expl(sel_rPCs,:));
		
	elseif isfield(data_all(i).s, 'var_expl') && isfield(data_all(i).la, 'var_expl')
		s_rPC = cat(1, s_rPC, data_all(i).s.var_expl(sel_rPCs,:));
		la_rPC = cat(1, la_rPC, data_all(i).la.var_expl(sel_rPCs,:));
		
		if subj_Ad(i) 
			ad_rPC = cat(1, ad_rPC, data_all(i).s.var_expl(sel_rPCs,:));
			lad_rPC = cat(1, lad_rPC, data_all(i).la.var_expl(sel_rPCs,:));
		elseif ~subj_Ad(i)
			and_rPC = cat(1, and_rPC, data_all(i).s.var_expl(sel_rPCs,:));
			land_rPC = cat(1, land_rPC, data_all(i).la.var_expl(sel_rPCs,:));
		end
	end
end

%means
meanh = mean(h_rPC, 1);
means = mean(s_rPC, 1);
meanla = mean(la_rPC, 1);
meanad = mean(ad_rPC, 1);
meanlad = mean(lad_rPC, 1);		
meanand = mean(and_rPC, 1);
meanland = mean(land_rPC, 1);

%variance
varh = var(h_rPC, 1);
vars = var(s_rPC, 1);
varla = var(la_rPC, 1);
varad = var(ad_rPC, 1);
varlad = var(lad_rPC, 1);		
varand = var(and_rPC, 1);
varland = var(land_rPC, 1);	

%standard deviation
stdh = std(h_rPC, 1);
stds = std(s_rPC, 1);
stdla = std(la_rPC, 1);

stdad = std(ad_rPC, 1);
stdlad = std(lad_rPC, 1);		
stdand = std(and_rPC, 1);
stdland = std(land_rPC, 1);	

%% Plots
% healthy, strokes, less affected
figure(1)
clf
plot(meanh', 'b', 'DisplayName', 'Healthy')
hold on
plot(means', 'r', 'DisplayName', 'Stroke')
plot(meanla', 'g', 'DisplayName', 'Less Affected')

a = plot((meanh + stdh)', '--b');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((means + stds)', '--r');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanla + stdla)', '--g');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot((meanh - stdh)', '--b');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((means - stds)', '--r');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanla - stdla)', '--g');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

grid on
legend
title('mean and standard deviation rPC')
xlim([0 240])
ylim([0 100])

% healthy, s_dominant, _non dominant
figure(2)
clf
plot(meanh', 'b', 'DisplayName', 'Healthy')
hold on
plot(meanad', 'r', 'DisplayName', 'Stroke dominant')
plot(meanand', 'm', 'DisplayName', 'Stroke non dominant')

a = plot((meanh + stdh)', '--b');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanad + stdad)', '--r');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanand + stdand)', '--m');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot((meanh - stdh)', '--b');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanad - stdad)', '--r');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanand - stdand)', '--m');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

grid on
legend
title('mean and standard deviation rPC')
xlim([0 240])
ylim([0 100])

% healthy, la_dominant, la_non dominant
figure(3)
clf
plot(meanh', 'b', 'DisplayName', 'Healthy')
hold on
plot(meanad', 'g', 'DisplayName', 'Less Affected dominant')
plot(meanand', 'c', 'DisplayName', 'Less Affected non dominant')

a = plot((meanh + stdh)', '--b');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanlad + stdlad)', '--g');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanland + stdland)', '--c');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot((meanh - stdh)', '--b');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanlad - stdlad)', '--g');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanland - stdland)', '--c');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

grid on
legend
title('mean and standard deviation rPC')
xlim([0 240])
ylim([0 100])

% healthy, s_dominant, s_non dominant, la_dominant, la_non dominant
figure(4)
clf
plot(meanh', 'b', 'DisplayName', 'Healthy')
hold on
plot(meanad', 'r', 'DisplayName', 'Stroke dominant')
plot(meanand', 'm', 'DisplayName', 'Stroke non dominant')
plot(meanlad', 'g', 'DisplayName', 'Less Affected dominant')
plot(meanland', 'c', 'DisplayName', 'Less Affected non dominant')

a = plot((meanh + stdh)', '--b');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanad + stdad)', '--r');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanand + stdand)', '--m');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanlad + stdlad)', '--g');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanland + stdland)', '--c');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = plot((meanh - stdh)', '--b');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanad - stdad)', '--r');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanand - stdand)', '--m');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanlad - stdlad)', '--g');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
a = plot((meanland - stdland)', '--c');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';

grid on
legend
title('mean and standard deviation rPC')
xlim([0 240])
ylim([0 100])