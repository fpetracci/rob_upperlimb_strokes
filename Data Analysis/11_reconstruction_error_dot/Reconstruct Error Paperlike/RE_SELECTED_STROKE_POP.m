%statistical analysis (p-values) of the reconstruction error (on 3DoFs, 
%7DoFs and 10DoFs) for a selected subset of subjects' groups (h, la, s) by 
%applying Wilcoxon ranksum test

%% load

clear; clc;

load('E3_dot.mat', 'E_subj3')
load('E7_dot.mat', 'E_subj7')
load('E10_dot.mat', 'E_subj10')
load('E_h_3_dot.mat', 'E_h_3')
load('E_h_7_dot.mat', 'E_h_7')
load('E_h_10_dot.mat', 'E_h_10')


%% SELECTED STROKE
%choice = [7 10 11 12 13 14 15 16 19 24]-5;  % select only 10 subj
choice = (6:24) -5;							% select all

RE3_la	= E_subj3(choice,:,1);
RE3_a	= E_subj3(choice,:,2);

RE7_la	= E_subj7(choice,:,1);
RE7_a	= E_subj7(choice,:,2);

RE10_la	= E_subj10(choice,:,1);
RE10_a	= E_subj10(choice,:,2);

k = 1;

p3ala	= ranksum(RE3_a(:,k), RE3_la(:,k));
p7ala	= ranksum(RE7_a(:,k), RE7_la(:,k));
p10ala	= ranksum(RE10_a(:,k), RE10_la(:,k));
pala	= [p3ala p7ala p10ala]

p3ha	= ranksum(E_h_3(:,k), RE3_a(:,k));
p7ha	= ranksum(E_h_7(:,k), RE7_a(:,k));
p10ha	= ranksum(E_h_10(:,k), RE10_a(:,k));
pha		= [p3ha p7ha p10ha]

p3hla	= ranksum(E_h_3(:,k), RE3_la(:,k));
p7hla	= ranksum(E_h_7(:,k), RE7_la(:,k));
p10hla	= ranksum(E_h_10(:,k), RE10_la(:,k));
phla	= [p3hla p7hla p10hla]

%% dominant vs non dominant
clc
%choiced  = [7  11 15 19 24]-5;			% select only a,d inside 10 subj
choiced = [7  8  9  11 14 15 19 20 22 23 24]-5; % select all a,d
%choicend = [10 12 13 14 16]-5;			% select only a,nd inside 10 subj
choicend = [6  10 12 13 16 17 18 21] -5;		% select all a,nd

k = 1 ;  % how many fPC I want to consider

RE3_lad	= E_subj3(choiced,:,1);		%RE3_lad = RE3_lad(:,k);
RE3_ad	= E_subj3(choiced,:,2);		%RE3_ad	= RE3_ad(:,k);

RE7_lad	= E_subj7(choiced,:,1);		%RE7_lad = RE7_lad(:,k);
RE7_ad	= E_subj7(choiced,:,2);		%RE7_ad	= RE7_ad(:,k);

RE10_lad= E_subj10(choiced,:,1);	%RE10_lad = RE10_lad(:,k);
RE10_ad	= E_subj10(choiced,:,2);	%RE10_ad	 = RE10_ad(:,k);


RE3_land	= E_subj3(choicend,:,1);			%RE3_land = RE3_land(:,k);
RE3_and		= E_subj3(choicend,:,2);			%RE3_and  = RE3_and(:,k);

RE7_land	= E_subj7(choicend,:,1);			%RE7_land = RE7_land(:,k);
RE7_and		= E_subj7(choicend,:,2);			%RE7_and	 = RE7_and(:,k);

RE10_land	= E_subj10(choicend,:,1);			%RE10_land = RE10_land(:,k);
RE10_and	= E_subj10(choicend,:,2);			%RE10_and  = RE10_and(:,k);

%confronto affected
p3had	= ranksum(E_h_3(:,k), RE3_ad(:,k));
p7had	= ranksum(E_h_7(:,k), RE7_ad(:,k));
p10had	= ranksum(E_h_10(:,k), RE10_ad(:,k));
phad	= [p3had p7had p10had]

p3hand	= ranksum(E_h_3(:,k), RE3_and(:,k));
p7hand	= ranksum(E_h_7(:,k), RE7_and(:,k));
p10hand	= ranksum(E_h_10(:,k), RE10_and(:,k));
phand	= [p3hand p7hand p10hand]

p3andad		= ranksum(RE3_and(:,k), RE3_ad(:,k));
p7andad		= ranksum(RE7_and(:,k), RE7_ad(:,k));
p10andad	= ranksum(RE10_and(:,k), RE10_ad(:,k));
pandad		= [p3andad p7andad p10andad]

%confront less affected
p3hlad	= ranksum(E_h_3(:,k), RE3_lad(:,k));
p7hlad	= ranksum(E_h_7(:,k), RE7_lad(:,k));
p10hlad	= ranksum(E_h_10(:,k), RE10_lad(:,k));
phlad	= [p3hlad p7hlad p10hlad]

p3hland	= ranksum(E_h_3(:,k), RE3_land(:,k));
p7hland	= ranksum(E_h_7(:,k), RE7_land(:,k));
p10hland	= ranksum(E_h_10(:,k), RE10_land(:,k));
phland	= [p3hland p7hland p10hland]

p3landlad		= ranksum(RE3_land(:,k), RE3_lad(:,k));
p7landlad		= ranksum(RE7_land(:,k), RE7_lad(:,k));
p10landlad	= ranksum(RE10_land(:,k), RE10_lad(:,k));
plandlad		= [p3landlad p7landlad p10landlad]

%confront less affected vs affected
p3adlad	= ranksum(RE3_ad(:,k), RE3_lad(:,k));
p7adlad	= ranksum(RE7_ad(:,k), RE7_lad(:,k));
p10adlad	= ranksum(RE10_ad(:,k), RE10_lad(:,k));
padlad	= [p3adlad p7adlad p10adlad]

p3andland	= ranksum(RE3_and(:,k), RE3_land(:,k));
p7andland	= ranksum(RE7_and(:,k), RE7_land(:,k));
p10andland	= ranksum(RE10_and(:,k), RE10_land(:,k));
pandland	= [p3andland p7andland p10andland]

p3andlad	= ranksum(RE3_and(:,k), RE3_lad(:,k));
p7andlad	= ranksum(RE7_and(:,k), RE7_lad(:,k));
p10andlad	= ranksum(RE10_and(:,k), RE10_lad(:,k));
pandlad		= [p3andlad p7andlad p10andlad]

p3landad	= ranksum(RE3_land(:,k), RE3_ad(:,k));
p7landad	= ranksum(RE7_land(:,k), RE7_ad(:,k));
p10landad	= ranksum(RE10_land(:,k), RE10_ad(:,k));
plandad		= [p3landad p7landad p10landad]
