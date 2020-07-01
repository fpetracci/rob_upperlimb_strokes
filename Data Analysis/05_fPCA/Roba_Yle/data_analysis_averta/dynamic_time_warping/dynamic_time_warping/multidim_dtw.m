%%%%%%%%%%%%%%%%%%%%%%%%%% REFERENCES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "Exact indexing of dynamic time warping" Eamonn Keogh, Chotirat Ann Ratanamahatana
% "Multi-Dimensional Dynamic Time Warping for Gesture Recognition" G.A. ten Holt M.J.T. Reinders E.A. Hendriks

close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Dataset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t1 = 0:0.01:pi+pi/6;

s1 = sin(t1)';
%s2 = 3*sin(2*t2)';
%s2 = sin(t1)';
s2 = resample(s1,3,2);
s2 = s2 + rand(length(s2),1)*0.1;
s1 = [zeros(20,1); s1];
s1 = s1 + rand(length(s1),1)*0.1;
s2 = s2 + [0:length(s2)-1]'/(3*length(s2));

t2 = t1*2;
s3 = cos(t2)';

s4 = resample(s3,3,2);
s4 = s4 + rand(length(s4),1)*0.1;
s3 = [zeros(20,1); s3];
s3 = s3 + rand(length(s3),1)*0.1;
s4 = s4 + [0:length(s4)-1]'/(3*length(s4));

S1 = [s1 s3];
S2 = [s2 s4];

figure;
plot(s1,'d');
hold on
plot(s2,'r*');
legend('s1','s2')

figure;
plot(s3,'d');
hold on
plot(s4,'r*');
legend('s3','s4')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%From now on we can use only s1, s2
Ls1 = length(S1);
Ls2 = length(S2);

ns1=size(S1,1);
ns2=size(S2,1);

if size(s1,2)~=size(s1,2)
    error('Error in dtw(): the dimensions of the two input signals do not match.');
end

%w=max(w, abs(ns1-ns2)); % adapt window size

%% initialization distance matrix

D=zeros(ns1,ns2)+Inf; % cache matrix

%% distance matrix calculation
w = Inf;

for i=1:ns1
    for j=max(i-w,1):min(i+w,ns2)%1:ns2
        
        D(i,j) = norm(S1(i,:) - S2(j,:));
        
    end
end
figure;
imshow(D, 'InitialMagnification',10000)  % # you want your cells to be larger than single pixels
colormap(jet) % # to change the default grayscale colormap

%% dynamic time warping of s2

%new_s2 will be a vector of ns1 elem
new_s2 = zeros(ns1,1);
new_s4 = zeros(ns1,1);

for i = 1 : ns1
    [~,I] = min(D(i,:));
    new_s2(i) = s2(I);
    new_s4(i) = s4(I);

end


figure;hold on;
plot(s1,'d');
plot(s2,'r*');
plot(new_s2,'gs','MarkerSize',2)
legend('s1','s2','warped s2')


figure;hold on;
plot(s3,'d');
plot(s4,'r*');
plot(new_s4,'gs','MarkerSize',2)
legend('s1','s2','warped s2')

