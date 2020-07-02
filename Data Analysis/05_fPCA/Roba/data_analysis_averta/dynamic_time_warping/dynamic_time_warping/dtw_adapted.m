%%%%%%%%%%%%%%%%%%%%%%%%%% REFERENCES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "Exact indexing of dynamic time warping" Eamonn Keogh, Chotirat Ann Ratanamahatana
% "Multi-Dimensional Dynamic Time Warping for Gesture Recognition" G.A. ten Holt M.J.T. Reinders E.A. Hendriks

close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Dataset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t1 = 0:0.01:5*pi;

t2 = 0:0.01:2*pi;


s1 = cos(t1)';

s2 = chirp(t2,0.1,5*pi,1.7)';  
 
%s2 = resample(s1,1,3);


% %s22 = resample(s1,3,2);
% %s2 = [s21(1:11) ;s22(25:end)];
% 
 s1 = [ones(200,1); s1];
% 
% s1 = [s1;zeros(200,1)];
% s2 = [s2;zeros(200,1)];
% 
 s2 = s2 + rand(length(s2),1)*0.1;
 s1 = s1 + rand(length(s1),1)*0.1;

 tmp = s1;
 s1 = s2;
 s2 = tmp;
%s1 = [s1; zeros(100,1)+s1(end)]; 
%s2 = [s2; zeros(100,1)+s1(end)]; 
 
%s2 = s2 + [0:length(s2)-1]'/(3*length(s2));


% % % % % % % % % % EstimatedQTask9 = load('EstimatedAngles/EstimatedQArmGiuseppe4.mat');
% % % % % % % % % % EstimatedQTask10 = load('EstimatedAngles/EstimatedQArmGiuseppe9.mat');
% % % % % % % % % % EstimatedQTask9 = EstimatedQTask9.EstimatedQ;
% % % % % % % % % % EstimatedQTask10 = EstimatedQTask10.EstimatedQ;
% % % % % % % % % % 
% % % % % % % % % % s2 = EstimatedQTask9(3,1:end)';
% % % % % % % % % % s1 = EstimatedQTask10(3,1:end)';
% % % % % % % % % % 
% % % % % % % % % % 
% % % % % % % % % % s2 = s2(390:end);
% % % % % % % % % % s1 = s1(390:end);
% % % % % % % % % % % 
% % % % % % % % % % % s1 = s1/max(s1);
% % % % % % % % % % % s2 = s2/max(s2);
% % % % % % % % % % % 
% % % % % % % % % % % s1 = smooth(s1,100);
% % % % % % % % % % % s2 = smooth(s2,100);


% % % s2 = diff(s2);
% % % s1 = diff(s1);
% % % 
% % % s1 = smooth(s1,100);
% % % s2 = smooth(s2,100);
% s1 = [s1(1)*ones(100,1) ; s1];
% s1 = resample(s1,3,1);

figure;
plot(s1,'d');
hold on
plot(s2,'r*');
legend('s1','s2')

%s2 = s2/max(s2);
%s1 = s1/max(s1);

%s1 = [s1; zeros(500,1)]; 
%s2 = [s2; zeros(500,1)]; 


%s1 = [zeros(300,1); s1];
s1 = resample(s1,3,1);

% s1 = [s1; zeros(300,1)+s1(end)]; 
% s2 = [s2; zeros(300,1)+s1(end)]; 
figure;
plot(s1,'d');
hold on
plot(s2,'r*');
legend('s1','s2')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%From now on we can use only s1, s2
Ls1 = length(s1);
Ls2 = length(s2);

ns1=size(s1,1);
ns2=size(s2,1);

if size(s1,2)~=size(s1,2)
    error('Error in dtw(): the dimensions of the two input signals do not match.');
end

%w=max(w, abs(ns1-ns2)); % adapt window size

%% initialization distance matrix

D=zeros(ns1,ns2)+Inf; % cache matrix

%% distance matrix calculation
w = Inf;

for i=1:ns1
    for j=1:ns2
        
        D(i,j) = (s1(i) - s2(j))^2;
        
    end
end
figure;
imshow(D, 'InitialMagnification',10000)  % # you want your cells to be larger than single pixels
%colormap(jet) % # to change the default grayscale colormap

%% dynamic time warping of s2
% D ns1 X ns2

%new_s2 will be a vector of ns1 elem
new_s2 = zeros(ns1,1);

%Boundary Conditions
new_s2(1) = s2(1);
new_s2(end) = s2(end);

a = 1; %index on s1
b = 1; %index on s2

for i = 2 : ns1-1

    [~,I] = min([D(a,b) D(a,b+1:min(b+5,ns2-1))]);
    D(a,b) = Inf;
    a = a+1;
    b = b+I-1;

    new_s2(i) = s2(b);

end


figure;hold on;
plot(s1,'d');
plot(s2,'r*');
plot(new_s2,'gs','MarkerSize',2)
legend('s1','s2','warped s2')

figure;
imshow(D, 'InitialMagnification',10000)  % # you want your cells to be larger than single pixels
%colormap(jet) % # to change the default grayscale colormap
