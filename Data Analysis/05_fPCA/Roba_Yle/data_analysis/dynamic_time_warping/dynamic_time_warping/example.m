close all
clear all
clc


% s=rand(500,1);
% t=rand(500,1);

t1 = 0:0.1:pi+pi/6;

s1 = sin(0.1*t1)';
%s2 = 3*sin(2*t2)';
%s2 = sin(t1)';
ls1 = length(s1);
s2 = resample(s1,2,3);
%s22 = resample(s1,3,2);
%s2 = [s21(1:11) ;s22(25:end)];

%s2 = [zeros(abs(length(s1)-length(s2)),1) ; s2];

%s1 = [s1;zeros(200,1)];
%s2 = [s2;zeros(200,1)];

%s2 = s2 + rand(length(s2),1)*0.1;
%s1 = s1 + rand(length(s1),1)*0.1;

% s1 = [s1; zeros(100,1)+s1(end)]; 
% s2 = [s2; zeros(100,1)+s1(end)]; 
 
%s2 = s2 + [0:length(s2)-1]'/(3*length(s2));

figure;
plot(s1,'d');
hold on
plot(s2,'r*');
legend('s1','s2')


SM = simmx(s1',s2');
figure
 subplot(121)

 imagesc(SM)
 colormap(1-gray)
 
  [p,q,C] = dp(1-SM);

  hold on; plot(q,p,'r'); hold off
  
 subplot(122)
 imagesc(C)
 hold on; plot(q,p,'r'); hold off
 
 
