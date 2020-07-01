close all
clear all
clc

% EstimatedQTask9 = load('EstimatedAngles/EstimatedQArmGiuseppe4.mat');
% EstimatedQTask10 = load('EstimatedAngles/EstimatedQArmGiuseppe9.mat');
% EstimatedQTask9 = EstimatedQTask9.EstimatedQ;
% EstimatedQTask10 = EstimatedQTask10.EstimatedQ;
% 
% s2 = EstimatedQTask9(3,:)';
% s1 = EstimatedQTask10(3,:)';
% 
% %s1 = smooth(s1,50);
% %s2 = smooth(s2,50);
% 
% figure;
% plot(s1,'d');
% hold on
% plot(s2,'r*');
% legend('s1','s2')
% 
% s1 = [zeros(300,1); s1];
% s1 = resample(s1,2,1);
% 
% s = s1;
% t = s2;


s=rand(500,1);
t=rand(520,1);
w=50;


% if nargin<3
%     w=Inf;
% end

ns=size(s,1);
nt=size(t,1);
if size(s,2)~=size(t,2)
    error('Error in dtw(): the dimensions of the two input signals do not match.');
end
w=max(w, abs(ns-nt)); % adapt window size

%% initialization
D=zeros(ns+1,nt+1)+Inf; % cache matrix
D(1,1)=0;

%% begin dynamic programming
for i=1:ns
    for j=max(i-w,1):min(i+w,nt)
        oost=norm(s(i,:)-t(j,:));
        D(i+1,j+1)=oost+min( [D(i,j+1), D(i+1,j), D(i,j)] );
        
    end
end
d=D(ns+1,nt+1);
figure;
imshow(D, 'InitialMagnification',10000)  % # you want your cells to be larger than single pixels
colormap(jet) % # to change the default grayscale colormap

